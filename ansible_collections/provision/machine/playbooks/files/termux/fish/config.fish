if status is-interactive
    # Commands to run in interactive sessions can go here
end

for fn in $HOME/.config/fish/functions/*
    source $fn
end

if test -e $HOME/.config/fish/aliases.fish
  source $HOME/.config/fish/aliases.fish
end

if test -e $HOME/.config/fish/env.fish
  source $HOME/.config/fish/env.fish
end

# Setup starship prompt tool
if type -q starship
  starship init fish | source
end
