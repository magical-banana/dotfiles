# P10k instant prompt — must be at the very top, before any output.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Drop-in loader: every ~/.zshrc.d/*.zsh is sourced in lexical order.
# Files are numbered by stage (00-path → 99-p10k); add machine-local
# overrides as ~/.zshrc.d/zz-local.zsh (gitignored, sources last).
if [[ -d "$HOME/.zshrc.d" ]]; then
    for _zrc in "$HOME"/.zshrc.d/*.zsh(N); do
        source "$_zrc"
    done
    unset _zrc
fi
# Note: ~/.p10k.zsh is sourced by ~/.zshrc.d/99-p10k.zsh — don't add a
# duplicate source line here. `p10k configure` may try to append one;
# delete it if it does.
