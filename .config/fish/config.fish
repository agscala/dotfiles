alias vim 'nvim'
alias vi 'nvim'
alias vault 'aws-vault exec zapier --'


source ~/.config/fish/api-keys.fish

set PATH ~/.node_modules/bin $PATH
set PATH ~/bin $PATH

set -x LDFLAGS "-L/usr/local/opt/zlib/lib"
set -x CPPFLAGS "-I/usr/local/opt/zlib/include"

# load_nvm


thefuck --alias | source
