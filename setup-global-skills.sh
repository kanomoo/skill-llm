#!/usr/bin/env bash
set -e

# =======================================================
#  Antigravity Universal Skills and Standards Installer
#  Bash Edition (Linux / macOS)
# =======================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECTS_ROOT="${HOME}/Projects"
SKIP_GIT_PUSH=false
GLOBAL_ONLY=false

# ANSI color codes
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
GRAY='\033[0;90m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print Header
echo -e "\n${CYAN}=======================================================${NC}"
echo -e "${CYAN} Antigravity Universal Skills and Standards Installer ${NC}"
echo -e "${CYAN}=======================================================${NC}\n"

# Help message
show_help() {
    cat << 'EOHELP'
Usage: ./setup-global-skills.sh [OPTIONS]

Options:
    --projects-root <PATH>   Specify root directory of projects (default: $HOME/Projects)
    --skip-git-push          Stage and commit changes without pushing to remote
    --global-only            Install only to global directories (~/.gemini and ~/.agents)
    -h, --help               Display this help message
EOHELP
    exit 0
}

# Parse CLI arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --projects-root)
            PROJECTS_ROOT="$2"
            shift 2
            ;;
        --skip-git-push)
            SKIP_GIT_PUSH=true
            shift
            ;;
        --global-only)
            GLOBAL_ONLY=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            ;;
    esac
done

# Source assets validation
SOURCE_RULES="${SCRIPT_DIR}/.agents/rules/pdf_document_standards.md"
SOURCE_SKILL_ACADEMIC="${SCRIPT_DIR}/.agents/skills/academic-project-report"
SOURCE_SKILL_PDF="${SCRIPT_DIR}/.agents/skills/pdf-worksheet-solver"
SOURCE_SKILL_SLIDE="${SCRIPT_DIR}/.agents/skills/slide-designer"
SOURCE_AGENTS_MD="${SCRIPT_DIR}/AGENTS.md"

if [[ ! -f "$SOURCE_RULES" || ! -d "$SOURCE_SKILL_ACADEMIC" || ! -d "$SOURCE_SKILL_PDF" || ! -d "$SOURCE_SKILL_SLIDE" || ! -f "$SOURCE_AGENTS_MD" ]]; then
    echo -e "${RED}Source files missing in ${SCRIPT_DIR}. Please ensure source skills and rules exist.${NC}"
    exit 1
fi

# 1. Global Installation: ~/.gemini and ~/.agents
echo -e "${YELLOW}[1/2] Installing Global Skills and Rules...${NC}"

GLOBAL_TARGETS=(
    "${HOME}/.gemini/config|Antigravity Global (~/.gemini/config)"
    "${HOME}/.agents|Universal Agent Global (~/.agents)"
)

for entry in "${GLOBAL_TARGETS[@]}"; do
    IFS="|" read -r base_dir target_name <<< "$entry"
    echo -e "  ${GRAY}-> Configuring ${target_name}...${NC}"

    skills_dir="${base_dir}/skills"
    rules_dir="${base_dir}/rules"

    mkdir -p "$skills_dir" "$rules_dir"

    # Copy rules
    cp "$SOURCE_RULES" "${rules_dir}/pdf_document_standards.md"

    # Copy skills
    rm -rf "${skills_dir}/academic-project-report" "${skills_dir}/pdf-worksheet-solver" "${skills_dir}/slide-designer"
    cp -r "$SOURCE_SKILL_ACADEMIC" "${skills_dir}/"
    cp -r "$SOURCE_SKILL_PDF" "${skills_dir}/"
    cp -r "$SOURCE_SKILL_SLIDE" "${skills_dir}/"

    # Clean pycache
    find "${skills_dir}/academic-project-report" "${skills_dir}/pdf-worksheet-solver" "${skills_dir}/slide-designer" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find "${skills_dir}/academic-project-report" "${skills_dir}/pdf-worksheet-solver" "${skills_dir}/slide-designer" -type f -name "*.pyc" -delete 2>/dev/null || true
done

echo -e "  ${GREEN}Global skills and rules successfully updated!${NC}\n"

if [[ "$GLOBAL_ONLY" == true ]]; then
    echo -e "${GREEN}GlobalOnly flag set. Finished!${NC}"
    exit 0
fi

# 2. Project-level Deployment
echo -e "${YELLOW}[2/2] Scanning and Deploying to Projects in ${PROJECTS_ROOT}...${NC}"

if [[ ! -d "$PROJECTS_ROOT" ]]; then
    echo -e "${RED}Projects root directory not found: ${PROJECTS_ROOT}${NC}"
    exit 0
fi

# Collect project directories
projects=()
while IFS= read -r -d $'\0' dir; do
    projects+=("$dir")
done < <(find "$PROJECTS_ROOT" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

total_projects=${#projects[@]}
current_index=0

for proj_path in "${projects[@]}"; do
    current_index=$((current_index + 1))
    proj_name="$(basename "$proj_path")"

    # Skip the skill repo itself and external repos
    if [[ "$proj_path" == "$SCRIPT_DIR" || "$proj_name" == "Arch-Hyprland" ]]; then
        echo -e "  ${CYAN}[${current_index}/${total_projects}] Skipping '${proj_name}'${NC}"
        continue
    fi

    echo -e "  ${CYAN}[${current_index}/${total_projects}] Processing '${proj_name}'...${NC}"

    target_rules_dir="${proj_path}/.agents/rules"
    target_skills_dir="${proj_path}/.agents/skills"
    target_agents_md="${proj_path}/AGENTS.md"

    mkdir -p "$target_rules_dir" "$target_skills_dir"

    # Copy rules and skills
    cp "$SOURCE_RULES" "${target_rules_dir}/pdf_document_standards.md"
    rm -rf "${target_skills_dir}/academic-project-report" "${target_skills_dir}/pdf-worksheet-solver" "${target_skills_dir}/slide-designer"
    cp -r "$SOURCE_SKILL_ACADEMIC" "${target_skills_dir}/"
    cp -r "$SOURCE_SKILL_PDF" "${target_skills_dir}/"
    cp -r "$SOURCE_SKILL_SLIDE" "${target_skills_dir}/"
    cp "$SOURCE_AGENTS_MD" "$target_agents_md"

    # Clean pycache
    find "${target_skills_dir}/academic-project-report" "${target_skills_dir}/pdf-worksheet-solver" "${target_skills_dir}/slide-designer" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find "${target_skills_dir}/academic-project-report" "${target_skills_dir}/pdf-worksheet-solver" "${target_skills_dir}/slide-designer" -type f -name "*.pyc" -delete 2>/dev/null || true

    # Git handling
    if [[ -d "${proj_path}/.git" ]]; then
        # Check git status for our files
        status="$(git -C "$proj_path" status --porcelain -- AGENTS.md .agents)"
        if [[ -n "$status" ]]; then
            echo -e "    ${GRAY}-> Changes detected in git repo. Staging and committing...${NC}"
            git -C "$proj_path" add AGENTS.md .agents
            git -C "$proj_path" commit -m "feat(agents): update universal skills (academic-project-report, slide-designer, pdf-worksheet-solver) and standards" --quiet

            if [[ "$SKIP_GIT_PUSH" == false ]]; then
                branch="$(git -C "$proj_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")"
                echo -e "    ${GRAY}-> Pushing to origin/${branch}...${NC}"
                if git -C "$proj_path" push origin "$branch" 2>&1; then
                    echo -e "    ${GREEN}Pushed to origin/${branch} successfully!${NC}"
                else
                    echo -e "    ${YELLOW}Git push warning/error for ${proj_name}.${NC}"
                fi
            else
                echo -e "    ${GREEN}Committed (push skipped).${NC}"
            fi
        else
            echo -e "    ${GREEN}Up to date (no changes needed).${NC}"
        fi
    else
        echo -e "    ${GREEN}Deployed (.agents and AGENTS.md installed, non-git folder).${NC}"
    fi
done

echo -e "\n${CYAN}=======================================================${NC}"
echo -e "${GREEN} ALL PROJECTS AND GLOBAL SKILLS FULLY SYNCHRONIZED! ${NC}"
echo -e "${CYAN}=======================================================${NC}\n"
