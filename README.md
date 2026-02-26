# Tools

A collection of utility scripts for development workflows.

## Shell Scripts

### `export_markdown_to_pdf.sh`
Recursively converts Markdown files to PDF while mirroring the folder structure.

**Requirements:** `pandoc`, `weasyprint`, `mermaid-filter`
```
brew install pandoc
pip install weasyprint
npm install -g @mermaid-js/mermaid-cli mermaid-filter
```

**Usage:**
```bash
./export_markdown_to_pdf.sh [options]

  -t, --toc           Include table of contents in PDFs
  -i, --input DIR     Input directory (default: current directory)
  -o, --output DIR    Output directory (default: ./pdfs)
  -e, --exclude DIR   Exclude a directory by name (repeatable)
  -h, --help          Show help

# Examples
./export_markdown_to_pdf.sh
./export_markdown_to_pdf.sh -t -i ./docs -o ./output
./export_markdown_to_pdf.sh -e .claude -e .github
```

**Default excluded directories:** `node_modules`, `dist`, `build`, `.git`, `.cache`, `.next`, `.nuxt`, `out`, `coverage`, `vendor`

---

### `dotnet_deep_clean.sh`
Deep-cleans a .NET project by running `dotnet clean`, clearing the NuGet cache, and removing all `bin/`, `obj/`, and `node_modules/` directories recursively.

**Requirements:** .NET SDK

**Usage:**
```bash
./dotnet_deep_clean.sh [directory]

# Examples
./dotnet_deep_clean.sh
./dotnet_deep_clean.sh ./my-solution
```

---

### `keynote_to_pdf.sh`
Recursively converts Keynote (`.key`) files to PDF using AppleScript. macOS only.

**Requirements:** Keynote (macOS)

**Usage:**
```bash
./keynote_to_pdf.sh [input_dir] [output_dir]

# Examples
./keynote_to_pdf.sh
./keynote_to_pdf.sh ./slides ./pdfs
```

---

### `convert-docx-to-md.sh`
Converts Word (`.docx`) files to Markdown.

**Requirements:** `pandoc`
```
brew install pandoc
```

**Usage:**
```bash
# Run from a directory containing .docx files
./convert-docx-to-md.sh
```

Converts all `.docx` files in the current directory to Markdown using `pandoc`. Originals are moved to a `./raw/` subdirectory after conversion.

---

## Ruby Scripts

### `CreateWorklogFiles.rb`
Generates daily worklog `.txt` files for the next N weekdays and archives files older than 10 days into an `Archive` subdirectory.

```bash
ruby CreateWorklogFiles.rb <path> <num_files>
```

### `FindFiles.rb`
Scans a C# project's IoC wiring container and reports which interfaces are registered, outputting `file,interface` pairs.

```bash
ruby FindFiles.rb <project_root> [wiring_container_root]
```

### `recursion.rb`
Simple recursive power function example (`x^y`).
