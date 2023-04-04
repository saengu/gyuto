# Set Helper Environment Variables
set -gx EDITOR nvim

# Setup golang develop environment
if type -q go
    set -x GOPATH $HOME/.local/lib/go
    set -x PATH $PATH $GOPATH/bin
end
