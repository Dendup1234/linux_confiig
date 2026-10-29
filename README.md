# linux_confiig

My personal Linux config, exported from Ubuntu 24.04 for migrating to **Omarchy** (Hyprland config excluded).

- `dotfiles/` — zsh, tmux (keybinds), git, nvim (kickstart), ghostty/kitty/alacritty, btop, fastfetch, cava, mpv, mise, VS Code settings + keybindings
- `packages/` — Arch package lists (`pacman.txt`, `aur.txt`), flatpak, npm, pipx, cargo, VS Code extensions, manual installs; `ubuntu-source/` has the original apt/snap lists
- `hyprland-keybinds/` — my Hyprland keybinds ported to Omarchy's `bindings.conf` + the original file
- `CLAUDE.md` — step-by-step instructions for Claude Code to set it all up

## On the new Omarchy machine
```bash
git clone https://github.com/Dendup1234/linux_confiig.git ~/linux_confiig
cd ~/linux_confiig
claude "Follow CLAUDE.md to set up this environment"
```
