#!/usr/bin/env bash
# Usage: ./link-dotfiles.sh [-a|--all] [config_name...]

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

show_usage() {
    echo "Usage: $0 [-a|--all] [config_name...]"
    echo ""
    echo "Options:"
    echo "  -a, --all           Link all available configs"
    echo "  config_name...      Link specific configs by name"
    echo ""
    echo "Available configs:"
    for dir in "$DOTFILES_DIR"/*/; do
        config_name="$(basename "$dir")"
        [[ "$config_name" == .* ]] && continue
        echo "  - $config_name"
    done
}

link_config() {
    local config_name="$1"
    local source_dir="$DOTFILES_DIR/$config_name"
    local target_dir="$CONFIG_DIR/$config_name"

    if [[ ! -d "$source_dir" ]]; then
        echo "Warning: $source_dir does not exist, skipping..."
        return 1
    fi

    if [[ -e "$target_dir" && ! -L "$target_dir" ]]; then
        echo "Backing up existing $target_dir to ${target_dir}.backup"
        mv "$target_dir" "${target_dir}.backup"
    elif [[ -L "$target_dir" ]]; then
        rm "$target_dir"
    fi

    ln -s "$source_dir" "$target_dir"
    echo "✓ Linked $config_name"
}

if [[ $# -eq 0 ]]; then
    show_usage
    exit 0
fi

if [[ "$1" == "-a" || "$1" == "--all" ]]; then
    # Link all configs that have a directory
    for dir in "$DOTFILES_DIR"/*/; do
        config_name="$(basename "$dir")"
        # Skip hidden dirs and non-config dirs
        [[ "$config_name" == .* ]] && continue
        link_config "$config_name"
    done
else
    # Link specific configs
    for config_name in "$@"; do
        link_config "$config_name"
    done
fi
