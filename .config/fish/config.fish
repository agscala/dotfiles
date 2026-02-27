alias vim 'nvim'
alias vi 'nvim'
alias vault 'aws-vault exec zapier --'

set -Ux EDITOR nvim

source ~/.config/fish/api-keys.fish

set PATH ~/.node_modules/bin $PATH
set PATH ~/.yarn/bin $PATH
set PATH ~/bin $PATH
set PATH /Users/agscala/.meteor $PATH
set PATH /Users/agscala/.local/bin $PATH

set -x LDFLAGS "-L/usr/local/opt/zlib/lib"
set -x CPPFLAGS "-I/usr/local/opt/zlib/include"

# load_nvm

fish_add_path /usr/local/opt/sphinx-doc/bin

# npm token
function __refresh_npm_token
    if test -f ~/.npmrc
        set -gx NPM_TOKEN (string match -r '_authToken=(.+)' < ~/.npmrc | tail -n1)
    end
end

function npm --wraps npm
    if test "$argv[1]" = "login"
        command npm $argv
        and __refresh_npm_token
        and echo "NPM_TOKEN updated in current shell"
    else
        command npm $argv
    end
end

__refresh_npm_token

# pnpm
set -gx PNPM_HOME "/Users/agscala/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
#

direnv hook fish | source



set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /Users/agscala/.ghcup/bin $PATH # ghcup-env

# zoxide init fish | source

# opencode
fish_add_path /Users/agscala/.opencode/bin
export PATH="$HOME/.zdocs/bin:$PATH"
