#Requires -Version 7.4
[CmdletBinding()]
param([string]$Fixtures)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$originalCopyfileSetting = $env:COPYFILE_DISABLE
$originalClaudeConfigDir = $env:CLAUDE_CONFIG_DIR
$env:COPYFILE_DISABLE = '1'
$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$temporaryRoot = if ($IsMacOS) { '/private/tmp' } else { [IO.Path]::GetTempPath() }
$work = Join-Path $temporaryRoot ([Guid]::NewGuid().ToString())
[void][IO.Directory]::CreateDirectory($work)
$installer = Join-Path $repoRoot 'scripts/install-ai-agent-skills.ps1'
function Test-Condition {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}
function Test-InstallerFailure {
    param([hashtable]$Options, [string]$Expected)
    $caught = $false
    try { & $installer @Options }
    catch {
        $caught = $true
        if ($_.Exception.Message -notlike "*$Expected*") { throw }
    }
    Test-Condition $caught "Expected installer failure: $Expected"
}
function Get-TreeSnapshot {
    param([string]$Path)
    $prefix = $Path.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    @(Get-ChildItem -LiteralPath $Path -Recurse -File -Force | Sort-Object FullName | ForEach-Object {
        $relative = $_.FullName.Substring($prefix.Length)
        "$relative $((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)"
    })
}
try {
    if (-not $Fixtures) {
        $Fixtures = Join-Path $work 'assets'
        [void][IO.Directory]::CreateDirectory($Fixtures)
        foreach ($targetHost in @('cursor', 'codex', 'claude', 'copilot', 'opencode', 'skills', 'native-agents')) {
            Write-Output "Preparing $targetHost test bundle."
            $packageName = "ai-agent-skills-$targetHost"
            Push-Location $repoRoot
            try { & go run ./cmd/skillpack -target $targetHost -out (Join-Path $work $packageName) }
            finally { Pop-Location }
            if ($LASTEXITCODE -ne 0) { throw 'Fixture build failed.' }
            & tar -czf (Join-Path $Fixtures "$packageName-v1.0.1.tar.gz") -C $work $packageName
            if ($LASTEXITCODE -ne 0) { throw 'Fixture archive failed.' }
        }
        Set-Content -LiteralPath (Join-Path $Fixtures 'SOURCE_COMMIT') -Value '0123456789012345678901234567890123456789' -Encoding utf8NoBOM
        $sums = foreach ($file in Get-ChildItem -LiteralPath $Fixtures -File) {
            "$((Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLower())  $($file.Name)"
        }
        $sums | Set-Content -LiteralPath (Join-Path $Fixtures 'SHA256SUMS') -Encoding utf8NoBOM
    }
    $downloadState = @{ Root = $Fixtures; FailCatalogWrite = $false; LockCatalog = $false; CatalogPath = $null; LockStream = $null }
    # Mock only HTTP and one catalog-write failure; execute filesystem/JSON/hash code for real.
    function global:Invoke-WebRequest {
        param([string]$Uri, [string]$OutFile, [int]$TimeoutSec)
        if ($TimeoutSec -le 0) { throw 'Expected a bounded download timeout.' }
        Copy-Item -LiteralPath (Join-Path $downloadState.Root ([IO.Path]::GetFileName($Uri))) -Destination $OutFile
    }
    function global:Invoke-RestMethod {
        param([string]$Uri, [int]$TimeoutSec)
        if (-not $Uri.EndsWith('/releases/latest') -or $TimeoutSec -le 0) { throw 'Unexpected version lookup.' }
        return @{ tag_name = 'v1.0.1' }
    }
    function global:Set-Content {
        [CmdletBinding()]
        param([string]$LiteralPath, [Parameter(ValueFromPipeline)]$Value, [string]$Encoding)
        begin { $values = [Collections.Generic.List[object]]::new() }
        process { $values.Add($Value) }
        end {
            if ($downloadState.FailCatalogWrite -and $LiteralPath -like '*marketplace.json.*.tmp') { throw 'Injected catalog write failure.' }
            Microsoft.PowerShell.Management\Set-Content -LiteralPath $LiteralPath -Value $values.ToArray() -Encoding $Encoding
            if ($downloadState.LockCatalog -and $LiteralPath -like '*marketplace.json.*.tmp') {
                $downloadState.LockStream = [IO.File]::Open($downloadState.CatalogPath, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
            }
        }
    }
    foreach ($mock in @('Invoke-WebRequest', 'Invoke-RestMethod', 'Set-Content')) {
        $body = (Get-Item "Function:$mock").ScriptBlock.GetNewClosure()
        Set-Item -Path "Function:global:$mock" -Value $body
    }
    $testHome = Join-Path $work 'home'
    $env:CLAUDE_CONFIG_DIR = Join-Path $testHome 'claude profile'
    $projectPath = Join-Path $work 'project with spaces'
    [void][IO.Directory]::CreateDirectory($testHome)
    [void][IO.Directory]::CreateDirectory($projectPath)
    $catalog = Join-Path $testHome '.agents/plugins/marketplace.json'
    [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($catalog))
    $instructionSentinels = @(
        (Join-Path $testHome '.cursor/rules/user.mdc'),
        (Join-Path $testHome '.codex/AGENTS.md'),
        (Join-Path $testHome '.claude/CLAUDE.md'),
        (Join-Path $env:CLAUDE_CONFIG_DIR 'CLAUDE.md'),
        (Join-Path $testHome '.copilot/copilot-instructions.md'),
        (Join-Path $testHome '.config/opencode/AGENTS.md'),
        (Join-Path $testHome '.gemini/GEMINI.md'),
        (Join-Path $testHome '.agents/AGENTS.md')
    )
    foreach ($file in $instructionSentinels) {
        [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($file))
        Set-Content -LiteralPath $file -Value 'Keep user instructions' -Encoding utf8NoBOM
    }
    Set-Content -LiteralPath $catalog -Value '{"name":"existing","interface":{"displayName":"Existing"},"createdAt":"2026-10-13T00:00:00+05:30","plugins":[{"name":"other-plugin","source":"./other"}]}' -Encoding utf8NoBOM
    foreach ($flavor in @('cursor', 'cursor-global', 'codex-desktop', 'codex-marketplace', 'codex-global', 'claude', 'claude-global', 'claude-project', 'copilot-staging', 'copilot-skills', 'copilot-global', 'codex-skills', 'opencode-project', 'opencode-global', 'gemini-project', 'gemini-global', 'muse-project', 'muse-global', 'antigravity-project', 'antigravity-global', 'antigravity-cli-global')) {
        Write-Output "Testing $flavor."
        $flavorHome = $testHome
        if ($flavor -eq 'codex-global') {
            $flavorHome = Join-Path $work 'codex-global-home'
            [void][IO.Directory]::CreateDirectory($flavorHome)
            [void][IO.Directory]::CreateDirectory((Join-Path $flavorHome '.codex'))
            [void][IO.Directory]::CreateDirectory((Join-Path $flavorHome '.agents'))
            Set-Content -LiteralPath (Join-Path $flavorHome '.codex/AGENTS.md') -Value 'Keep alternate-home instructions' -Encoding utf8NoBOM
            Set-Content -LiteralPath (Join-Path $flavorHome '.agents/AGENTS.md') -Value 'Keep alternate-home instructions' -Encoding utf8NoBOM
        }
        $options = @{ Flavor = $flavor; Version = 'v1.0.1'; Yes = $true; HomeDirectory = $flavorHome }
        if ($flavor -eq 'codex-marketplace') { $options.MarketplaceRoot = Join-Path $work 'marketplace' }
        if ($flavor -in @('copilot-skills', 'codex-skills', 'opencode-project', 'gemini-project', 'muse-project', 'antigravity-project', 'claude-project')) { $options.Project = $projectPath }
        if ($flavor -in @('muse-project', 'antigravity-project')) {
            $options.Project = Join-Path $work "$flavor with spaces"
            [void][IO.Directory]::CreateDirectory($options.Project)
        }
        & $installer @options
        $skillRoot = switch ($flavor) {
            'copilot-global' { Join-Path $testHome '.copilot/skills' }
            'cursor-global' { Join-Path $testHome '.cursor/skills' }
            'codex-global' { Join-Path $flavorHome '.agents/skills' }
            'claude-global' { Join-Path $env:CLAUDE_CONFIG_DIR 'skills' }
            'claude-project' { Join-Path $projectPath '.claude/skills' }
            'copilot-skills' { Join-Path $projectPath '.github/skills' }
            'codex-skills' { Join-Path $projectPath '.agents/skills' }
            'opencode-project' { Join-Path $projectPath '.opencode/skills' }
            'opencode-global' { Join-Path $testHome '.config/opencode/skills' }
            'gemini-project' { Join-Path $projectPath '.gemini/skills' }
            'gemini-global' { Join-Path $testHome '.gemini/skills' }
            'muse-project' { Join-Path $options.Project '.agents/skills' }
            'muse-global' { Join-Path $testHome '.agents/skills' }
            'antigravity-project' { Join-Path $options.Project '.agents/skills' }
            'antigravity-global' { Join-Path $testHome '.gemini/config/skills' }
            'antigravity-cli-global' { Join-Path $testHome '.gemini/antigravity-cli/skills' }
            default { $null }
        }
        $installRoot = if ($skillRoot) { $skillRoot } else {
            switch ($flavor) {
                'cursor' { Join-Path $testHome '.cursor/plugins/local/ai-agent-skills' }
                'codex-desktop' { Join-Path $testHome '.codex/plugins/ai-agent-skills' }
                'codex-marketplace' { Join-Path $work 'marketplace/plugins/ai-agent-skills' }
                'claude' { Join-Path $testHome '.local/share/ai-agent-skills/claude' }
                'copilot-staging' { Join-Path $testHome '.local/share/ai-agent-skills/copilot' }
            }
        }
        if ($skillRoot) {
            Test-Condition (Test-Path -LiteralPath (Join-Path $skillRoot 'test-authoring/references/scope-and-state.md')) 'Skill reference missing.'
            Test-Condition (-not (Test-Path -LiteralPath (Join-Path $skillRoot 'plugin.json'))) 'Plugin manifest shipped as a skill.'
            [void][IO.Directory]::CreateDirectory((Join-Path $skillRoot 'unrelated'))
            Set-Content -LiteralPath (Join-Path $skillRoot 'unrelated/file') -Value 'Keep me' -Encoding utf8NoBOM
            Set-Content -LiteralPath (Join-Path $skillRoot 'test-authoring/SKILL.md') -Value 'Old content' -Encoding utf8NoBOM
        }
        Test-InstallerFailure $options 'Destination exists'
        $options.Action = 'Update'
        if ($flavor -in @('cursor-global', 'codex-global', 'claude-global', 'claude-project', 'copilot-skills', 'copilot-global', 'codex-skills', 'opencode-project', 'opencode-global', 'gemini-project', 'gemini-global', 'muse-project', 'muse-global', 'antigravity-project', 'antigravity-global', 'antigravity-cli-global')) { $options.Merge = $true }
        & $installer @options
        $beforeSnapshot = Get-TreeSnapshot $installRoot
        & $installer @options
        $afterSnapshot = Get-TreeSnapshot $installRoot
        Test-Condition (($beforeSnapshot -join "`n") -eq ($afterSnapshot -join "`n")) 'Repeated update changed installed files.'
        if ($skillRoot) {
            Test-Condition ((Get-Content -LiteralPath (Join-Path $skillRoot 'unrelated/file') -Raw).Trim() -eq 'Keep me') 'Merge lost unknown skills.'
            Test-Condition ((Get-Content -LiteralPath (Join-Path $skillRoot 'test-authoring/SKILL.md') -Raw) -match 'name: test-authoring') 'Update did not replace incoming skill.'
        }
        if ($flavor -eq 'codex-global') {
            Test-Condition ((Get-Content -LiteralPath (Join-Path $flavorHome '.codex/AGENTS.md') -Raw).Trim() -eq 'Keep alternate-home instructions') 'Global install changed Codex instructions.'
            Test-Condition ((Get-Content -LiteralPath (Join-Path $flavorHome '.agents/AGENTS.md') -Raw).Trim() -eq 'Keep alternate-home instructions') 'Global install changed shared instructions.'
        }
    }
    foreach ($hostName in @('opencode', 'claude', 'codex', 'cursor', 'copilot', 'gemini', 'antigravity')) {
        foreach ($scope in @('global', 'project')) {
            $flavor = "$hostName-agents-$scope"
            $options = @{ Flavor = $flavor; Version = 'v1.0.1'; Yes = $true; HomeDirectory = $testHome }
            if ($scope -eq 'project') {
                $options.Project = $projectPath
                $relative = switch ($hostName) { 'cursor' { '.cursor/agents' } 'copilot' { '.github/agents' } 'gemini' { '.gemini/agents' } 'antigravity' { '.agents/agents' } default { ".$hostName/agents" } }
                $root = Join-Path $projectPath $relative
            } else {
                $root = switch ($hostName) {
                    'opencode' { Join-Path $testHome '.config/opencode/agents' }
                    'claude' { Join-Path $env:CLAUDE_CONFIG_DIR 'agents' }
                    'codex' { Join-Path $testHome '.codex/agents' }
                    'cursor' { Join-Path $testHome '.cursor/agents' }
                    'copilot' { Join-Path $testHome '.copilot/agents' }
                    'gemini' { Join-Path $testHome '.gemini/agents' }
                    'antigravity' { Join-Path $testHome '.gemini/config/agents' }
                }
            }
            & $installer @options
            $extension = if ($hostName -eq 'codex') { 'toml' } elseif ($hostName -eq 'copilot') { 'agent.md' } else { 'md' }
            foreach ($agentName in @('architecture-advisor', 'dependency-investigator', 'independent-reviewer', 'root-cause-investigator')) {
                Test-Condition (Test-Path -LiteralPath (Join-Path $root "$agentName.$extension")) "Agent missing: $flavor $agentName"
            }
            Set-Content -LiteralPath (Join-Path $root "custom.$extension") -Value 'Keep unrelated agent' -Encoding utf8NoBOM
            Set-Content -LiteralPath (Join-Path $root "independent-reviewer.$extension") -Value 'User modification' -Encoding utf8NoBOM
            $options.Action = 'Update'
            Test-InstallerFailure $options 'Destination exists'
            Test-Condition ((Get-Content -LiteralPath (Join-Path $root "independent-reviewer.$extension") -Raw).Trim() -eq 'User modification') 'Refused update lost a user modification.'
            $options.Merge = $true
            & $installer @options
            Test-Condition ((Get-Content -LiteralPath (Join-Path $root "custom.$extension") -Raw).Trim() -eq 'Keep unrelated agent') 'Merge lost a custom agent.'
            Test-Condition ((Get-Content -LiteralPath (Join-Path $root "independent-reviewer.$extension") -Raw) -match 'Do not') 'Merge did not update incoming agent.'
            $beforeSnapshot = Get-TreeSnapshot $root
            & $installer @options
            Test-Condition (($beforeSnapshot -join "`n") -eq ((Get-TreeSnapshot $root) -join "`n")) 'Repeated agent update changed files.'
        }
    }
    foreach ($file in $instructionSentinels) {
        Test-Condition ((Get-Content -LiteralPath $file -Raw).Trim() -eq 'Keep user instructions') "Installer changed user instructions: $file"
    }
    $env:CLAUDE_CONFIG_DIR = $null
    $claudeDefaultOptions = @{ Flavor = 'claude-global'; Version = 'v1.0.1'; Yes = $true; HomeDirectory = $testHome }
    & $installer @claudeDefaultOptions
    $claudeDefaultRoot = Join-Path $testHome '.claude/skills'
    Test-Condition (Test-Path -LiteralPath (Join-Path $claudeDefaultRoot 'test-authoring/SKILL.md')) 'Claude default global skills path is missing.'
    $claudeDefaultOptions.Action = 'Update'
    $claudeDefaultOptions.Merge = $true
    & $installer @claudeDefaultOptions
    Test-Condition (Test-Path -LiteralPath (Join-Path $claudeDefaultRoot 'test-authoring/SKILL.md')) 'Claude default global skills path was lost on update.'
    $sharedAssets = Join-Path $work 'shared-assets'
    Copy-Item -LiteralPath $Fixtures -Destination $sharedAssets -Recurse
    $portablePackage = Join-Path $work 'ai-agent-skills-portable'
    Push-Location $repoRoot
    try { & go run ./cmd/skillpack -target portable -out $portablePackage }
    finally { Pop-Location }
    if ($LASTEXITCODE -ne 0) { throw 'Portable fixture build failed.' }
    $portableArchive = 'ai-agent-skills-portable-v1.0.1.tar.gz'
    & tar -czf (Join-Path $sharedAssets $portableArchive) -C $work 'ai-agent-skills-portable'
    if ($LASTEXITCODE -ne 0) { throw 'Portable fixture archive failed.' }
    $sums = foreach ($file in Get-ChildItem -LiteralPath $sharedAssets -File | Where-Object Name -ne 'SHA256SUMS') {
        "$((Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLower())  $($file.Name)"
    }
    $sums | Set-Content -LiteralPath (Join-Path $sharedAssets 'SHA256SUMS') -Encoding utf8NoBOM
    $downloadState.Root = $sharedAssets
    foreach ($flavor in @('codex-desktop', 'copilot-staging', 'copilot-global', 'opencode-global')) {
        $options = @{ Action = 'Update'; Flavor = $flavor; Version = 'v1.0.1'; Yes = $true; HomeDirectory = $testHome }
        if ($flavor -eq 'copilot-global') { $options.Merge = $true }
        $expected = 'portable'
        if ($flavor -eq 'opencode-global') { $options.Merge = $true; $expected = 'skills' }
        $output = & $installer @options
        Test-Condition (($output -join "`n") -like "*Downloading ai-agent-skills-$expected-v1.0.1.tar.gz.*") 'Wrong shared archive selected.'
    }
    $sharedOnly = Join-Path $work 'shared-only'
    Copy-Item -LiteralPath $sharedAssets -Destination $sharedOnly -Recurse
    foreach ($target in @('codex', 'copilot', 'opencode')) {
        Remove-Item -LiteralPath (Join-Path $sharedOnly "ai-agent-skills-$target-v1.0.1.tar.gz")
    }
    Get-Content -LiteralPath (Join-Path $sharedAssets 'SHA256SUMS') | Where-Object { $_ -notmatch 'ai-agent-skills-(codex|copilot|opencode)-' } |
        Set-Content -LiteralPath (Join-Path $sharedOnly 'SHA256SUMS') -Encoding utf8NoBOM
    $downloadState.Root = $sharedOnly
    foreach ($flavor in @('codex-desktop', 'copilot-staging', 'copilot-global', 'opencode-global')) {
        $options = @{ Action = 'Update'; Flavor = $flavor; Version = 'v1.0.1'; Yes = $true; HomeDirectory = $testHome }
        if ($flavor -in @('opencode-global', 'copilot-global')) { $options.Merge = $true }
        & $installer @options
    }
    $legacyAssets = Join-Path $work 'legacy-opencode'
    Copy-Item -LiteralPath $Fixtures -Destination $legacyAssets -Recurse
    Remove-Item -LiteralPath (Join-Path $legacyAssets 'ai-agent-skills-skills-v1.0.1.tar.gz')
    Get-Content -LiteralPath (Join-Path $Fixtures 'SHA256SUMS') | Where-Object { $_ -notlike '*ai-agent-skills-skills-*' } |
        Set-Content -LiteralPath (Join-Path $legacyAssets 'SHA256SUMS') -Encoding utf8NoBOM
    $downloadState.Root = $legacyAssets
    $output = & $installer -Action Update -Flavor opencode-global -Version v1.0.1 -HomeDirectory $testHome -Merge -Yes
    Test-Condition (($output -join "`n") -like '*Downloading ai-agent-skills-opencode-v1.0.1.tar.gz.*') 'Legacy OpenCode archive not selected.'
    $sharedSentinel = Join-Path $testHome '.local/share/ai-agent-skills/copilot/sentinel'
    Set-Content -LiteralPath $sharedSentinel -Value 'Preserve selected plugin' -Encoding utf8NoBOM
    foreach ($failure in @('corrupt', 'duplicate', 'missing-download', 'wrong-root')) {
        $badShared = Join-Path $work "shared-$failure"
        Copy-Item -LiteralPath $sharedAssets -Destination $badShared -Recurse
        switch ($failure) {
            'corrupt' { Add-Content -LiteralPath (Join-Path $badShared $portableArchive) -Value 'broken' }
            'duplicate' {
                Get-Content -LiteralPath (Join-Path $sharedAssets 'SHA256SUMS') | Where-Object { $_ -like "*$portableArchive" } |
                    Add-Content -LiteralPath (Join-Path $badShared 'SHA256SUMS')
            }
            'missing-download' { Remove-Item -LiteralPath (Join-Path $badShared $portableArchive) }
            'wrong-root' {
                Copy-Item -LiteralPath (Join-Path $Fixtures 'ai-agent-skills-copilot-v1.0.1.tar.gz') -Destination (Join-Path $badShared $portableArchive) -Force
                $hash = (Get-FileHash -LiteralPath (Join-Path $badShared $portableArchive)).Hash.ToLower()
                $sums = @(Get-Content -LiteralPath (Join-Path $sharedAssets 'SHA256SUMS') | Where-Object { $_ -notlike "*$portableArchive" }) + @("$hash  $portableArchive")
                Set-Content -LiteralPath (Join-Path $badShared 'SHA256SUMS') -Value $sums -Encoding utf8NoBOM
            }
        }
        $downloadState.Root = $badShared
        Test-InstallerFailure @{ Action = 'Update'; Flavor = 'copilot-staging'; Version = 'v1.0.1'; HomeDirectory = $testHome; Yes = $true } ''
        Test-Condition ((Get-Content -LiteralPath $sharedSentinel -Raw).Trim() -eq 'Preserve selected plugin') 'Failed shared install changed destination.'
    }
    $downloadState.Root = $Fixtures
    $catalogText = Get-Content -LiteralPath $catalog -Raw
    $data = $catalogText | ConvertFrom-Json -AsHashtable
    Test-Condition ($data.name -eq 'existing' -and $data.interface.displayName -eq 'Existing') 'Marketplace metadata changed.'
    Test-Condition (@($data.plugins | Where-Object { $_.name -eq 'other-plugin' }).Count -eq 1) 'Unrelated plugin lost.'
    Test-Condition (@($data.plugins | Where-Object { $_.name -eq 'ai-agent-skills' }).Count -eq 1) 'Collection entry duplicated.'
    $metadata = [System.Text.Json.Nodes.JsonNode]::Parse($catalogText)
    Test-Condition ($metadata['createdAt'].GetValueKind() -eq [System.Text.Json.JsonValueKind]::String -and
        $metadata['createdAt'].ToString() -eq '2026-10-13T00:00:00+05:30') 'Marketplace timestamp metadata changed.'
    $unknown = Join-Path $projectPath '.agents/skills/unrelated'
    [void][IO.Directory]::CreateDirectory($unknown)
    Set-Content -LiteralPath (Join-Path $unknown 'file') -Value 'Keep me' -Encoding utf8NoBOM
    & $installer -Action Update -Flavor codex-skills -Project $projectPath -HomeDirectory $testHome -Merge -Yes
    Test-Condition ((Get-Content -LiteralPath (Join-Path $unknown 'file') -Raw).Trim() -eq 'Keep me') 'Merge lost unknown skills.'
    $plugin = Join-Path $testHome '.codex/plugins/ai-agent-skills'
    $sentinel = Join-Path $plugin 'local-change.txt'
    Set-Content -LiteralPath $sentinel -Value 'Preserve me' -Encoding utf8NoBOM
    $catalogHash = (Get-FileHash -LiteralPath $catalog).Hash
    $downloadState.FailCatalogWrite = $true
    Test-InstallerFailure @{ Action = 'Update'; Flavor = 'codex-desktop'; HomeDirectory = $testHome; Yes = $true } 'Injected catalog write failure'
    $downloadState.FailCatalogWrite = $false
    Test-Condition ((Test-Path -LiteralPath $sentinel) -and (Get-FileHash -LiteralPath $catalog).Hash -eq $catalogHash) 'Catalog staging failure changed installed files.'
    if ($IsWindows) {
        $downloadState.CatalogPath = $catalog
        $downloadState.LockCatalog = $true
        try {
            Test-InstallerFailure @{ Action = 'Update'; Flavor = 'codex-desktop'; HomeDirectory = $testHome; Yes = $true } ''
        } finally {
            $downloadState.LockCatalog = $false
            if ($downloadState.LockStream) { $downloadState.LockStream.Dispose(); $downloadState.LockStream = $null }
        }
        Test-Condition ((Test-Path -LiteralPath $sentinel) -and (Get-FileHash -LiteralPath $catalog).Hash -eq $catalogHash) 'Catalog commit failure did not restore the old plugin.'
    }
    $badFixtures = Join-Path $work 'bad-assets'
    Copy-Item -LiteralPath $Fixtures -Destination $badFixtures -Recurse
    Add-Content -LiteralPath (Join-Path $badFixtures 'ai-agent-skills-cursor-v1.0.1.tar.gz') -Value 'bad'
    $downloadState.Root = $badFixtures
    Test-InstallerFailure @{ Action = 'Update'; Flavor = 'cursor'; HomeDirectory = $testHome; Yes = $true } 'Checksum mismatch'
    $downloadState.Root = $Fixtures
    Test-Condition (Test-Path -LiteralPath (Join-Path $testHome '.cursor/plugins/local/ai-agent-skills/.cursor-plugin/plugin.json')) 'Failed download damaged installed plugin.'
    foreach ($attack in @('traversal', 'reserved', 'link', 'case-collision')) {
        $attackRoot = Join-Path $work $attack
        Copy-Item -LiteralPath $Fixtures -Destination $attackRoot -Recurse
        $archiveName = 'ai-agent-skills-cursor-v1.0.1.tar.gz'
        $stream = [IO.File]::Create((Join-Path $attackRoot $archiveName))
        $gzip = [IO.Compression.GZipStream]::new($stream, [IO.Compression.CompressionLevel]::Optimal)
        $writer = [System.Formats.Tar.TarWriter]::new($gzip)
        try {
            $entryNames = switch ($attack) {
                'traversal' { @('ai-agent-skills-cursor/../escape') }
                'reserved' { @('ai-agent-skills-cursor/NUL.txt') }
                'link' { @('ai-agent-skills-cursor/link') }
                'case-collision' { @('ai-agent-skills-cursor/FILE', 'ai-agent-skills-cursor/file') }
            }
            foreach ($name in $entryNames) {
                $kind = if ($attack -eq 'link') { [System.Formats.Tar.TarEntryType]::SymbolicLink } else { [System.Formats.Tar.TarEntryType]::RegularFile }
                $entry = [System.Formats.Tar.PaxTarEntry]::new($kind, $name)
                if ($attack -eq 'link') { $entry.LinkName = '../../escape' }
                else { $entry.DataStream = [IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes('test')) }
                $writer.WriteEntry($entry)
            }
        } finally { $writer.Dispose(); $gzip.Dispose(); $stream.Dispose() }
        $hash = (Get-FileHash -LiteralPath (Join-Path $attackRoot $archiveName)).Hash.ToLower()
        $checksums = @(Get-Content -LiteralPath (Join-Path $attackRoot 'SHA256SUMS') | Where-Object { $_ -notlike "*$archiveName" }) + @("$hash  $archiveName")
        Set-Content -LiteralPath (Join-Path $attackRoot 'SHA256SUMS') -Value $checksums -Encoding utf8NoBOM
        $downloadState.Root = $attackRoot
        $expected = switch ($attack) {
            'traversal' { 'Unsafe Windows archive path' }
            'reserved' { 'Unsafe Windows archive path' }
            'link' { 'Unsupported archive entry' }
            'case-collision' { 'Duplicate archive path' }
        }
        Test-InstallerFailure @{ Action = 'Update'; Flavor = 'cursor'; HomeDirectory = $testHome; Yes = $true } $expected
    }
    $downloadState.Root = $Fixtures
    Set-Content -LiteralPath $catalog -Value 'not-json' -Encoding utf8NoBOM
    Test-InstallerFailure @{ Action = 'Update'; Flavor = 'codex-desktop'; HomeDirectory = $testHome; Yes = $true } 'JSON'
    Test-Condition ((Get-Content -LiteralPath $catalog -Raw).Trim() -eq 'not-json') 'Invalid catalog overwritten.'
    & $installer -Action Update -Flavor cursor -HomeDirectory $testHome -DryRun
    # Junction creation is available without Developer Mode on Windows.
    if ($IsWindows) {
        $aliasPath = Join-Path $work 'project-alias'
        New-Item -ItemType Junction -Path $aliasPath -Target $projectPath | Out-Null
        Test-InstallerFailure @{ Flavor = 'codex-skills'; Project = $aliasPath; HomeDirectory = $testHome; Merge = $true; Yes = $true } 'junction'
        Remove-Item -LiteralPath $aliasPath -Force
    }
    Write-Output 'PowerShell installer flavors, updates, preservation, and failure checks passed.'
} finally {
    $env:COPYFILE_DISABLE = $originalCopyfileSetting
    $env:CLAUDE_CONFIG_DIR = $originalClaudeConfigDir
    Remove-Item Function:\Invoke-WebRequest, Function:\Invoke-RestMethod, Function:\Set-Content -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $work -Recurse -Force
}
