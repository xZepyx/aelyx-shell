<div align="center">

# ✦ Aelyx Shell ✦

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

<div align="center">
  
## ✦ Overview ✦

</div>

aelyx-shell a quickshell configuration built for clarity, speed, and a smooth, cohesive hyprland experience.

Key goals:
- Minimal, script-centric configuration
- Easy to review and selectively apply
- Composable modules for prompts, completions, and UI widgets

---

<div align="center">
  
## ✦ Previews ✦

</div>

<div align="center">

| Desktop                                          | Launcher                                           |
|--------------------------------------------------|----------------------------------------------------|
| ![Widgets](/previews/1.png)                       | ![Launcher](/previews/2.png)                        |

</div>

---

<div align="center">
  
## ✦ Repository layout ✦

</div>

- /dots/           — Primary shell dotfiles (core modules)
- /dots-extra/     — Optional dotfiles, themes, and wallpapers
- /license/        — License and contributing docs
- /previews/       — Example screenshots used in this README
- setup/           — Installer scripts and bootstrap utilities
- bootstrap.sh     — High-level dependency installer

---

<div align="center">
  
## ✦ Installation (automatic recommended) ✦

</div>

Follow these steps to install the collection. The automated setup is conservative and will prompt before making destructive changes.

1. Clone the repository:
    ```bash
    git clone https://github.com/xZepyx/aelyx-shell.git ~/.aelyx-shell
    cd ~/.aelyx-shell
    ```

2. Inspect configuration and optional modules:
    - Review files in `dots/` and `dots-extra/` before applying anything to your profile.

3. Run the installer:
    ```bash
    cd setup && bash install.sh
    ```
    - The installer will guide you through dependency checks and optional modules.

4. Open a fresh shell session or source your shell profile to apply changes.

Notes:
- Manual installation (symlinking files yourself) is supported and recommended for cautious users.
- Back up your existing dotfiles (e.g. ~/.bashrc, ~/.zshrc, ~/.profile) before running the bootstrap.

---

<div align="center">
  
## ✦ Configuration & customization ✦

</div>

- Primary config: `~/.config/aelyxshell/config.json`
- Modular settings: prompt, completion, and widget modules are separated for easy replacement.
- To customize:
  - Edit `~/.config/aelyxshell/config.json` or use the provided settings app (if installed).
  - Enable/disable modules by editing the module list in the appropriate config file.

---

<div align="center">
  
## ✦ Recommended environment ✦

</div>

- Shell: QuickShell-compatible environment (see QuickShell docs)
- Compositor: Hyprland is recommended but not required
- Terminal: Kitty or another modern terminal emulator
- Fonts: A patched monospace font with ligatures for best prompt rendering
- Git: recommended for keeping dotfiles updated and synced

---

<div align="center">
  
## ✦ Troubleshooting ✦

</div>

- Missing alias or function:
  - Ensure the module file is loaded in the correct order. Check `~/.config/quickshell/shell.qml`.
- Slow startup:
  - Disable unused modules or lazy-load heavy features (e.g., prompt segments that query network/state).
- Conflicting user configs:
  - Inspect existing profile files (`~/.bashrc`, `~.zshrc`, `~/.profile`) before applying changes.
- Installer failures:
  - Re-run the installer with verbose output or check `setup/` scripts for dependency checks.

---

<div align="center">
  
## ✦ To-Do ✦

</div>

- Redesign config layout and widget system for improved modularity and discoverability
- Add more curated optional modules and theme variants
- Improve installer prompts and backup behavior

---

<div align="center">
  
## ✦ Contributing ✦

</div>

Contributions are welcome. When contributing:
- Open concise issues after confirming the problem isn't caused by local configuration.
- Submit focused PRs with clear descriptions and tests where applicable.
- Follow code structure and naming conventions used in `dots/`.

See `license/CONTRIBUTING.md` for full contribution guidelines.

---

<div align="center">
  
## ✦ Maintainer ✦

</div>

- Maintainer: xZepyx (Aditya Yadav)  
- Contact: [zepyxunderscore@gmail.com](mailto:zepyxunderscore@gmail.com)

---

<div align="center">
  
## ✦ Acknowledgments ✦

</div>

- QuickShell and its contributors
- Hyprland and its developers/contributors

---

<div align="center">
  
## ✦ License ✦

</div>

© 2025 xZepyx (Aditya Yadav) — Licensed under the MIT License. See `license/` for details.

---
