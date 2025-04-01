if status is-interactive


    bind \cz 'fg 2>/dev/null; commandline -f repaint'
    set -gx EDITOR /opt/homebrew/bin/nvim

    set -gx PATH /opt/homebrew/bin/ $PATH

    set -gx PATH /usr/local/bin/ $PATH
    set -gx PATH ~/go/bin/ $PATH
    set -gx PATH ~/bin/ $PATH
    set -gx PATH ~/.bun/bin/ $PATH
    set -gx MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
    source ~/.config/fish/aliases.fish
end
