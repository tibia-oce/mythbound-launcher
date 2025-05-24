#!/bin/bash

# Script to export all filenames and contents to a text file
# Usage: ./export_files.sh [output_filename]

# Set output filename (default: project_export.txt)
OUTPUT_FILE="${1:-project_export.txt}"

# Remove existing output file if it exists
rm -f "$OUTPUT_FILE"

echo "Exporting project files to: $OUTPUT_FILE"
echo "Starting export at: $(date)"
echo

# Header for the output file
cat << EOF > "$OUTPUT_FILE"
================================================================================
PROJECT FILE EXPORT
================================================================================
Generated on: $(date)
Working directory: $(pwd)

This file contains all project files and their contents.
Each file is separated by a header showing the relative path.

================================================================================

EOF

# Function to check if file is binary
is_binary() {
    if file "$1" | grep -q "text\|empty"; then
        return 1  # Not binary (is text)
    else
        return 0  # Is binary
    fi
}

# Function to get file size in human readable format
get_file_size() {
    if command -v numfmt >/dev/null 2>&1; then
        stat -c%s "$1" | numfmt --to=iec
    else
        stat -c%s "$1" | awk '{
            if ($1 < 1024) print $1 " B"
            else if ($1 < 1048576) printf "%.1f KB\n", $1/1024
            else if ($1 < 1073741824) printf "%.1f MB\n", $1/1048576
            else printf "%.1f GB\n", $1/1073741824
        }'
    fi
}

# Build find command with exclusions - focusing on code only
FIND_CMD='find . -type f'
FIND_CMD="$FIND_CMD ! -path '*/.git/*'"
FIND_CMD="$FIND_CMD ! -path '*/.github/*'"
FIND_CMD="$FIND_CMD ! -name '.gitignore'"
FIND_CMD="$FIND_CMD ! -path '*/node_modules/*'"
FIND_CMD="$FIND_CMD ! -name 'package-lock.json'"
FIND_CMD="$FIND_CMD ! -name 'yarn.lock'"
FIND_CMD="$FIND_CMD ! -name 'pnpm-lock.yaml'"
FIND_CMD="$FIND_CMD ! -path '*/build/*'"
FIND_CMD="$FIND_CMD ! -path '*/dist/*'"
FIND_CMD="$FIND_CMD ! -path '*/out/*'"
FIND_CMD="$FIND_CMD ! -path '*/release/*'"
FIND_CMD="$FIND_CMD ! -path '*/swiftshader/*'"
FIND_CMD="$FIND_CMD ! -name '*.exe'"
FIND_CMD="$FIND_CMD ! -name '*.dll'"
FIND_CMD="$FIND_CMD ! -name '*.so'"
FIND_CMD="$FIND_CMD ! -name '*.dylib'"
FIND_CMD="$FIND_CMD ! -name '*.pak'"
FIND_CMD="$FIND_CMD ! -name '*.dat'"
FIND_CMD="$FIND_CMD ! -name '*.bin'"
FIND_CMD="$FIND_CMD ! -name '*.dmg'"
FIND_CMD="$FIND_CMD ! -name '*.AppImage'"
FIND_CMD="$FIND_CMD ! -name '*.deb'"
FIND_CMD="$FIND_CMD ! -name '*.rpm'"
FIND_CMD="$FIND_CMD ! -name '*.msi'"
FIND_CMD="$FIND_CMD ! -name '*.pkg'"
FIND_CMD="$FIND_CMD ! -name '*.mp4'"
FIND_CMD="$FIND_CMD ! -name '*.avi'"
FIND_CMD="$FIND_CMD ! -name '*.mov'"
FIND_CMD="$FIND_CMD ! -name '*.gif'"
FIND_CMD="$FIND_CMD ! -name '*.png'"
FIND_CMD="$FIND_CMD ! -name '*.jpg'"
FIND_CMD="$FIND_CMD ! -name '*.jpeg'"
FIND_CMD="$FIND_CMD ! -name '*.ico'"
FIND_CMD="$FIND_CMD ! -name '*.svg'"
FIND_CMD="$FIND_CMD ! -name '*.webp'"
FIND_CMD="$FIND_CMD ! -name '*.mp3'"
FIND_CMD="$FIND_CMD ! -name '*.wav'"
FIND_CMD="$FIND_CMD ! -name '*.ogg'"
FIND_CMD="$FIND_CMD ! -name '*.log'"
FIND_CMD="$FIND_CMD ! -name '*.tmp'"
FIND_CMD="$FIND_CMD ! -name '*.cache'"
FIND_CMD="$FIND_CMD ! -name '.DS_Store'"
FIND_CMD="$FIND_CMD ! -name 'Thumbs.db'"
FIND_CMD="$FIND_CMD ! -path '*/.vscode/*'"
FIND_CMD="$FIND_CMD ! -path '*/.idea/*'"
FIND_CMD="$FIND_CMD ! -name '*.swp'"
FIND_CMD="$FIND_CMD ! -name '*.swo'"
FIND_CMD="$FIND_CMD ! -name '*.pdf'"
FIND_CMD="$FIND_CMD ! -name '*.docx'"
FIND_CMD="$FIND_CMD ! -name '*.doc'"
FIND_CMD="$FIND_CMD ! -name 'README.txt'"
FIND_CMD="$FIND_CMD ! -name 'README.md'"
FIND_CMD="$FIND_CMD ! -name 'makefile'"
FIND_CMD="$FIND_CMD ! -name 'export_files.sh'"
FIND_CMD="$FIND_CMD ! -name '*.sh'"
FIND_CMD="$FIND_CMD ! -name '$OUTPUT_FILE'"

# Export files
export_count=0
binary_count=0
text_count=0

echo "Processing files..."

# Use eval to execute the dynamic find command
eval "$FIND_CMD" | sort | while read -r file; do
    # Skip if file doesn't exist (broken symlinks)
    [ ! -f "$file" ] && continue
    
    # Get relative path (remove leading ./)
    rel_path="${file#./}"
    
    # Get file info
    file_size=$(get_file_size "$file")
    
    echo "Processing: $rel_path"
    
    # Add file header to output
    {
        echo
        echo "================================================================================"
        echo "FILE: $rel_path"
        echo "SIZE: $file_size"
        echo "MODIFIED: $(date -r "$file" 2>/dev/null || echo 'Unknown')"
        echo "================================================================================"
        echo
    } >> "$OUTPUT_FILE"
    
    # Check if file is binary
    if is_binary "$file"; then
        echo "[BINARY FILE - Content not displayed]" >> "$OUTPUT_FILE"
        echo "File type: $(file -b "$file" 2>/dev/null || echo 'Unknown')" >> "$OUTPUT_FILE"
        ((binary_count++))
    else
        # Check if file is too large (>1MB)
        file_size_bytes=$(stat -c%s "$file" 2>/dev/null || echo 0)
        if [ "$file_size_bytes" -gt 1048576 ]; then
            echo "[LARGE TEXT FILE - Showing first 100 lines only]" >> "$OUTPUT_FILE"
            echo >> "$OUTPUT_FILE"
            head -n 100 "$file" >> "$OUTPUT_FILE"
            echo >> "$OUTPUT_FILE"
            echo "[... file truncated ...]" >> "$OUTPUT_FILE"
        else
            # Output full file content
            cat "$file" >> "$OUTPUT_FILE"
        fi
        ((text_count++))
    fi
    
    # Add spacing after each file
    echo >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
    
    ((export_count++))
done

# Add summary footer
{
    echo
    echo "================================================================================"
    echo "EXPORT SUMMARY"
    echo "================================================================================"
    echo "Total files processed: $export_count"
    echo "Text files: $text_count"
    echo "Binary files: $binary_count"
    echo "Export completed at: $(date)"
    echo "================================================================================"
} >> "$OUTPUT_FILE"

echo
echo "Export completed!"
echo "Output file: $OUTPUT_FILE"
echo "Files processed: $export_count"
echo "  - Text files: $text_count"
echo "  - Binary files: $binary_count"
echo
echo "File size: $(get_file_size "$OUTPUT_FILE")"
