# 🚀 Starship Module

The "Universal Dashboard" for your terminal. Starship provides a high-performance, minimalist prompt that surfaces the most important information based on the files in your current directory.



---

## 🛠 Features (Integrated with Mise & DevOps)

Starship detects your environment automatically and shows:
* **Mise Tools:** Displays the active version of **Go**, **Python**, or **Node** currently managed by Mise.
* **Kubernetes:** Shows your current `kubectl` context and namespace (Essential for not accidentally deleting pods in Production!).
* **Infrastructure:** Shows active **Terraform** workspaces and **AWS** profiles.
* **Git Intelligence:** Displays the branch name and a status indicator if you have uncommitted changes.

---

## 🎨 Visual Indicators

| Symbol | Meaning |
| :--- | :--- |
| `➜` (Green) | Last command succeeded. |
| `➜` (Red) | Last command failed (Check exit code!). |
| `` | Current Git Branch. |
| `☸️` | Active Kubernetes Context. |
| `🐹` | Active Go Version. |

---

## ⚙️ Configuration
The configuration is stored in `starship.toml`. It is designed to be:
1. **Context-Aware:** It only shows the Go icon if you are in a Go project.
2. **Safe:** It hides sensitive info unless it's relevant to the current task.

---

## 🔧 Maintenance & Customization
To live-edit your prompt and see changes immediately:
1. Edit `starship/starship.toml`.
2. The prompt will refresh automatically in the next terminal line.

**Note:** Ensure you have a **Nerd Font** installed (like JetBrainsMono Nerd Font) to see the icons correctly.