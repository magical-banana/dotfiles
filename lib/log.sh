#!/usr/bin/env bash
# Colored logging helpers. Source this file from other scripts.
# All functions write to stderr so they don't pollute stdout pipelines.

# Detect color support — disable when stderr isn't a TTY or NO_COLOR is set
if [[ -t 2 && -z "${NO_COLOR:-}" ]]; then
    readonly _C_RESET=$'\033[0m'
    readonly _C_BOLD=$'\033[1m'
    readonly _C_DIM=$'\033[2m'
    readonly _C_RED=$'\033[31m'
    readonly _C_GREEN=$'\033[32m'
    readonly _C_YELLOW=$'\033[33m'
    readonly _C_BLUE=$'\033[34m'
    readonly _C_MAGENTA=$'\033[35m'
    readonly _C_CYAN=$'\033[36m'
else
    readonly _C_RESET="" _C_BOLD="" _C_DIM=""
    readonly _C_RED="" _C_GREEN="" _C_YELLOW=""
    readonly _C_BLUE="" _C_MAGENTA="" _C_CYAN=""
fi

log_header()  { printf '\n%s%s━━━ %s ━━━%s\n\n' "$_C_BOLD" "$_C_MAGENTA" "$*" "$_C_RESET" >&2; }
log_step()    { printf '%s▸%s %s\n'         "$_C_BOLD$_C_BLUE" "$_C_RESET" "$*" >&2; }
log_info()    { printf '%sℹ%s  %s\n'         "$_C_CYAN" "$_C_RESET" "$*" >&2; }
log_success() { printf '%s✓%s  %s\n'         "$_C_GREEN" "$_C_RESET" "$*" >&2; }
log_skip()    { printf '%s•%s  %s%s%s\n'     "$_C_DIM" "$_C_RESET" "$_C_DIM" "$*" "$_C_RESET" >&2; }
log_warn()    { printf '%s⚠%s  %s\n'         "$_C_YELLOW" "$_C_RESET" "$*" >&2; }
log_error()   { printf '%s✗%s  %s\n'         "$_C_RED" "$_C_RESET" "$*" >&2; }

# Indent piped output by 4 spaces — usage: some_command | indent
indent() { sed 's/^/    /'; }

die() { log_error "$*"; exit 1; }
