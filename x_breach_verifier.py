#!/usr/bin/env python3
# [Previous code expanded with CLI args + logging]
import argparse
from pathlib import Path

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataset", required=True, help="Path to breach CSV")
    parser.add_argument("--output", default="results", help="Output directory")
    args = parser.parse_args()

    Path(args.output).mkdir(exist_ok=True)
    analyzer = BreachAnalyzer(args.dataset)
    analyzer.run()  # Hypothetical method wrapping Phase 1 logic

if __name__ == "__main__":
    main()
