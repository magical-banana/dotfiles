# 🌳 Git & Version Control Module

A professional Git configuration designed for a **Linear History** workflow. It features ergonomic aliases, enhanced logging, and safety defaults to prevent accidental pushes or "merge bubbles."

---

## 🛠 Identity & Local Config
This repository uses a **Local-First** identity pattern. This allows you to use the same dotfiles for Work and Personal machines without leaking your email to GitHub.

* **Requirement:** Create a `~/.gitconfig.local` file on your machine:
```ini
[user]
    name = Your Name
    email = your.email@example.com

```

---

## 🎹 Custom Aliases (The "Banana" Shortcuts)

### **Status & Staging**

| Alias | Command | Description |
| --- | --- | --- |
| `git st` | `status -sb` | Short, branch-aware status. |
| `git addall` | `!git add . && ...` | Stages everything and immediately shows status. |
| `git co` | `checkout` | Switch branches or restore files. |
| `git ci` | `commit` | Create a new commit. |

### **Logging & History**

| Alias | Command | Description |
| --- | --- | --- |
| `git ll` | **The Master Log** | A beautiful, color-coded, one-line graphical tree of all branches. |
| `git hist` | `log -p --decorate` | Detailed history showing actual code diffs per commit. |

### **Safety & Correction**

| Alias | Command | Description |
| --- | --- | --- |
| `git undo` | `reset HEAD^` | Un-commit the last change but **keep** your work staged. |
| `git amend` | `commit --amend` | Add changes to the last commit without changing the message. |

---

## 🚀 Professional Workflow Defaults

### 🔄 Linear History (Rebase)

`pull.rebase = true` is enabled. When you pull changes from a remote, Git will rebase your local commits on top of the remote ones instead of creating a "Merge branch 'main' of..." commit. This keeps the graph clean and easy to read.

### 🛡️ Push Safety

`push.default = current` is enabled. Git will only push the branch you are currently on to an upstream branch of the same name. This prevents accidentally pushing all local branches at once.

### 📝 Editor Integration

`core.editor` and `difftool` are set to **Vim**.

* When you run `git difftool`, it will launch `vim -d` to show a side-by-side comparison of changes.

### 🌈 Visuals

* **Default Branch:** Set to `main`.
* **Colors:** `ui = auto` enabled for high-contrast terminal feedback.

---

## 🔧 Maintenance

To see your full combined configuration (Global + Local):

```bash
git config --list --show-origin

```
