# Instructions for Claude: set up this config on a fresh Omarchy install

You are on a new **Omarchy** machine (Arch Linux + Hyprland, by DHH). These dotfiles and package
lists came from the user's previous **Ubuntu 24.04** machine. Your job is to reproduce that
environment on Omarchy **without touching Omarchy's Hyprland setup**.

## Hard rules
- **Do NOT modify** anything Omarchy owns for the desktop: `~/.config/hypr/`, `~/.config/waybar/`,
  `~/.config/walker/`, `~/.config/mako/`, `~/.config/omarchy/`, `~/.local/share/omarchy/`.
  Hyprland config is intentionally not in this repo.
- **Back up before overwriting** any existing file: move it to `<file>.omarchy-bak` first.
- Use `pacman -S --needed` / `yay -S --needed` so already-installed packages are skipped.
- Don't install the Ubuntu-only items in `packages/ubuntu-source/` directly — that folder is the
  original reference only. Hyprland, nvidia drivers, grub, snap are deliberately excluded.
- Ask the user before: changing the login shell, enabling system services, or installing
  anything over ~1 GB (steam, virtualbox, jdk, android-tools).
- If a package name fails, search (`pacman -Ss`, `yay -Ss`) for the equivalent and tell the user
  what you substituted. Report every package that could not be installed at the end.

## Steps

1. **Confirm the environment**: `cat /etc/os-release`, check `~/.local/share/omarchy` exists,
   check `yay` is available.

2. **Packages**
   ```bash
   sudo pacman -S --needed - < <(grep -vE '^\s*(#|$)' packages/pacman.txt)
   yay -S --needed - < <(grep -vE '^\s*(#|$)' packages/aur.txt)
   flatpak install -y flathub $(cat packages/flatpak.txt)   # zen, postman, spotify, lutris, shadPS4
   ```
   Skip flatpak entries already covered by pacman/AUR (e.g. Postman, Zen) — ask which the user prefers.
   Omarchy ships its own Spotify/Chromium/etc.; don't duplicate them.
   Then `pipx install` each line of `packages/pipx.txt` (note: package `graphifyy` is spelled with two y's),
   and after Node is set up, `npm i -g` each line of `packages/npm-global.txt`.
   `packages/cargo.txt` tools are already in pacman.txt — only `cargo install` them if pacman lacked them.
   VS Code extensions: `xargs -n1 code --install-extension < packages/vscode-extensions.txt`.

3. **Manual installs** — follow `packages/manual-installs.md` (oh-my-zsh + plugins, tmux-resurrect,
   nvm, bun, foundry, mise ruby, gems).
   Install oh-my-zsh with `--keep-zshrc` / `--unattended` so it does not replace our `.zshrc`.

4. **Dotfiles** — copy from `dotfiles/` into `$HOME` (back up first):
   | Repo path | Destination | Notes |
   |---|---|---|
   | `dotfiles/.zshrc` | `~/.zshrc` | Omarchy defaults to **bash**. After install ask the user, then `chsh -s /usr/bin/zsh`. |
   | `dotfiles/.zshenv` | `~/.zshenv` | |
   | `dotfiles/.zshrc.local.example` | `~/.zshrc.local` | Ask the user for the server IP; never commit. |
   | `dotfiles/.tmux.conf` | `~/.tmux.conf` | Keybinds: Alt/Ctrl+1-9 switch windows, Ctrl+Shift+Enter new window, prefix+r reload. If Omarchy has `~/.config/tmux/tmux.conf`, back it up and remove it so ours wins. |
   | `dotfiles/.gitconfig` | `~/.gitconfig` | Uses `gh` as credential helper → run `gh auth login`. |
   | `dotfiles/.config/nvim` | `~/.config/nvim` | kickstart.nvim. Omarchy ships LazyVim here — back it up to `~/.config/nvim.omarchy-bak` first. Then run `nvim --headless "+Lazy! sync" +qa`. |
   | `dotfiles/.config/ghostty`, `kitty`, `alacritty` | `~/.config/…` | Omarchy's theme switcher writes terminal color/font includes. **Merge**: keep any Omarchy `import`/`include` lines for theme, add the user's settings (opacity, padding, font size, etc.) on top. |
   | `dotfiles/.config/btop`, `fastfetch`, `cava`, `mpv`, `mise` | `~/.config/…` | Same merge rule for btop/fastfetch if Omarchy pre-populated them. |
   | `dotfiles/.config/Code/User/*` | `~/.config/Code/User/` | VS Code settings + keybindings (Shift+Enter in terminal sends ESC+CR for Claude Code). Wallpaper paths point to `~/Pictures/wallpapers/` — tell the user to copy those images over. |

5. **Services** (ask first): `sudo systemctl enable --now docker tailscaled bluetooth`,
   `sudo usermod -aG docker $USER`. PostgreSQL needs `sudo -iu postgres initdb -D /var/lib/postgres/data`
   before `systemctl enable --now postgresql`.

6. **Runtimes**: `nvm install 24 && nvm alias default 24`; `mise install`; `gem install` the Rails gems.

7. **Verify**: open a new zsh — no errors on startup, fastfetch/pokemon shows, `eza`, `tmux`, `nvim`,
   `node -v`, `ruby -v`, `docker ps`, `gh auth status` all work. Summarize what was installed,
   what was substituted, and what failed.

## Known differences vs the old machine
- `update` alias now runs `yay -Syu` (was apt).
- The old `.zshrc` ran `~/build_push_tag_script.sh` on every shell start and sourced gcloud from
  `~/Downloads/google-cloud-sdk`; both were removed (gcloud now comes from AUR `google-cloud-cli`).
- The old Neovim was a manual install in `/opt/nvim-linux-x86_64`; now it's the pacman `neovim`.
- Excluded on purpose (Omarchy has its own): hypr, waybar, rofi, swaync, wlogout, quickshell, ags.
