// [Previous code with enhanced error handling]
package main

import (
	"log"
	"os"
	"encoding/csv"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("Usage: ./credstuff-x targets.csv")
	}
	creds := loadCredentials(os.Args[1])
	// [Rest of Phase 2 code]
}
