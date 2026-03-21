#!/bin/bash

# Thesis PDF Compilation Script
# Compiles the LaTeX thesis document fpx3h0_en.tex to PDF

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (thesis root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THESIS_DIR="$SCRIPT_DIR"
MAIN_TEX="fpx3h0_en.tex"
OUTPUT_PDF="fpx3h0_en.pdf"

echo -e "${BLUE}LaTeX Thesis Compilation Script${NC}"
echo -e "${BLUE}===============================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "$THESIS_DIR/$MAIN_TEX" ]; then
    echo -e "${RED}Error: $MAIN_TEX not found in $THESIS_DIR${NC}"
    echo "Please run this script from the thesis directory."
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for LaTeX installation
check_latex_installation() {
    echo -e "${YELLOW}Checking LaTeX installation...${NC}"
    
    if ! command_exists pdflatex; then
        echo -e "${RED}Error: pdflatex not found!${NC}"
        echo ""
        echo -e "${YELLOW}To install LaTeX on Ubuntu/Debian:${NC}"
        echo "  sudo apt update"
        echo "  sudo apt install texlive-latex-base texlive-latex-extra texlive-fonts-recommended"
        echo "  sudo apt install texlive-biber biber"  # For bibliography
        echo ""
        echo -e "${YELLOW}For a full LaTeX installation:${NC}"
        echo "  sudo apt install texlive-full"
        echo ""
        echo -e "${YELLOW}On other systems:${NC}"
        echo "  - CentOS/RHEL: sudo yum install texlive texlive-latex"
        echo "  - macOS: brew install mactex"
        echo "  - Windows: Install MiKTeX or TeX Live"
        echo ""
        return 1
    fi
    
    if ! command_exists biber; then
        echo -e "${YELLOW}Warning: biber not found. Bibliography may not compile correctly.${NC}"
        echo "Install with: sudo apt install biber"
    fi
    
    echo -e "${GREEN}✓ LaTeX installation found${NC}"
    return 0
}

# Clean auxiliary files
clean_aux_files() {
    echo -e "${YELLOW}Cleaning auxiliary files...${NC}"
    rm -f *.aux *.log *.bbl *.blg *.bcf *.run.xml *.toc *.lof *.lot *.out *.fdb_latexmk *.fls *.synctex.gz
    rm -f chapters/*.aux samples_en/*.aux
    echo -e "${GREEN}✓ Cleaned auxiliary files${NC}"
}

# Compile the thesis
compile_thesis() {
    echo -e "${YELLOW}Compiling thesis...${NC}"
    echo ""
    
    # Change to thesis directory
    cd "$THESIS_DIR"
    
    # First pass: generate aux files and references
    echo -e "${BLUE}Pass 1: Initial compilation...${NC}"
    pdflatex -interaction=nonstopmode "$MAIN_TEX" || {
        echo -e "${RED}Error in first pdflatex pass${NC}"
        echo "Check the .log file for details"
        return 1
    }
    
    # Process bibliography if .bib file exists
    if [ -f "fpx3h0.bib" ]; then
        echo -e "${BLUE}Processing bibliography...${NC}"
        if command_exists biber; then
            biber fpx3h0_en || {
                echo -e "${YELLOW}Warning: biber failed, trying bibtex...${NC}"
                bibtex fpx3h0_en || echo -e "${YELLOW}Bibliography processing failed${NC}"
            }
        elif command_exists bibtex; then
            echo -e "${YELLOW}Using bibtex for bibliography processing...${NC}"
            bibtex fpx3h0_en || echo -e "${YELLOW}Bibliography processing failed${NC}"
        else
            echo -e "${YELLOW}Neither biber nor bibtex available, skipping bibliography${NC}"
        fi
    else
        echo -e "${YELLOW}No bibliography file (fpx3h0.bib) found${NC}"
    fi
    
    # Second pass: resolve references
    echo -e "${BLUE}Pass 2: Resolving references...${NC}"
    pdflatex -interaction=nonstopmode "$MAIN_TEX" || {
        echo -e "${RED}Error in second pdflatex pass${NC}"
        return 1
    }
    
    # Third pass: finalize (ensure all references are correct)
    echo -e "${BLUE}Pass 3: Final compilation...${NC}"
    pdflatex -interaction=nonstopmode "$MAIN_TEX" || {
        echo -e "${RED}Error in third pdflatex pass${NC}"
        return 1
    }
    
    echo ""
    echo -e "${GREEN}✓ Thesis compiled successfully!${NC}"
    
    if [ -f "$OUTPUT_PDF" ]; then
        FILE_SIZE=$(du -h "$OUTPUT_PDF" | cut -f1)
        echo -e "${GREEN}✓ Output: $OUTPUT_PDF ($FILE_SIZE)${NC}"
    else
        echo -e "${RED}Error: PDF file not generated${NC}"
        return 1
    fi
}

# Show compilation statistics
show_stats() {
    if [ -f "$OUTPUT_PDF" ]; then
        echo ""
        echo -e "${BLUE}Compilation Statistics:${NC}"
        echo -e "${BLUE}======================${NC}"
        
        # PDF info
        if command_exists pdfinfo; then
            PAGES=$(pdfinfo "$OUTPUT_PDF" 2>/dev/null | grep "Pages:" | awk '{print $2}')
            if [ -n "$PAGES" ]; then
                echo -e "Pages: ${GREEN}$PAGES${NC}"
            fi
        fi
        
        # File size
        FILE_SIZE=$(du -h "$OUTPUT_PDF" | cut -f1)
        echo -e "File size: ${GREEN}$FILE_SIZE${NC}"
        
        # Last modified
        LAST_MODIFIED=$(stat -c %y "$OUTPUT_PDF" 2>/dev/null | cut -d'.' -f1)
        echo -e "Generated: ${GREEN}$LAST_MODIFIED${NC}"
    fi
}

# Main execution
main() {
    # Parse command line arguments
    CLEAN_ONLY=false
    VERBOSE=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --clean)
                CLEAN_ONLY=true
                shift
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --clean    Clean auxiliary files only (don't compile)"
                echo "  --verbose  Show verbose output"
                echo "  --help     Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0                # Compile thesis"
                echo "  $0 --clean        # Clean auxiliary files"
                echo "  $0 --verbose      # Compile with verbose output"
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Clean auxiliary files
    clean_aux_files
    
    # If clean only, exit here
    if [ "$CLEAN_ONLY" = true ]; then
        echo -e "${GREEN}✓ Cleaning completed${NC}"
        exit 0
    fi
    
    # Check LaTeX installation
    if ! check_latex_installation; then
        exit 1
    fi
    
    # Compile thesis
    if compile_thesis; then
        show_stats
        echo ""
        echo -e "${GREEN}🎉 Thesis compilation completed successfully!${NC}"
        echo -e "${BLUE}Output file: $THESIS_DIR/$OUTPUT_PDF${NC}"
    else
        echo ""
        echo -e "${RED}❌ Thesis compilation failed${NC}"
        echo -e "${YELLOW}Check the .log file for detailed error information${NC}"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"