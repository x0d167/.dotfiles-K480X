# 🔧 dotfiles-K480X

Custom dotfiles for my Arch-based ThinkPad T480 system — codename: **KRS-K480X**.  
This setup is tuned for speed, clarity, customization, and eventual world domination.

---

## 🗂️ Structure

```plaintext
dotfiles-K480X/
├── bash/               → .bashrc and shell configs
├── config/             → .config/*
│   ├── hypr/           → Hyprland WM config
│   ├── waybar/         → Status bar config and scripts
│   ├── rofi/           → Launcher theming
│   ├── swaync/         → Notifications config
│   ├── K480X/          → Machine-specific scripts and settings
│   ├── nvim/           → Minimal Neovim setup
│   └── ...             → Other environment components
````

Everything is managed using **GNU Stow** to cleanly symlink into `~`.

---

## 🧪 Notes

* System is Arch Linux (btw) + Hyprland + Wayland native
* ThinkPad T480 with upgraded RAM/SSD
* Designed to be fast, keyboard-driven, and portable across devices

---

## 📦 Managed Tools

* `Hyprland` – Wayland window manager
* `Waybar` – Status bar
* `Rofi` – Application launcher
* `Swaync` – Notifications
* `Kitty` – Terminal
* `Neovim` – Editor
* `Matugen` – Dynamic theming
* `Fastfetch` – Eye candy
* `Atuin` – Shell history, synced and encrypted
* `etc` – Work in progress

---

## 🧠 Philosophy

* **Minimalist**, but not spartan
* **Custom**, but maintainable
* **Scripted**, not brittle
* Everything should feel like it belongs in a cyberdeck

---

## 📎 Misc

This repo is not intended to be portable. It's personal, unapologetically tuned, and not beginner-oriented.
If you're looking to fork, do it with caution and taste.

---

## 🐾 Future Plans

* [ ] Create modular system bootstrap
* [ ] Harden machine security defaults
* [ ] Build out Hyprland theme packs
* [ ] Dotfile profile switcher (for multi-host use)

---

🛠️ Built by hand, for **K480X**
