alias vim 'nvim'
alias vi 'nvim'
alias vault 'aws-vault exec zapier --'

set -Ux EDITOR nvim

source ~/.config/fish/api-keys.fish

set PATH ~/.node_modules/bin $PATH
set PATH ~/bin $PATH
set PATH /Users/agscala/.meteor $PATH
set PATH /Users/agscala/.local/bin $PATH

set -x LDFLAGS "-L/usr/local/opt/zlib/lib"
set -x CPPFLAGS "-I/usr/local/opt/zlib/include"

# load_nvm

fish_add_path /usr/local/opt/sphinx-doc/bin

# pnpm
set -gx PNPM_HOME "/Users/agscala/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
