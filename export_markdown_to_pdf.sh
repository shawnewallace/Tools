#!/bin/bash
# Recursively convert Markdown files to PDF while mirroring folder structure
# Requires: pandoc + weasyprint + mermaid-filter
#   brew install pandoc
#   pip install weasyprint
#   npm install -g @mermaid-js/mermaid-cli mermaid-filter

set -e  # stop on error

# Default values
INPUT_DIR="."             # where to start searching
OUTPUT_DIR="./pdfs"       # where to store all PDFs
INCLUDE_TOC=false         # whether to include table of contents

# Directories always excluded regardless of arguments
DEFAULT_EXCLUDES=(
  node_modules
  dist
  build
  .git
  .cache
  .next
  .nuxt
  out
  coverage
  vendor
)

# Additional directories excluded via -e/--exclude flags
EXTRA_EXCLUDES=()

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--toc)
      INCLUDE_TOC=true
      shift
      ;;
    -i|--input)
      INPUT_DIR="$2"
      shift 2
      ;;
    -o|--output)
      OUTPUT_DIR="$2"
      shift 2
      ;;
    -e|--exclude)
      EXTRA_EXCLUDES+=("$2")
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [-t|--toc] [-i|--input DIR] [-o|--output DIR] [-e|--exclude DIR]..."
      echo "  -t, --toc       Include table of contents in PDFs"
      echo "  -i, --input     Input directory (default: current directory)"
      echo "  -o, --output    Output directory (default: ./pdfs)"
      echo "  -e, --exclude   Exclude a directory by name (repeatable, e.g. -e .claude -e .github)"
      echo "  -h, --help      Show this help message"
      echo ""
      echo "Always excluded: ${DEFAULT_EXCLUDES[*]}"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

# Build find exclusion arguments from both default and extra lists
FIND_EXCLUDES=()
for dir in "${DEFAULT_EXCLUDES[@]}" "${EXTRA_EXCLUDES[@]}"; do
  FIND_EXCLUDES+=(-not -path "*/${dir}/*")
done

# Create output directory if not exists
mkdir -p "$OUTPUT_DIR"

# Find all markdown files recursively, applying all exclusions
find "$INPUT_DIR" -type f -name "*.md" "${FIND_EXCLUDES[@]}" -print0 | while IFS= read -r -d '' md; do
  # Derive relative path (remove leading ./)
  rel_path="${md#./}"
  # Replace .md with .pdf
  rel_pdf="${rel_path%.md}.pdf"
  # Build full destination path inside OUTPUT_DIR
  out="$OUTPUT_DIR/$rel_pdf"

  # Create destination directory
  mkdir -p "$(dirname "$out")"

  # Build TOC option if enabled
  TOC_OPTION=""
  if [ "$INCLUDE_TOC" = true ]; then
    TOC_OPTION="--toc"
  fi

  # Check for CSS file and add option if it exists
  CSS_OPTION=""
  if [ -f "./scripts/github-markdown.css" ]; then
    CSS_OPTION="--css=./scripts/github-markdown.css"
  fi

  echo "Converting: $md → $out"
  pandoc "$md" -o "$out" \
  --pdf-engine=weasyprint \
  -V geometry:margin=1in \
  -V mainfont="Arial" \
  $CSS_OPTION \
  --from=gfm \
  --metadata=title:"$(basename "${md%.*}")" \
  --filter mermaid-filter \
  $TOC_OPTION \
  --syntax-highlighting=pygments
done

echo "✅ Conversion complete. PDFs are in $OUTPUT_DIR"