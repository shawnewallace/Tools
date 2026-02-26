#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./keynote_to_pdf.sh /path/to/keynote/files [/path/to/output]
#
# If output dir not provided, PDFs go into: <input>/pdf

INPUT_DIR="${1:-.}"
OUTPUT_DIR="${2:-"$INPUT_DIR/pdf"}"

# Normalize to absolute paths
INPUT_DIR="$(cd "$INPUT_DIR" && pwd)"
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"

# Find .key files recursively (both as packages/directories and regular files)
KEY_FILES=()
while IFS= read -r -d '' file; do
  KEY_FILES+=("$file")
done < <(find "$INPUT_DIR" \( -type d -name "*.key" -o -type f -name "*.key" \) -print0 | sort -z)

if [[ ${#KEY_FILES[@]} -eq 0 ]]; then
  echo "No .key files found in: $INPUT_DIR" >&2
  exit 1
fi

echo "Converting ${#KEY_FILES[@]} Keynote file(s) to PDF..."
echo "Input : $INPUT_DIR"
echo "Output: $OUTPUT_DIR"
echo

# Process each Keynote file
for key_file in "${KEY_FILES[@]}"; do
  basename_key=$(basename "$key_file")
  basename_pdf="${basename_key%.key}.pdf"
  output_path="$OUTPUT_DIR/$basename_pdf"
  
  echo "Processing: $basename_key"
  
  # AppleScript to export single file to PDF
  osascript <<EOF
tell application "Keynote"
  launch
  set theDoc to open POSIX file "$key_file"
  
  export theDoc to POSIX file "$output_path" as PDF
  
  close theDoc saving no
end tell
EOF
  
  if [[ -f "$output_path" ]]; then
    echo "  ✓ Exported: $basename_pdf"
  else
    echo "  ✗ Failed to export: $basename_key" >&2
  fi
done

# Quit Keynote after all conversions
osascript -e 'tell application "Keynote" to quit' 2>/dev/null || true

echo
echo "Done."