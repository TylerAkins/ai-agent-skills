package main

import (
	"flag"
	"fmt"
	"github.com/TylerAkins/ai-agent-skills/internal/collection"
	"os"
)

func main() {
	root := flag.String("root", ".", "collection or package root")
	target := flag.String("target", "source", "source, cursor, codex, claude, copilot, or opencode")
	out := flag.String("out", "", "new output directory outside source; builds a package when set")
	flag.Parse()
	var err error
	if *out != "" {
		err = collection.Build(*root, *out, *target)
	} else {
		var names []string
		names, err = collection.Validate(*root, *target)
		if err == nil {
			fmt.Printf("Validated %d skills (%s)\n", len(names), *target)
		}
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	if *out != "" {
		fmt.Printf("Built %s package at %s\n", *target, *out)
	}
}
