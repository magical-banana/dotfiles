# 🪟 Tmux (Terminal Multiplexer) Module

A modern, ergonomic Tmux setup designed for **persistent sessions** and **complex window layouts**. This configuration replaces the clunky default `Ctrl+b` with the more accessible `Ctrl+a` and enables full mouse support.



---

## 🎹 The Basics (Prefix: `Ctrl + a`)
To trigger any command, press `Ctrl + a` first, then the key listed below.

| Key | Action | Description |
| :--- | :--- | :--- |
| `|` | **Vertical Split** | Splits the current pane side-by-side. |
| `-` | **Horizontal Split** | Splits the current pane top-to-bottom. |
| `c` | **New Window** | Creates a new tab in the status bar. |
| `n / p`| **Next / Prev** | Cycle through your active windows (tabs). |
| `1-9` | **Switch Window**| Jump directly to a window by its index. |
| `z` | **Zoom** | Maximize the current pane (toggle back with `z`). |
| `d` | **Detach** | Leave the session running and return to your shell. |

---

## 🚀 Advanced Features

### 🖱️ Mouse Support
The mouse is fully enabled. You can:
* Click and drag pane borders to **resize** them.
* Click on different panes to **switch focus**.
* Use the scroll wheel to browse through command history/logs.

### 🔄 Persistence (Anti-Crash)
Powered by `tmux-resurrect` and `tmux-continuum`:
* **Auto-Save:** Your session layout and environment are saved every 15 minutes.
* **Manual Save:** `Prefix + Ctrl + s` 
* **Manual Restore:** `Prefix + Ctrl + r` (Use this after a system reboot to bring back all your windows and panes).

### 📂 Smart Paths
When you split a pane (`|` or `-`), the new pane automatically opens in the **same directory** as the current one. This is perfect for DevOps workflows where you need a side-pane for logs or a shell in the same project root.

---

## 🎨 Aesthetic & UI
* **Colors:** Uses a customized Gruvbox-inspired theme (Blue/Grey).
* **Indexing:** Windows start at **1** (instead of 0) to align with your keyboard's number row.
* **Renumbering:** If you close Window #2, Window #3 automatically becomes #2, keeping your tabs organized.
* **History:** Increased to **100,000 lines**. Feel free to run verbose `terraform` or `kubectl` logs without losing the output.

---

## 🔌 Plugin Management (TPM)
This module uses **TPM (Tmux Plugin Manager)**. 

**To install new plugins:**
1. Open Tmux.
2. Press `Prefix + I` (Capital I).

**Included Plugins:**
* `tpm`: The manager.
* `tmux-sensible`: Standard settings everyone agrees on.
* `tmux-resurrect`: Restore sessions after reboot.
* `tmux-continuum`: Continuous saving of tmux environment.

---

## 🔧 Maintenance
To update your plugins to the latest version:
Press `Prefix + U`.