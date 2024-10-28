# Introduction

Setup NeoVim for daily use by organizing files in flexiable ways.


Here is the file structures:

```
.
├── README.md
├── init.lua
└── lua
    ├── core
    │   ├── fn.lua
    │   └── fs.lua
    ├── lazies                   -- specs and configurations for plugins managed by lazy.nvim
    │   ├── init.lua             -- install lazy.nvim
    │   ├── config               -- complex configurations for plugin in plugins folder 
    │   ├── languages            -- plugins setup for individual programming languages 
    │   │   ├── go.lua
    │   │   └── rust.lua
    │   └── plugins              -- plugin specs and simple configs
    │       ├── cmp.lua
    │       ├── colors.lua
    │       ├── lsp.lua          
    │       └── treesitter.lua
    ├── plugins                  -- home made plugins
    └── options.lua
```

# Add new programming language support
To support a new programming language.

1. Installing the language server for the programming language manually.

2. Create a configuration file in lua/lazies/languages to setup `treesitter`, `lspconfig`, etc. plugins.

# Complex configurations for plugin

If a plugin need no configuration or just simple configuration, it could be just put in the plugin spec in
`lazies/plugins` folder. If the configuration is complex, please create a dedicated file in `lazies.config` folder to
simplify plugin spec and make it more readable.

Example:

```
-- plugin spec
return {
  ...
  {
    "NvChad/nvim-colorizer.lua",
    ft = { "css", "html", "lua", "markdown", "scss", "text", "tmux", "toml", "txt", "vim", "yaml" },
    config = function()
      require("lazies.config.colorizer")
    end,
  },
  ...
}
-- lazies/config/colorizer.lua
local colorizer = require("colorizer")

colorizer.setup({
  filetypes = {
    "css", "html", "lua", "markdown", "scss", "text", "tmux", "toml", "txt", "vim", "yaml",
  },
  user_default_options = {
    tailwind = "both",
    names = false,
  },
})
```

# Add home made plugin

Sometimes you have to make a plugin by yourself or custom an existing plugin, since there no third-party plugin can satisfy your requirements directly.
Here is the way to do it.

1. Create a lua file or directory in `lua/plugins` folder for the plugin. Or clone the plugin your want to modify to
   here.

2. Add an plugin spec entry to for the home made plugin in `lua/lazies/plugins`.

Example:

```
local root = vim.fn.stdpath("config")
return {
  dir = root,                         -- use ~/.config/nvim folder as the runtimepath for home made plugins
  main = "modname",                   -- module name for the plugin, usually the file name or directory name.
  dependencies = {
	 "neovim/nvim-lspconfig",
  },
  opts = {},
  --config = function(opts)
  --  vim.print("plugins languages golang")
  --end,
  ft = {"go", 'gomod'},
}
```

