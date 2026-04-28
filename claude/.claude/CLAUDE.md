# Global agent guidance

This file is loaded by Claude Code on every session, regardless of project.
Per-project overrides go in each repo's own `CLAUDE.md`. Keep this file
short and durable — anything project-specific belongs elsewhere.

## Working style

- Default to concise, scannable output. Lead with the answer; keep
  preamble to a sentence at most.
- Cite file paths with `path:line` so they're clickable in the terminal.
- When making non-trivial changes, parallelize tool calls where the work
  is independent. Don't serialize unnecessarily.
- Prefer editing existing files over creating new ones.

## Environment

- Shell is zsh, configured via `~/.zshrc.d/*.zsh` drop-ins (sourced
  in lexical order). When suggesting shell-config changes, target a
  drop-in file, not `~/.zshrc` itself.
- Runtime versions are pinned via `mise` — don't suggest installing
  Node/Go/Python via apt or brew.
- **mise binaries are on PATH** via `~/.zshenv` (which exposes
  `~/.local/share/mise/shims/`). Tools like `bat`, `fd`, `delta`, `gh`,
  `lazygit`, `zoxide`, `atuin`, `eza`, `xh`, `just`, `yq`, `jq`, `kubectl`,
  `terraform`, `helm` are all directly callable — DO NOT prefix with
  `mise exec --` or `mise which`. If `command -v <tool>` returns empty
  in a session, the snapshot is stale; tell the user to restart the
  session rather than working around it.
- Secrets live at `~/.config/secrets/env` (mode 0600), sourced by
  `~/.zshrc.d/60-secrets.zsh`. Never echo or commit values from there.

## Tool preferences

- Search (text): `rg` (ripgrep), `fd` (fd-find). Avoid raw `find`/`grep`
  unless there's a specific reason.
- Search (code structure): `sg` (ast-grep) for AST-aware patterns —
  e.g., "find every function that returns a Promise<User>" rather than
  regex-matching the literal string. Use this for refactoring queries.
- Diff review: `difft` (difftastic) produces structural diffs that
  ignore brace/whitespace noise. For git: `GIT_EXTERNAL_DIFF=difft git log -p`.
- Pager / viewer: `bat` for rich output, `cat` for piping.
- Benchmarking: `hyperfine` when comparing command performance — never
  hand-roll `time` loops for that.
- Watching: `watchexec -- <cmd>` instead of bespoke `make watch` recipes.
- Disk: `dust` (tree visualization) over `du -sh`.
- System: `btop` over `top` / `htop` when humans are watching.
- Git: prefer the existing aliases (`git st`, `git ll`, etc.) — see
  `~/.gitconfig`. Use `gh` for anything involving GitHub.
- JSON / YAML: `jq` and `yq`. Don't write multi-line awk for these.
- HTTP debugging: `xh` (httpie-style, faster). `curl` for raw control.

## Commit & PR style

- Commit subject in conventional-commit style (`feat:`, `fix:`, `chore:`).
- Lowercase after the colon. Describe the *why* in the body if non-obvious.
- Don't push or open PRs without explicit approval.
