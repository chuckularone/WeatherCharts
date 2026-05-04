#!/bin/bash
# Script to remove files older than X days based on a filemask
# Usage: purgeOldFiles.sh [-y] <days> <filemask> [directory]

# Function to display usage
usage() {
    echo "Usage: $0 [-y|--yes] <days> <filemask> [directory]"
    echo ""
    echo "Options:"
    echo "  -y, --yes - Skip confirmation prompt and remove files automatically"
    echo ""
    echo "Arguments:"
    echo "  days      - Number of days (files older than this will be removed)"
    echo "  filemask  - File pattern to match (e.g., '*.log', 'backup-*', '*.txt')"
    echo "  directory - Target directory (optional, defaults to current directory)"
    echo ""
    echo "Examples:"
    echo "  $0 7 '*.log'                       # Remove .log files older than 7 days in current dir"
    echo "  $0 30 'backup-*' /var/backups      # Remove backup-* files older than 30 days in /var/backups"
    echo "  $0 14 '*.tmp' /tmp                 # Remove .tmp files older than 14 days in /tmp"
    echo "  $0 -y 7 '*.log'                    # Same, without confirmation prompt"
    echo "  $0 --yes 30 'backup-*' /var/backups"
    exit 1
}

# Parse optional flags first
AUTO_YES=false
while [[ "$1" == -* ]]; do
    case "$1" in
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option '$1'"
            usage
            ;;
    esac
done

# Check if at least 2 arguments are provided
if [ $# -lt 2 ]; then
    echo "Error: Missing required arguments"
    usage
fi

# Parse command line arguments
DAYS="$1"
FILEMASK="$2"
DIRECTORY="${3:-.}"  # Default to current directory if not specified

# Validate that days is a positive integer
if ! [[ "$DAYS" =~ ^[0-9]+$ ]] || [ "$DAYS" -eq 0 ]; then
    echo "Error: Days must be a positive integer"
    usage
fi

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory '$DIRECTORY' does not exist"
    exit 1
fi

# Check if we have write permissions to the directory
if [ ! -w "$DIRECTORY" ]; then
    echo "Error: No write permission to directory '$DIRECTORY'"
    exit 1
fi

# Convert to absolute path for cleaner output
DIRECTORY=$(realpath "$DIRECTORY")

echo "Searching for files matching '$FILEMASK' older than $DAYS days in: $DIRECTORY"
echo ""

# Find and list files that will be removed (dry run first)
FILES_TO_REMOVE=$(find "$DIRECTORY" -maxdepth 1 -name "$FILEMASK" -type f -mtime +$DAYS 2>/dev/null)

if [ -z "$FILES_TO_REMOVE" ]; then
    echo "No files found matching the criteria."
    exit 0
fi

# Show what will be removed
echo "Files to be removed:"
echo "$FILES_TO_REMOVE"
echo ""

# Count files
FILE_COUNT=$(echo "$FILES_TO_REMOVE" | wc -l)
echo "Found $FILE_COUNT file(s) to remove."

# Ask for confirmation unless -y/--yes was passed
if [ "$AUTO_YES" = false ]; then
    read -p "Do you want to proceed with deletion? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
else
    echo "Auto-confirming deletion (-y flag set)."
fi

# Remove the files
echo "Removing files..."
REMOVED_COUNT=0
FAILED_COUNT=0

while IFS= read -r file; do
    if [ -f "$file" ]; then
        if rm "$file" 2>/dev/null; then
            echo "Removed: $file"
            ((REMOVED_COUNT++))
        else
            echo "Failed to remove: $file"
            ((FAILED_COUNT++))
        fi
    fi
done <<< "$FILES_TO_REMOVE"

echo ""
echo "Summary:"
echo "  Successfully removed: $REMOVED_COUNT files"
if [ $FAILED_COUNT -gt 0 ]; then
    echo "  Failed to remove: $FAILED_COUNT files"
fi
echo "Operation completed."
