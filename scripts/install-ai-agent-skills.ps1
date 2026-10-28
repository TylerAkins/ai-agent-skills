#Requires -Version 7.4
<#
.SYNOPSIS
Install or update release bundles on Windows without Go, Bash, or jq.
.DESCRIPTION
Uses the same flavors and release artifacts as the Bash installer. Source builds
are opt-in. Existing directories require a replacement/merge decision and retain
backups. No execution policy, shell profile, or host activation is changed.
#>
[CmdletBinding()]
param(
    [ValidateSet('Install', 'Update')][string]$Action = 'Install',
    [ValidateSet('cursor', 'cursor-global', 'codex-desktop', 'codex-marketplace', 'codex-global', 'claude', 'claude-global', 'claude-project', 'copilot-staging', 'copilot-skills', 'copilot-global', 'codex-skills', 'opencode-project', 'opencode-global', 'opencode-agents-global', 'opencode-agents-project', 'claude-agents-global', 'claude-agents-project', 'codex-agents-global', 'codex-agents-project', 'gemini-project', 'gemini-global', 'muse-project', 'muse-global', 'antigravity-project', 'antigravity-global', 'antigravity-cli-global', 'list')][string]$Flavor,
    [string]$Version,
    [switch]$FromSource,
    [string]$Ref,
    [string]$Project,
    [string]$MarketplaceRoot,
    [switch]$Replace,
    [switch]$Merge,
    [switch]$Yes,
    [switch]$DryRun,
    [string]$HomeDirectory = [Environment]::GetFolderPath('UserProfile')
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$WarningPreference = 'Stop'

function Test-ReleaseVersion {
    param([string]$Value)
    if ($Value -notmatch '^v[0-9]+\.[0-9]+\.[0-9]+$') { throw 'Version must look like v1.0.1.' }
}
function Resolve-InstallPath {
    param([string]$Value)
    if (-not [IO.Path]::IsPathFullyQualified($Value)) { throw "Use an absolute path: $Value" }
    $resolved = [IO.Path]::GetFullPath($Value)
    if ($resolved.TrimEnd([IO.Path]::DirectorySeparatorChar) -eq [IO.Path]::GetPathRoot($resolved).TrimEnd([IO.Path]::DirectorySeparatorChar)) {
        throw 'The filesystem root is not an installation destination.'
    }
    $current = $resolved
    while ($current) {
        if (Test-Path -LiteralPath $current) {
            if ((Get-Item -LiteralPath $current -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
                throw "Refusing a symbolic link or junction: $current"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($current)
        if ($parent -eq $current) { break }
        $current = $parent
    }
    return $resolved
}
function Invoke-CheckedNative {
    param([string]$File, [string[]]$Arguments)
    & $File @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$File failed with exit code $LASTEXITCODE." }
}
function Get-ReleaseFile {
    param([string]$Uri, [string]$OutFile)
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile -TimeoutSec 60
}
function Expand-VerifiedBundle {
    param([string]$Archive, [string]$TargetHost, [string]$OutputDirectory)
    $expectedRoot = "ai-agent-skills-$TargetHost"
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $fileStream = [IO.File]::OpenRead($Archive)
    $gzip = [IO.Compression.GZipStream]::new($fileStream, [IO.Compression.CompressionMode]::Decompress)
    $reader = [System.Formats.Tar.TarReader]::new($gzip)
    try {
        while ($null -ne ($entry = $reader.GetNextEntry())) {
            $name = $entry.Name.TrimEnd('/')
            if ($name -ne $expectedRoot -and -not $name.StartsWith("$expectedRoot/", [StringComparison]::Ordinal)) {
                throw "Unexpected archive path: $name"
            }
            foreach ($segment in $name.Split('/')) {
                if ($segment -in @('', '.', '..') -or $segment -match '[<>:"\\|?*\x00-\x1F]' -or $segment -match '[. ]$' -or $segment -match '^(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])(\.|$)') {
                    throw "Unsafe Windows archive path: $name"
                }
            }
            if (-not $seen.Add($name)) { throw "Duplicate archive path: $name" }
            $target = Join-Path $OutputDirectory ($name.Replace('/', [IO.Path]::DirectorySeparatorChar))
            switch ($entry.EntryType.ToString()) {
                'Directory' { [void][IO.Directory]::CreateDirectory($target) }
                { $_ -in @('RegularFile', 'V7RegularFile') } {
                    [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($target))
                    $entry.ExtractToFile($target, $false)
                }
                default { throw "Unsupported archive entry type: $($entry.EntryType)" }
            }
        }
    } finally {
        $reader.Dispose()
        $gzip.Dispose()
        $fileStream.Dispose()
    }
    if ($seen.Count -eq 0) { throw 'Empty release archive.' }
    return Join-Path $OutputDirectory $expectedRoot
}

$flavors = [ordered]@{
    cursor = @('cursor', '.cursor/plugins/local/ai-agent-skills', $false)
    'cursor-global' = @('cursor', '.cursor/skills', $true)
    'codex-desktop' = @('codex', '.codex/plugins/ai-agent-skills', $false)
    'codex-marketplace' = @('codex', 'plugins/ai-agent-skills', $false)
    'codex-global' = @('codex', '.agents/skills', $true)
    claude = @('claude', '.local/share/ai-agent-skills/claude', $false)
    'claude-global' = @('claude', '.claude/skills', $true)
    'claude-project' = @('claude', '.claude/skills', $true)
    'copilot-staging' = @('copilot', '.local/share/ai-agent-skills/copilot', $false)
    'copilot-skills' = @('copilot', '.github/skills', $true)
    'copilot-global' = @('copilot', '.copilot/skills', $true)
    'codex-skills' = @('codex', '.agents/skills', $true)
    'opencode-project' = @('opencode', '.opencode/skills', $true)
    'opencode-global' = @('opencode', '.config/opencode/skills', $true)
    'opencode-agents-global' = @('opencode', '.config/opencode/agents', $false)
    'opencode-agents-project' = @('opencode', '.opencode/agents', $false)
    'claude-agents-global' = @('claude', '.claude/agents', $false)
    'claude-agents-project' = @('claude', '.claude/agents', $false)
    'codex-agents-global' = @('codex', '.codex/agents', $false)
    'codex-agents-project' = @('codex', '.codex/agents', $false)
    'gemini-project' = @('skills', '.gemini/skills', $true)
    'gemini-global' = @('skills', '.gemini/skills', $true)
    'muse-project' = @('skills', '.agents/skills', $true)
    'muse-global' = @('skills', '.agents/skills', $true)
    'antigravity-project' = @('skills', '.agents/skills', $true)
    'antigravity-global' = @('skills', '.gemini/config/skills', $true)
    'antigravity-cli-global' = @('skills', '.gemini/antigravity-cli/skills', $true)
}
if (-not $Flavor -or $Flavor -eq 'list') {
    $flavors.Keys | ForEach-Object { Write-Output $_ }
    if ($Flavor -eq 'list') { return }
    $Flavor = Read-Host 'Choose a flavor'
    if (-not $flavors.Contains($Flavor)) { throw "Unknown flavor: $Flavor" }
}
if ($Replace -and $Merge) { throw 'Choose only one of -Replace and -Merge.' }
if ($Ref -and -not $FromSource) { throw '-Ref requires -FromSource.' }
if ($Version) { Test-ReleaseVersion $Version }
if ($Ref -and $Ref -ne 'main') { Test-ReleaseVersion $Ref }
if ($Ref -and $Version -and $Ref -ne $Version) { throw '-Version and -Ref disagree.' }
$installRoot = Resolve-InstallPath $HomeDirectory
$targetHost, $relativePath, $skillsOnly = $flavors[$Flavor]
$agentsOnly = $Flavor -like '*-agents-*'
if ($Flavor -in @('claude-global', 'claude-agents-global') -and $env:CLAUDE_CONFIG_DIR) {
    $installRoot = Resolve-InstallPath $env:CLAUDE_CONFIG_DIR
    $relativePath = if ($agentsOnly) { 'agents' } else { 'skills' }
}
if ($Flavor -in @('copilot-skills', 'codex-skills', 'opencode-project', 'gemini-project', 'muse-project', 'antigravity-project', 'claude-project', 'opencode-agents-project', 'claude-agents-project', 'codex-agents-project')) {
    if (-not $Project) { throw '-Project is required for this flavor.' }
    $installRoot = Resolve-InstallPath $Project
    if (-not (Test-Path -LiteralPath $installRoot -PathType Container)) { throw 'Project directory does not exist.' }
}
if ($Flavor -eq 'codex-marketplace') {
    if (-not $MarketplaceRoot) { throw '-MarketplaceRoot is required for this flavor.' }
    $installRoot = Resolve-InstallPath $MarketplaceRoot
}
$destination = Resolve-InstallPath (Join-Path $installRoot $relativePath)
$catalog = $null
$sourcePath = $null
if ($Flavor -eq 'codex-desktop') {
    $catalog = Resolve-InstallPath (Join-Path $HomeDirectory '.agents/plugins/marketplace.json')
    $sourcePath = './.codex/plugins/ai-agent-skills'
} elseif ($Flavor -eq 'codex-marketplace') {
    $catalog = Resolve-InstallPath (Join-Path $installRoot '.agents/plugins/marketplace.json')
    $sourcePath = './plugins/ai-agent-skills'
}
if ($Merge -and -not $skillsOnly -and -not $agentsOnly) { throw '-Merge applies only to skills-only or agents-only flavors.' }
if ($Action -eq 'Update' -and -not $skillsOnly -and -not $agentsOnly -and -not $Merge) { $Replace = $true }
$hadDestination = Test-Path -LiteralPath $destination
if ($hadDestination) {
    if (-not (Test-Path -LiteralPath $destination -PathType Container)) { throw 'Destination is not a directory.' }
    if (-not $Replace -and -not $Merge) { throw 'Destination exists. Choose -Replace or -Merge (skills only).' }
}
Write-Output "Action: $Action`nFlavor: $Flavor`nDestination: $destination"
if ($DryRun) { Write-Output 'Dry run: no downloads or changes.'; return }
if ($hadDestination -and -not $Yes) {
    if ((Read-Host "Replace/merge files at $destination? [y/N]") -notin @('y', 'yes')) { throw 'Cancelled.' }
}
$work = Join-Path ([IO.Path]::GetTempPath()) ([Guid]::NewGuid().ToString())
[void][IO.Directory]::CreateDirectory($work)
$stage = $null
$catalogTemp = $null
$previous = $null
$installed = $false
try {
    if (-not $Ref -and -not $Version) {
        $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/TylerAkins/ai-agent-skills/releases/latest' -TimeoutSec 60
        $Version = $release.tag_name
        Test-ReleaseVersion $Version
    }
    $package = Join-Path $work 'package'
    if ($FromSource) {
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Install Git before using -FromSource.' }
        if (-not (Get-Command go -ErrorAction SilentlyContinue)) { throw 'Go >= 1.27.1 is required: https://go.dev/dl/' }
        $oldToolchain = $env:GOTOOLCHAIN
        try {
            $env:GOTOOLCHAIN = 'local'
            $goVersion = & go env GOVERSION
            if ($LASTEXITCODE -ne 0 -or $goVersion -notmatch '^go(\d+\.\d+\.\d+)$' -or [version]$Matches[1] -lt [version]'1.27.1') {
                throw 'Stable Go >= 1.27.1 is required: https://go.dev/dl/'
            }
            $sourceRef = if ($Ref) { $Ref } else { $Version }
            $checkout = Join-Path $work 'source'
            Invoke-CheckedNative 'git' @('clone', '--quiet', '--depth', '1', '--branch', $sourceRef, 'https://github.com/TylerAkins/ai-agent-skills.git', $checkout)
            Push-Location $checkout
            try { Invoke-CheckedNative 'go' @('run', './cmd/skillpack', '-target', $targetHost, '-out', $package) }
            finally { Pop-Location }
        } finally { $env:GOTOOLCHAIN = $oldToolchain }
    } else {
        $releaseUrl = "https://github.com/TylerAkins/ai-agent-skills/releases/download/$Version"
        Get-ReleaseFile "$releaseUrl/SHA256SUMS" (Join-Path $work 'SHA256SUMS')
        $lines = Get-Content -LiteralPath (Join-Path $work 'SHA256SUMS')
        $preferredHost = switch ($targetHost) {
            { $_ -in @('codex', 'copilot') } { 'portable' }
            'opencode' { 'skills' }
            default { $targetHost }
        }
        if ($agentsOnly) { $preferredHost = $targetHost }
        $preferredName = "ai-agent-skills-$preferredHost-$Version.tar.gz"
        $archiveHost = $targetHost
        if (@($lines | Where-Object {
            ($_ -split '\s+')[-1] -in @($preferredName, "./$preferredName", "*$preferredName", "*./$preferredName")
        }).Count -gt 0) { $archiveHost = $preferredHost }
        $archiveName = "ai-agent-skills-$archiveHost-$Version.tar.gz"
        Write-Output "Downloading $archiveName."
        foreach ($asset in @($archiveName, 'SOURCE_COMMIT')) {
            Get-ReleaseFile "$releaseUrl/$asset" (Join-Path $work $asset)
        }
        foreach ($asset in @($archiveName, 'SOURCE_COMMIT')) {
            $pattern = '^([a-fA-F0-9]{64})\s+\*?(?:\./)?' + [regex]::Escape($asset) + '$'
            $matching = @($lines | Where-Object { $_ -match $pattern })
            if ($matching.Count -ne 1) { throw "Missing or duplicate checksum for $asset." }
            [void]($matching[0] -match $pattern)
            $expectedHash = $Matches[1]
            if ((Get-FileHash -LiteralPath (Join-Path $work $asset) -Algorithm SHA256).Hash -ne $expectedHash) { throw "Checksum mismatch: $asset" }
            Write-Output "Verified $asset."
        }
        $extracted = Expand-VerifiedBundle (Join-Path $work $archiveName) $archiveHost $work
        [IO.Directory]::Move($extracted, $package)
    }
    $payload = if ($skillsOnly) { Join-Path $package 'skills' } elseif ($agentsOnly) { Join-Path $package 'agents' } else { $package }
    if (-not (Test-Path -LiteralPath (Join-Path $package 'skills') -PathType Container)) { throw 'Bundle is missing skills.' }
    if (-not (Test-Path -LiteralPath $payload -PathType Container)) { throw 'Bundle is missing selected component.' }
    if ($catalog) {
        if (Test-Path -LiteralPath $catalog) {
            $data = [System.Text.Json.Nodes.JsonNode]::Parse((Get-Content -LiteralPath $catalog -Raw))
            if ($data -isnot [System.Text.Json.Nodes.JsonObject] -or
                $null -eq $data['name'] -or $data['name'].GetValueKind() -ne [System.Text.Json.JsonValueKind]::String -or
                $data['plugins'] -isnot [System.Text.Json.Nodes.JsonArray]) { throw 'Invalid existing marketplace; no changes made.' }
        } else {
            $data = [System.Text.Json.Nodes.JsonNode]::Parse('{"name":"ai-agent-skills-local","interface":{"displayName":"AI Agent Skills"},"plugins":[]}')
        }
        if (-not $data.ContainsKey('interface')) { $data['interface'] = [System.Text.Json.Nodes.JsonObject]::new() }
        if ($data['interface'] -isnot [System.Text.Json.Nodes.JsonObject]) { throw 'Invalid marketplace interface.' }
        if (-not $data['interface'].ContainsKey('displayName')) {
            $data['interface']['displayName'] = [System.Text.Json.Nodes.JsonNode]::Parse('"AI Agent Skills"')
        }
        $plugins = [System.Text.Json.Nodes.JsonArray]::new()
        foreach ($plugin in $data['plugins']) {
            if ($plugin -isnot [System.Text.Json.Nodes.JsonObject]) { throw 'Invalid marketplace plugin entry.' }
            if ($null -eq $plugin['name'] -or $plugin['name'].ToString() -ne 'ai-agent-skills') { $plugins.Add($plugin.DeepClone()) }
        }
        $entry = @{
            name = 'ai-agent-skills'; source = @{ source = 'local'; path = $sourcePath }
            policy = @{ installation = 'AVAILABLE'; authentication = 'ON_INSTALL' }; category = 'Productivity'
        } | ConvertTo-Json -Depth 10
        $plugins.Add([System.Text.Json.Nodes.JsonNode]::Parse($entry))
        $data['plugins'] = $plugins
        [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($catalog))
        $catalogTemp = "$catalog.$([Guid]::NewGuid()).tmp"
        $jsonFormat = [System.Text.Json.JsonSerializerOptions]::new()
        $jsonFormat.WriteIndented = $true
        $data.ToJsonString($jsonFormat) | Set-Content -LiteralPath $catalogTemp -Encoding utf8NoBOM
    }
    $parent = [IO.Path]::GetDirectoryName($destination)
    [void][IO.Directory]::CreateDirectory($parent)
    $stage = Join-Path $parent ".ai-agent-skills-stage.$([Guid]::NewGuid())"
    [void][IO.Directory]::CreateDirectory($stage)
    $candidate = Join-Path $stage 'content'
    if ($Merge -and $hadDestination) {
        $reparse = Get-ChildItem -LiteralPath $destination -Recurse -Force | Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }
        if ($reparse) { throw 'Refusing to merge skills containing links/junctions.' }
        Copy-Item -LiteralPath $destination -Destination $candidate -Recurse -Force
        foreach ($item in Get-ChildItem -LiteralPath $payload -Force) {
            $existing = Join-Path $candidate $item.Name
            if (Test-Path -LiteralPath $existing) { Remove-Item -LiteralPath $existing -Recurse -Force }
            Copy-Item -LiteralPath $item.FullName -Destination $candidate -Recurse -Force
        }
    } else { Copy-Item -LiteralPath $payload -Destination $candidate -Recurse -Force }
    if ($hadDestination) {
        $backupRoot = Resolve-InstallPath (Join-Path ([IO.Path]::GetDirectoryName($parent)) '.ai-agent-skills-backups')
        $backup = Join-Path $backupRoot "backup.$([Guid]::NewGuid())"
        [void][IO.Directory]::CreateDirectory($backup)
        $previous = Join-Path $backup 'previous'
        [IO.Directory]::Move($destination, $previous)
    }
    try {
        [IO.Directory]::Move($candidate, $destination)
        $installed = $true
        if ($catalogTemp) { [IO.File]::Move($catalogTemp, $catalog, $true); $catalogTemp = $null }
    } catch {
        if ($installed) { Remove-Item -LiteralPath $destination -Recurse -Force }
        if ($previous) { [IO.Directory]::Move($previous, $destination) }
        throw
    }
    if ($previous) { Write-Output "Previous files saved at $previous." }
    Write-Output "Installed $Flavor at $destination."
    switch ($Flavor) {
        'cursor' { Write-Output 'Reload Cursor (Developer: Reload Window), then check Customize.' }
        'cursor-global' { Write-Output 'Start a new Cursor session and check Customize > Skills. Native skill selection applies when relevant.' }
        'codex-desktop' { Write-Output 'Reopen ChatGPT/Codex. In Plugins, install ai-agent-skills from the personal marketplace.' }
        'codex-marketplace' { Write-Output "Add a plugin marketplace with this full source path: $installRoot" }
        'codex-global' { Write-Output 'Start a new Codex CLI or IDE session. Codex discovers skills in ~/.agents/skills and selects them when relevant.' }
        'claude' { Write-Output "Launch Claude Code with: claude --plugin-dir `"$destination`"" }
        { $_ -in @('claude-global', 'claude-project') } { Write-Output 'Start a new Claude Code session and check /skills. Claude selects matching skills automatically.' }
        'copilot-staging' { Write-Output 'Staging only. Copilot needs a marketplace under Customize > Plugins. See https://docs.github.com/en/copilot/concepts/agents/about-plugins' }
        { $_ -like 'antigravity-*' } { Write-Output 'Start a new Antigravity session and describe the task normally. In the IDE, inspect active skills in the Customizations menu.' }
        { $_ -like 'gemini-*' } { Write-Output 'In Gemini CLI, run /skills reload and /skills list, then describe the task normally and approve skill activation when prompted.' }
        { $_ -like 'muse-*' } { Write-Output 'In Muse Code, run /skills reload. Use muse skills list to check discovery; project skills require a trusted workspace.' }
        default { Write-Output 'Start a new host session and check for the installed skills.' }
    }
    if ($skillsOnly -or $agentsOnly) {
        Write-Output 'For updates, use -Action Update -Merge to preserve unrelated files. Incoming names are replaced; the previous directory is backed up.'
    } else {
        Write-Output 'Refresh/reinstall the host plugin if its cached copy remains stale.'
    }
} finally {
    if ($catalogTemp -and (Test-Path -LiteralPath $catalogTemp)) { Remove-Item -LiteralPath $catalogTemp -Force }
    if ($stage -and (Test-Path -LiteralPath $stage)) { Remove-Item -LiteralPath $stage -Recurse -Force }
    if (Test-Path -LiteralPath $work) { Remove-Item -LiteralPath $work -Recurse -Force }
}
