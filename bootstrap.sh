#!/usr/bin/env bash
set -e

readonly RESERVED_USERS="root nobody bin daemon dbus ftp git http mail alpm builder systemd cron games smmsp uuidd"
readonly SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly GUM_COLOR="212"

TMP_DIRS=()
cleanup_tmp() {
    for dir in "${TMP_DIRS[@]}"; do
        rm -rf "$dir"
    done
}
trap cleanup_tmp EXIT

gum_choose() {
    local header="${1:-Select an option:}"
    shift
    gum choose \
        --header.foreground "$GUM_COLOR" \
        --header "$header" \
        --padding="1 1" \
        "$@"
}

gum_announce() {
    if command -v gum >/dev/null 2>&1; then
        gum style \
            --border double \
            --margin 1 \
            --padding "1 1" \
            --border-foreground "$GUM_COLOR" \
            --foreground "$GUM_COLOR" \
            "$1" >&2
    else
        printf "\n\033[1;36m%s\033[0m\n" \
            "══════════════════════════════════════════════════════════" >&2
        printf "\033[1;36m  %s\033[0m\n" "$1" >&2
        printf "\033[1;36m%s\033[0m\n\n" \
            "══════════════════════════════════════════════════════════" >&2
    fi
}

gum_prompt() {
    local prompt="$1"
    local default="${2:-}"
    local input

    input="$(
        gum input \
            --header "$prompt" \
            --header.foreground "$GUM_COLOR" \
            --prompt "> " \
            --prompt.foreground "$GUM_COLOR" \
            --placeholder "$default" \
            --placeholder.foreground 8 \
            --cursor.foreground "$GUM_COLOR" \
            --no-show-help \
            --padding="1 1"
    )" || true

    if [ -z "$input" ]; then
        input="$default"
    fi

    printf "%s" "$input"
}

get_user_prompt() {
    while true; do
        local username=$(gum_prompt "Enter the username for your user" "kachi")

        if echo "$RESERVED_USERS" | grep -qw "$username"; then
            gum_announce "Username '$username' is reserved for system use. Please choose a different one."
            continue
        fi

        echo "$username"
        return 0
    done
}

get_user() {
    local reserved_regex="$(echo "$RESERVED_USERS" | tr ' ' '|')"
    local existing_users="$(ls -1 /home/ 2>/dev/null | grep -vE "^($reserved_regex)$" | sort | sed '/^$/d')"

    local choices
    choices=($existing_users "*I want to create a new user*")
    choice=$(gum_choose "Select a user or create a new one" "${choices[@]}")

    case "$choice" in
    "*I want to create a new user*")
        get_user_prompt
        ;;
    "")
        get_user_prompt
        ;;
    *)
        gum_announce "User $choice selected."
        echo "$choice"
        ;;
    esac
}

deelevate_permissions() {
    gum_announce "Logging in..."

    local username
    username=$(get_user)

    if id -u "$username" >/dev/null 2>&1; then
        gum_announce "User with name '$username' already exists. Proceeding."
    else
        gum_announce "User $username not found, creating it now..."

        useradd -m -s /bin/bash "$username"
        usermod -aG wheel "$username"

        gum_announce "User $username has been created, and added to the wheel group."
        gum_announce "Please input the password for user $username."

        while true; do
            passwd "$username" && break
            gum_announce "Password setup failed. Please try again."
        done

        gum_announce "The wheel group now has access to nopasswd sudo."

        echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/wheel-nopasswd
        chmod 440 /etc/sudoers.d/wheel-nopasswd
        echo "Defaults !requiretty" >/etc/sudoers.d/requiretty
        chmod 440 /etc/sudoers.d/requiretty
    fi

    exec sudo -i -u "$username" "$(realpath "$0")" "$@"
}

declare -A main_script_function_map=(
    ["Set up AUR (with Paru)"]="setup_paru"
    ["Set up the dotfiles"]="setup_dotfiles"
    ["Set up all"]="setup_all"
)

setup_paru() {
    if command -v paru >/dev/null 2>&1; then
        gum_announce "Paru has already been set up!"
        return 0
    fi

    gum_announce "Setting Paru up..."

    if pacman -Si paru >/dev/null 2>&1; then
        sudo pacman -S --needed paru
    else
        TMP_DIR=$(mktemp -d)
        TMP_DIRS+=("$TMP_DIR")
        cd "$TMP_DIR" || exit 1
        git clone --depth 1 https://aur.archlinux.org/paru.git .
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
    fi
}

setup_dotfiles() {
    gum_announce "Setting Kachi's dotfiles up..."

    sudo pacman -S --noconfirm --needed direnv just stow

    mkdir -p ~/dotfiles

    declare -A repos=(
        [stow]="PokumeKachi/dotfiles-stow.git"
        [konfigkoll]="PokumeKachi/dotfiles-konfigkoll.git"
        [nix]="PokumeKachi/dotfiles-nix.git"
    )

    for name in "${!repos[@]}"; do
        repo="${repos[$name]}"
        target="$HOME/dotfiles/$name"

        if [ -d "$target/.git" ]; then
            gum_announce "$name already exists, skipping..."
            continue
        fi

        repo=$(gum_prompt "Which $name GitHub repo to use?" "$repo")

        git clone "https://github.com/$repo" "$target"
        git -C "$target" remote set-url origin "git@github.com:$repo"
    done
}

setup_stow() {
    cd ~/dotfiles/stow && mkdir -p ~/.config && just link
}

setup_nix() {
    if command -v nix >/dev/null 2>&1; then
        gum_announce "Nix has already been set up!"
    else
        curl -sSf -L https://install.lix.systems/lix | sudo sh -s -- install --no-confirm
        cd ~ && just nix-switch
    fi
}

setup_konfigkoll() {
    if command -v konfigkoll >/dev/null 2>&1; then
        gum_announce "Konfigkoll has already been set up!"
    else
        paru -S --noconfirm --needed konfigkoll
    fi
}

setup_all() {
    setup_paru
    setup_dotfiles
    setup_stow
    setup_nix
    setup_konfigkoll
}

gum_announce "Script starting. Setting up the base..."

if [ "$(id -u)" -eq 0 ]; then
    pacman -Sy --noconfirm
    pacman -S --noconfirm --needed base base-devel git gum
    deelevate_permissions
else
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm --needed base base-devel git gum
fi

cd ~

gum_announce "Init all done"

while true; do
    choice=$(gum_choose "Now what do you wanna do?" "${!main_script_function_map[@]}" "Exit")

    if [[ -z "$choice" ]] || [[ "$choice" == "Exit" ]]; then
        break
    fi

    clear

    if [[ -n "$choice" && -n "${main_script_function_map[$choice]}" ]]; then
        ${main_script_function_map[$choice]}
    fi
done

gum_announce "Script done!"
