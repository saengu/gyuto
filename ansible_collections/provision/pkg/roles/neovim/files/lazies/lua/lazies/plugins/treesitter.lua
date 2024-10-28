return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function() 
    local configs = require("nvim-treesitter.configs")
    local languages = require("core.fs").load_submods("lazies.languages")

    local opts = {
      ensure_installed = { "c", "lua", "javascript", "html" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    }

    for name, cfg in pairs(languages) do
      if require("core.fn").iscallable(cfg.treesitter.setup) then
        cfg.treesitter.setup(configs, opts)
      end
    end

    -- setup treesitter plugin
    configs.setup(opts)
  end
}
