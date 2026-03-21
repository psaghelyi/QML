# Makefile for LaTeX Thesis Compilation
# Compiles fpx3h0_en.tex to PDF with proper dependency handling

# Variables
MAIN = fpx3h0_en
MAIN_TEX = $(MAIN).tex
MAIN_PDF = $(MAIN).pdf
BIB_FILE = fpx3h0.bib

# Source files
TEX_FILES = $(MAIN_TEX) \
			chapters/abstract.tex \
            chapters/intro.tex \
            chapters/related_work.tex \
            chapters/definitions.tex \
            chapters/compilation.tex \
            chapters/comprehensive_validation.tex \
            chapters/closing.tex \
            chapters/appendix.tex

# Generated files to clean
AUX_FILES = *.aux *.log *.bbl *.blg *.bcf *.run.xml *.toc *.lof *.lot *.out \
            *.fdb_latexmk *.fls *.synctex.gz *.idx *.loa *.lol *.nlo chapters/*.aux

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
RED = \033[0;31m
NC = \033[0m

# Default target
.PHONY: all
all: $(MAIN_PDF)

# Main PDF compilation with dependency tracking
$(MAIN_PDF): $(TEX_FILES) $(BIB_FILE)
	@echo -e "$(BLUE)Compiling thesis...$(NC)"
	@echo -e "$(YELLOW)Pass 1: Initial compilation...$(NC)"
	@pdflatex -interaction=nonstopmode $(MAIN_TEX) > /dev/null 2>&1 || true
	@if [ -f "$(BIB_FILE)" ]; then \
		echo -e "$(YELLOW)Processing bibliography...$(NC)"; \
		if command -v biber >/dev/null 2>&1; then \
			biber $(MAIN) > /dev/null 2>&1 || { \
				echo -e "$(YELLOW)biber failed, trying bibtex...$(NC)"; \
				bibtex $(MAIN) > /dev/null 2>&1 || echo -e "$(YELLOW)Bibliography processing failed$(NC)"; \
			}; \
		else \
			echo -e "$(YELLOW)biber not available, skipping bibliography$(NC)"; \
		fi; \
	fi
	@echo -e "$(YELLOW)Pass 2: Resolving references...$(NC)"
	@pdflatex -interaction=nonstopmode $(MAIN_TEX) > /dev/null 2>&1 || true
	@echo -e "$(YELLOW)Pass 3: Final compilation...$(NC)"
	@pdflatex -interaction=nonstopmode $(MAIN_TEX) > /dev/null 2>&1 || true
	@echo -e "$(GREEN)✓ Thesis compiled successfully!$(NC)"
	@if [ -f "$(MAIN_PDF)" ]; then \
		FILE_SIZE=$$(du -h "$(MAIN_PDF)" | cut -f1); \
		echo -e "$(GREEN)✓ Output: $(MAIN_PDF) ($$FILE_SIZE)$(NC)"; \
	fi

# Quick compilation (single pass, for draft mode)
.PHONY: draft
draft: $(TEX_FILES)
	@echo -e "$(BLUE)Quick draft compilation...$(NC)"
	@pdflatex -interaction=nonstopmode $(MAIN_TEX) > /dev/null || { \
		echo -e "$(RED)Draft compilation failed$(NC)"; \
		exit 1; \
	}
	@echo -e "$(GREEN)✓ Draft compiled$(NC)"

# Verbose compilation (show all output)
.PHONY: verbose
verbose: $(TEX_FILES) $(BIB_FILE)
	@echo -e "$(BLUE)Verbose compilation...$(NC)"
	-pdflatex -interaction=nonstopmode $(MAIN_TEX)
	@if [ -f "$(BIB_FILE)" ]; then \
		if command -v biber >/dev/null 2>&1; then \
			biber $(MAIN) || bibtex $(MAIN) || true; \
		fi; \
	fi
	-pdflatex -interaction=nonstopmode $(MAIN_TEX)
	-pdflatex -interaction=nonstopmode $(MAIN_TEX)
	@echo -e "$(GREEN)✓ Verbose compilation completed$(NC)"

# Clean auxiliary files
.PHONY: clean
clean:
	@echo -e "$(YELLOW)Cleaning auxiliary files...$(NC)"
	@rm -f $(AUX_FILES)
	@echo -e "$(GREEN)✓ Cleaned auxiliary files$(NC)"

# Clean everything including PDF
.PHONY: distclean
distclean: clean
	@echo -e "$(YELLOW)Removing PDF output...$(NC)"
	@rm -f $(MAIN_PDF)
	@echo -e "$(GREEN)✓ All files cleaned$(NC)"

# Check LaTeX installation
.PHONY: check
check:
	@echo -e "$(BLUE)Checking LaTeX installation...$(NC)"
	@if command -v pdflatex >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓ pdflatex found: $$(which pdflatex)$(NC)"; \
		echo -e "$(GREEN)✓ LaTeX version: $$(pdflatex --version | head -n1)$(NC)"; \
	else \
		echo -e "$(RED)✗ pdflatex not found$(NC)"; \
		echo -e "$(YELLOW)Install with: sudo apt install texlive-latex-base texlive-latex-extra$(NC)"; \
	fi
	@if command -v biber >/dev/null 2>&1; then \
		echo -e "$(GREEN)✓ biber found: $$(which biber)$(NC)"; \
	else \
		echo -e "$(YELLOW)⚠ biber not found (bibliography may not work)$(NC)"; \
		echo -e "$(YELLOW)Install with: sudo apt install biber$(NC)"; \
	fi

# Watch for changes and auto-compile (requires inotify-tools)
.PHONY: watch
watch:
	@if ! command -v inotifywait >/dev/null 2>&1; then \
		echo -e "$(RED)inotifywait not found$(NC)"; \
		echo -e "$(YELLOW)Install with: sudo apt install inotify-tools$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(BLUE)Watching for changes... (Ctrl+C to stop)$(NC)"
	@while true; do \
		inotifywait -r -e modify,create --include '\.tex$$' .; \
		echo -e "$(YELLOW)Change detected, recompiling...$(NC)"; \
		$(MAKE) draft; \
	done

# Show thesis statistics
.PHONY: stats
stats: $(MAIN_PDF)
	@echo -e "$(BLUE)Thesis Statistics$(NC)"
	@echo -e "$(BLUE)=================$(NC)"
	@if [ -f "$(MAIN_PDF)" ]; then \
		if command -v pdfinfo >/dev/null 2>&1; then \
			PAGES=$$(pdfinfo "$(MAIN_PDF)" 2>/dev/null | grep "Pages:" | awk '{print $$2}'); \
			if [ -n "$$PAGES" ]; then \
				echo -e "Pages: $(GREEN)$$PAGES$(NC)"; \
			fi; \
		fi; \
		FILE_SIZE=$$(du -h "$(MAIN_PDF)" | cut -f1); \
		echo -e "File size: $(GREEN)$$FILE_SIZE$(NC)"; \
		LAST_MODIFIED=$$(stat -c %y "$(MAIN_PDF)" 2>/dev/null | cut -d'.' -f1); \
		echo -e "Generated: $(GREEN)$$LAST_MODIFIED$(NC)"; \
		WORD_COUNT=$$(texcount -total -q $(MAIN_TEX) 2>/dev/null || echo "N/A"); \
		echo -e "Word count: $(GREEN)$$WORD_COUNT$(NC)"; \
	else \
		echo -e "$(RED)PDF not found. Run 'make' first.$(NC)"; \
	fi

# Install LaTeX dependencies (Ubuntu/Debian)
.PHONY: install-deps
install-deps:
	@echo -e "$(BLUE)Installing LaTeX dependencies...$(NC)"
	@if command -v apt >/dev/null 2>&1; then \
		sudo apt update; \
		sudo apt install -y texlive-latex-base texlive-latex-extra texlive-fonts-recommended; \
		sudo apt install -y biber texlive-bibtex-extra; \
		sudo apt install -y texlive-science;  # For additional math packages \
		echo -e "$(GREEN)✓ LaTeX dependencies installed$(NC)"; \
	else \
		echo -e "$(YELLOW)apt not found. Install LaTeX manually for your system.$(NC)"; \
	fi

# Help target
.PHONY: help
help:
	@echo -e "$(BLUE)Thesis Compilation Makefile$(NC)"
	@echo -e "$(BLUE)===========================$(NC)"
	@echo ""
	@echo -e "$(GREEN)Targets:$(NC)"
	@echo -e "  $(YELLOW)all$(NC)         - Compile thesis (default)"
	@echo -e "  $(YELLOW)draft$(NC)       - Quick single-pass compilation"
	@echo -e "  $(YELLOW)verbose$(NC)     - Compile with full output"
	@echo -e "  $(YELLOW)clean$(NC)       - Remove auxiliary files"
	@echo -e "  $(YELLOW)distclean$(NC)   - Remove all generated files"
	@echo -e "  $(YELLOW)check$(NC)       - Check LaTeX installation"
	@echo -e "  $(YELLOW)watch$(NC)       - Auto-compile on changes"
	@echo -e "  $(YELLOW)stats$(NC)       - Show thesis statistics"
	@echo -e "  $(YELLOW)install-deps$(NC) - Install LaTeX dependencies (Ubuntu/Debian)"
	@echo -e "  $(YELLOW)help$(NC)        - Show this help"
	@echo ""
	@echo -e "$(GREEN)Examples:$(NC)"
	@echo -e "  make              # Compile thesis"
	@echo -e "  make clean all    # Clean and compile"
	@echo -e "  make watch        # Auto-compile on changes"
	@echo -e "  make check        # Check if LaTeX is installed"

# Default to building the PDF
.DEFAULT_GOAL := all