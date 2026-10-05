#!/usr/bin/env bash
# ==============================================================================
# Pragmatic Software Design - Skill Suite Installer for Antigravity & Gemini CLI
# ==============================================================================

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="${REPO_ROOT}/skills"
GLOBAL_SKILLS_DIR="${HOME}/.gemini/config/skills"

SKILL_NAMES=(
    "prag-constitution"
    "prag-clarify"
    "prag-status"
    "prag-brd"
    "prag-srs"
    "prag-arch"
    "prag-api"
    "prag-db"
    "prag-tasks"
    "prag-implement"
    "prag-adr"
)

show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    --global            Install/symlink skills globally to ~/.gemini/config/skills (Default)
    --workspace <PATH>  Install/symlink skills to project workspace at <PATH>/.agents/skills
    --uninstall         Remove installed skill symlinks from global config
    --help              Show this help message
EOF
}

TARGET_DIR="${GLOBAL_SKILLS_DIR}"
ACTION="install"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --global)
            TARGET_DIR="${GLOBAL_SKILLS_DIR}"
            shift
            ;;
        --workspace)
            if [[ -z "${2:-}" ]]; then
                echo "Error: --workspace requires a directory path argument." >&2
                exit 1
            fi
            TARGET_DIR="${2}/.agents/skills"
            shift 2
            ;;
        --uninstall)
            ACTION="uninstall"
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done

if [[ "${ACTION}" == "uninstall" ]]; then
    echo "Uninstalling Pragmatic Software Design skills from ${TARGET_DIR}..."
    for skill in "${SKILL_NAMES[@]}"; do
        target_path="${TARGET_DIR}/${skill}"
        if [[ -L "${target_path}" || -d "${target_path}" ]]; then
            rm -rf "${target_path}"
            echo "  [REMOVED] ${skill}"
        fi
    done
    echo "Uninstallation complete."
    exit 0
fi

echo "Installing Pragmatic Software Design skills into ${TARGET_DIR}..."
mkdir -p "${TARGET_DIR}"

for skill in "${SKILL_NAMES[@]}"; do
    src_path="${SKILLS_SRC}/${skill}"
    dest_path="${TARGET_DIR}/${skill}"

    if [[ ! -d "${src_path}" ]]; then
        echo "Error: Source skill not found at ${src_path}" >&2
        exit 1
    fi

    # Remove existing link or directory if present
    if [[ -L "${dest_path}" || -d "${dest_path}" ]]; then
        rm -rf "${dest_path}"
    fi

    ln -s "${src_path}" "${dest_path}"
    echo "  [LINKED] ${skill} -> ${dest_path}"
done

echo ""
echo "Installation successful! 10 skills active in ${TARGET_DIR}:"
for skill in "${SKILL_NAMES[@]}"; do
    echo "  - /${skill}"
done
