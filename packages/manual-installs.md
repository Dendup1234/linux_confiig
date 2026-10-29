# Things not installed by a package manager

| Tool | How |
|---|---|
| oh-my-zsh | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc` |
| zsh-autosuggestions | `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions` |
| zsh-syntax-highlighting | `git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting` |
| tmux-resurrect | `git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect` |
| nvm + Node v24.12.0 (also had v26.11.1) | `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh \| bash`, then `nvm install 24` |
| bun | `curl -fsSL https://bun.sh/install \| bash` |
| Foundry | `curl -L https://foundry.paradigm.xyz \| bash && foundryup` |
| Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` |
| Ruby 3.4.9 | via mise: `mise install` (reads ~/.config/mise/config.toml) |
| Rails toolchain gems (rails, rubocop, ruby-lsp, rspec, kamal, brakeman…) | `gem install rails rubocop ruby-lsp rspec kamal brakeman bundler-audit` after mise ruby |
| JetBrains Toolbox | AUR `jetbrains-toolbox` |
| Ghidra 12.1 | AUR `ghidra` or download to ~/ghidra_12.1_PUBLIC |
| Hopper disassembler | AUR `hopper-disassembler` or vendor download |
| ChatGPT desktop | no official Linux build — use web app / Omarchy web-app launcher |
| Render CLI, ngrok | `npm i -g` list in npm-global.txt / AUR `render-cli-bin`, `ngrok` |
