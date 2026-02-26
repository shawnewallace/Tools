#!/bin/bash

# Convert all .docx files in the current directory to markdown using pandoc

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed. Please install it first."
    exit 1
fi

# Count the number of .docx files
docx_count=$(find . -maxdepth 1 -name "*.docx" -type f | wc -l)

if [ "$docx_count" -eq 0 ]; then
    echo "No .docx files found in the current directory."
    exit 0
fi

echo "Found $docx_count .docx file(s) to convert..."
echo ""

# Create raw directory if it doesn't exist
if [ ! -d "./raw" ]; then
    echo "Creating ./raw directory..."
    mkdir -p ./raw
    echo ""
fi

# Loop through all .docx files in the current directory
for docx_file in *.docx; do
    # Skip if no .docx files exist (glob doesn't expand)
    [ -e "$docx_file" ] || continue
    
    # Get the base filename without extension
    basename="${docx_file%.docx}"
    
    # Set the output markdown filename
    md_file="${basename}.md"
    
    echo "Converting: $docx_file -> $md_file"
    
    # Run pandoc conversion
    if pandoc -s "$docx_file" -o "$md_file"; then
        echo "✓ Successfully converted: $md_file"
        
        # Move the source .docx file to ./raw directory
        mv "$docx_file" ./raw/
        echo "  Moved $docx_file to ./raw/"
    else
        echo "✗ Failed to convert: $docx_file"
    fi
    
    echo ""
done

echo "Conversion complete!"
