<div align="center">

# ✦ aelyx-shell ✦

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

#### A shell built to get things done.

Key goals:
- Minimal, script-centric configuration
- Easy to review and selectively apply
- Composable modules for prompts, completions, and UI widgets

---

<div align="center">
  
## ✦ Previews ✦

</div>

<div align="center">

| Top Bar                                         | Bottom Bar                                           |
|--------------------------------------------------|----------------------------------------------------|
| ![TopBar](/previews/1.png)                       | ![BottomBar](/previews/2.png)                        |
| **Left Bar**                                         | **Right Bar**                                           |
| ![LeftBar](/previews/3.png)                       | ![RightBar](/previews/4.png)                        |

</div>

---

<div align="center">
  
## ✦ Repository layout ✦

</div>

- /dots/           — Primary shell dotfiles (core modules)
- /dots-extra/     — Optional dotfiles, themes, and wallpapers
- /license/        — License and contributing docs
- /previews/       — Example screenshots used in this README
- /setup/          — Installer scripts and bootstrap utilities
- /.github/        — README and other stuff

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
    - Review files in `system/` if needed.

3. Run the installer:
    ```bash
    cd install && bash unified.sh
    ```
    - The installer will guide you through dependency checks and optional modules.
    - The script will either let to install the complete dotfiles or only the shell itself.

4. Open a fresh shell session or source your shell profile to apply changes.

Notes:
- Manual installation (symlinking files yourself) is supported and recommended for cautious users.
- Back up your existing dotfiles (e.g. ~/.config/ ~/.bashrc, ~/.zshrc, ~/.profile) before running the bootstrap.
- Other files under the install directory: `pkg.sh`, `update.sh` and `files.sh` read `install/README.md`.

---

<div align="center">
  
## ✦ Configuration & customization ✦

</div>

- Primary config: `~/.local/share/aelyx/user/config.json`
- Modular settings: prompt, completion, and widget modules are separated for easy replacement.
- To customize:
  - Edit the primary config or use the provided settings app (if installed).
  - Enable/disable modules by editing the module list in the `~/.config/quickshell/ae-qs/shell.qml` file.

---

<div align="center">
  
## ✦ Recommended environment ✦

</div>

- Compositor: Hyprland
- Terminal: Kitty
- Fonts: JetBrainsMono

---

<div align="center">
  
## ✦ Troubleshooting ✦

</div>

- Missing/Unloaded Modules:
  - Ensure the module file is loaded in the correct order. Check `~/.config/quickshell/shell.qml`.
- Broken visuals:
  - Check `~/.local/share/aelyx/user/config.json`
- Slow startup:
  - Disable unused modules or lazy-load heavy features (e.g., prompt segments that query network/state).
- Conflicting user configs:
  - Inspect existing profile files (`~/.bashrc`, `~.zshrc`, `~/.profile`, `~/.config`) before applying changes.
- Installer failures:
  - Re-run the installer with verbose output or check `install/` scripts for dependency checks.

---

<div align="center">
  
## ✦ To-Do ✦

</div>

- Redesign config layout and widget system for improved modularity and discoverability | Done
- Add more curated optional modules and theme variants
- Improve installer prompts and backup behavior | Done
- Improve shell performance (currently a big laggy on my machine)

---
<div align="center">
  
## ✦ Weird Tentacles ✦
<a href="https://www.star-history.com/#xzepyx/aelyx-shell&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=xzepyx/aelyx-shell&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=xzepyx/aelyx-shell&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=xzepyx/aelyx-shell&type=date&legend=top-left" />
 </picture>
</a>
</div>


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
  
## ✦ Inspiration/Copying ✦

</div>

#### I did copy some code from other repositories and took design inspirations which are listed here:
* [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (Copied some services, took some design inspirations)
* [etherealboi/twinshell](https://github.com/etherealboi/twinshell) (Some widgets)
* [bgibson72/yahr-quickshell](https://github.com/bgibson72/yahr-quickshell) (A script that lists installed apps)
* [caelestia-dots/shell](https://github.com/caelestia-dots/shell) (No code but almost copied the vertical bar design)
* [corecathx/whisker](https://github.com/corecathx/whisker) (Almost copied the settings app from his shell)

---

<div align="center">
  
## ✦ License ✦

</div>

© 2025 xZepyx (Aditya Yadav) — Licensed under the MIT License. See `license/` for details.

---
