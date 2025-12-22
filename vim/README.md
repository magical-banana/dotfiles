# ✍️ Vim DevOps Module

A professional, plugin-enhanced Vim environment optimized for **Cloud-Native Development**, **Infrastructure as Code (IaC)**, and **Go** scripting. 

This module transforms standard Vim into a lightweight IDE using `vim-plug`, featuring deep integration with terminal tools like `fzf` and modern DevOps languages.



---

## 🎹 Essential Keybindings
The **Leader Key** is mapped to `Space` (the most ergonomic choice for high-speed editing).

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<Space> w` | **Fast Save** | Saves the current buffer instantly. |
| `<Space> l` | **Clear Search** | Clears the persistent highlights after a search (`:noh`). |
| `Ctrl + h` | **Move Left** | Navigate to the left split pane. |
| `Ctrl + j` | **Move Down** | Navigate to the bottom split pane. |
| `Ctrl + k` | **Move Up** | Navigate to the top split pane. |
| `Ctrl + l` | **Move Right** | Navigate to the right split pane. |
| `gc` | **Comment** | Comments out a line or a visual selection (via `commentary`). |
| `jj` | **Escape** | (Optional/Common) Fast exit from Insert mode. |

<!-- --- -->

## 🛠 Cloud-Native & DevOps Optimization

### 📏 Indentation & Syntax Safety
YAML and Terraform are whitespace-sensitive. This configuration ensures you never break a manifest:
* **2-Space Indent:** Default for `YAML` and `Terraform` files.
* **4-Space Indent:** Default for `Python`.
* **Visual Whitespace:** `set list` is enabled. 
    * Tabs appear as `▸`.
    * Trailing whitespaces appear as `·`.
* **Auto-Formatting:** Includes `vim-terraform` and `vim-yaml` for proper alignment of blocks and keys.

### 🌳 Git Integration
Powered by `vim-gitgutter`, the "gutter" (column next to line numbers) shows real-time diffs:
* `+` : Line added.
* `~` : Line modified.
* `-` : Line removed.

### 🔍 Search & Discovery
* **Fuzzy Finding:** Hooks directly into the `fzf` binary installed via **Mise**. Use `:Files` to find files and `:Ag` or `:Rg` to search text across the project.
* **Smart Search:** Case-insensitive search unless you use a capital letter (`smartcase`).
* **Clipboard:** Integrated with system clipboard (`unnamedplus`). You can `y` (yank) in Vim and paste directly into your browser or terminal.

---

## 📦 Plugin Architecture
Managed by `vim-plug`. The setup includes:

| Category | Plugins |
| :--- | :--- |
| **Core** | `vim-plug`, `vim-sensible` |
| **UI** | `lightline.vim` (Wombat theme), `vim-gitgutter` |
| **Workflow** | `fzf.vim`, `vim-commentary` |
| **Languages** | `vim-go`, `vim-terraform`, `vim-yaml` |

---

## ⚙️ Management & Maintenance

**To install or update plugins:**   
After adding a new `Plug` entry to your `.vimrc`, run:   
```vim
:PlugInstall
```

**To update all plugins to their latest versions:**
```vim
:PlugUpdate
```

**Check Health: The setup uses termguicolors. If colors look strange, ensure your terminal emulator (like Kitty, WezTerm, or Ghostty) supports true color.**
