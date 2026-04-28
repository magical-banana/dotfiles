# claude — Claude Code global config

Tracks `~/.claude/CLAUDE.md` (global agent instructions) and
`~/.claude/settings.json` (permissions + env).

## Layout

```
claude/
└── .claude/
    ├── CLAUDE.md       → ~/.claude/CLAUDE.md
    └── settings.json   → ~/.claude/settings.json
```

## What's here vs. what's not

- `CLAUDE.md` holds **global** agent guidance — working style, tool
  preferences, environment notes. Per-project guidance lives in each
  repo's own root-level `CLAUDE.md`.
- `settings.json` holds the conservative default permission set: read-only
  inspection (`ls`, `cat`, `rg`, `git status`, `gh pr view`, …) is
  allow-listed; mutating ops (`git push`, `rm -rf`, `gh pr create`) are
  on the `ask` list so the agent must confirm.

## Not tracked here

- `~/.claude/projects/` — per-conversation state. Ephemeral.
- `~/.claude/memory/` (per-project) — auto-managed by the agent.
- `~/.claude/keybindings.json` — terminal keybind tweaks. Add later if
  needed.
- MCP server configs — typically per-machine; add a separate file under
  `~/.claude.d/` if you want them tracked.

## Conflict handling

`bootstrap.sh` backs up any pre-existing `~/.claude/CLAUDE.md` or
`~/.claude/settings.json` to `/tmp/dotfiles_stow_backup_<ts>/claude/`
before stowing, so a fresh setup never silently overwrites your work.
