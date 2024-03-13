# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

# Add language configuration

1. Create a configuration file in `lua/plugins/extras/lang/`.
2. Import configuration file in `spec` section of `lua/config/lazy.lua` like 
```
```lua
spec = {
...
{ import = "plugins.extras.lang.go" },
...
```

Refer: https://www.reddit.com/r/neovim/comments/11wjonj/how_to_make_fluttertools_work_on_lazyvim/ 

