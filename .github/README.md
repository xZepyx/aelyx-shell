<div align="center">

<img src="/assets/aelyx-logo.png" width="550" height="380" />

<p>
  <img src="https://img.shields.io/github/last-commit/xZepyx/aelyx-shell?style=for-the-badge&color=8ad7eb&logo=git&logoColor=D9E0EE&labelColor=1E202B" alt="Last Commit" />
  &nbsp;
  <img src="https://img.shields.io/github/stars/xZepyx/aelyx-shell?style=for-the-badge&logo=andela&color=86dbd7&logoColor=D9E0EE&labelColor=1E202B" alt="Stars" />
  &nbsp;
  <img src="https://img.shields.io/github/repo-size/xZepyx/aelyx-shell?color=86dbce&label=SIZE&logo=protondrive&style=for-the-badge&logoColor=D9E0EE&labelColor=1E202B" alt="Repo Size" />
  &nbsp;
  <img src="https://img.shields.io/badge/Maintenance-Active%20-6BCB77?style=for-the-badge&logo=vercel&logoColor=D9E0EE&labelColor=1E202B" alt="Maintenance" />
</p>

</div>

---

## Overview

aelyx-shell is a set of shell dotfiles and utility scripts authored in QuickShell. The collection emphasizes:

Target users: developers and linux users who prefer script-first shell configurations.

---

## Previews

| Desktop                                          | Launcher                                           |
| ------------------------------------------------ | -------------------------------------------------- |
| ![Widgets](previews/1.png) | ![Launcher](previews/2.png) |

---

## Repository layout

- /dots/           — Main shell dotfiles
- /dots-extra/     — Extra dotfiles and wallpapers
- /license/        — License details
- /previews/       — Example previews
- bootstrap.sh     — Dependency installation script

---

## Automated Installation (recommended)

1. Clone the repository:
    ```bash
    git clone https://github.com/xZepyx/aelyx-shell.git ~/.aelyx-shell
    cd ~/.aelyx-shell
    ```

2. Review configuration and optional modules:
    - Inspect `dots/` and `dots-extra/` before applying changes to your profile.

3. Run the install script (install dependencies):
    ```bash
    cd setup && bash install.sh
    ```

4. Reload your shell or start a new session

Notes:
- The bootstrap script is intentionally conservative.
- Manual installation (symlinking files yourself) is supported and recommended for cautious users.

---

## Configuration and customization

- Configure the shell by editing `~/.config/aelyxshell/config.json` or using the builtin settings app..
- Prompt and completion settings are separated into dedicated modules for easy replacement.

---

## Recommended environment

- Shell: QuickShell-compatible environment (see QuickShell docs) (Hyprland is Recommended)
- Terminal: A modern terminal emulator (Kitty is Recommended)
- Fonts: A patched monospace font with ligatures is optional for prompts and status displays 
- Git: recommended for dotfile updates and synchronization

---

## Troubleshooting

- Function or alias missing: verify module file execution order in `~/.config/quickshell/shell.qml`.
- Performance on startup: disable unused modules or lazy-load heavy features.
- Conflicting user configs: check for existing profile files (`~/.bashrc`, `~/.profile`, `~/.zshrc`) before bootstrapping.


---

## To-Do

- Make the config more accessible by making a install.sh script

---

## Contributing

Contributions are accepted following the repository's contribution guidelines. When contributing:
- Open concise issues after checking that it is a bug in the config.
- Submit focused PRs with clear descriptions and tests where applicable.
- Respect code structure and naming conventions used in `dots/`.

Refer to GITHUB CONTRIBUTING for details.

---

## Maintainer

- Maintainer: xZepyx 
- Contact: [zepyxunderscore@gmail.com](mailto:zepyxunderscore@gmail.com)

---

## Acknowledgments

- QuickShell and its contributors/developers
- Hyprland and its developers/contributors

---

## License

© 2025 xZepyx (Aditya Yadav) 
Licensed under MIT LICENSE.
