#!/usr/bin/env bash

# Cursor Template Deployment Script
# Usage: ./deploy.sh <destination_directory>

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (where this script is located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Show usage information
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS] <destination_directory>

Deploy the Cursor template to a target directory.

Arguments:
    destination_directory    Path to the target directory

Options:
    -f, --force             Overwrite existing files without prompting
    -n, --no-git            Don't initialize git repository in target
    -h, --help              Show this help message

Examples:
    $0 ~/projects/my-new-project
    $0 --force /path/to/existing/project
    $0 --no-git ../another-project

EOF
}

# Parse command line arguments
FORCE=false
NO_GIT=false
DEST_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -n|--no-git)
            NO_GIT=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            DEST_DIR="$1"
            shift
            ;;
    esac
done

# Validate destination directory argument
if [[ -z "$DEST_DIR" ]]; then
    print_error "Destination directory is required"
    echo ""
    show_usage
    exit 1
fi

# Convert to absolute path
DEST_DIR="$(cd "$(dirname "$DEST_DIR")" 2>/dev/null && pwd)/$(basename "$DEST_DIR")" || {
    # If parent doesn't exist, use the path as-is
    DEST_DIR="$(realpath "$DEST_DIR" 2>/dev/null || echo "$DEST_DIR")"
}

print_info "Deploying Cursor template to: $DEST_DIR"

# Check if destination exists
if [[ -d "$DEST_DIR" ]]; then
    if [[ "$FORCE" == false ]]; then
        print_warning "Destination directory already exists"
        read -p "Do you want to continue and overwrite existing files? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Deployment cancelled"
            exit 0
        fi
    else
        print_warning "Destination exists - overwriting files (--force enabled)"
    fi
else
    print_info "Creating destination directory..."
    mkdir -p "$DEST_DIR"
fi

# Copy template files
print_info "Copying template files..."

# Copy .cursor directory
if [[ -d "$SCRIPT_DIR/.cursor" ]]; then
    print_info "Copying .cursor directory..."
    cp -r "$SCRIPT_DIR/.cursor" "$DEST_DIR/"
    print_success "Copied .cursor directory"
fi

# Copy .cursorignore
if [[ -f "$SCRIPT_DIR/.cursorignore" ]]; then
    print_info "Copying .cursorignore..."
    cp "$SCRIPT_DIR/.cursorignore" "$DEST_DIR/"
    print_success "Copied .cursorignore"
fi

# Copy any README files (excluding .cursor/README.md which is already copied)
if [[ -f "$SCRIPT_DIR/README.md" ]]; then
    print_info "Copying README.md..."
    cp "$SCRIPT_DIR/README.md" "$DEST_DIR/"
    print_success "Copied README.md"
fi

# Copy any additional files at root level (excluding this script and git files)
for file in "$SCRIPT_DIR"/*; do
    filename=$(basename "$file")
    
    # Skip certain files
    if [[ "$filename" == "deploy.sh" ]] || \
       [[ "$filename" == ".git" ]] || \
       [[ "$filename" == ".cursor" ]] || \
       [[ "$filename" == ".cursorignore" ]] || \
       [[ "$filename" == "README.md" ]]; then
        continue
    fi
    
    if [[ -f "$file" ]]; then
        print_info "Copying $filename..."
        cp "$file" "$DEST_DIR/"
    fi
done

# Initialize git repository if requested
if [[ "$NO_GIT" == false ]]; then
    if [[ ! -d "$DEST_DIR/.git" ]]; then
        print_info "Initializing git repository..."
        (cd "$DEST_DIR" && git init)
        print_success "Git repository initialized"
    else
        print_info "Git repository already exists - skipping initialization"
    fi
fi

# Summary
echo ""
print_success "Deployment complete!"
echo ""
echo "Template deployed to: $DEST_DIR"
echo ""
echo "Next steps:"
echo "  1. cd $DEST_DIR"
if [[ "$NO_GIT" == false ]]; then
    echo "  2. Review and customize the .cursor/rules/ files"
    echo "  3. Add your project files"
    echo "  4. git add . && git commit -m 'Initial commit'"
else
    echo "  2. Review and customize the .cursor/rules/ files"
    echo "  3. Add your project files"
fi
echo ""
print_info "Happy coding!"
