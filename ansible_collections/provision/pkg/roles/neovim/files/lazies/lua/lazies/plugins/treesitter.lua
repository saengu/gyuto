return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")
      --local fs = require("core.fs")
		--local languages = fs.load_submods("lazies.languages")
      local languages = require("core.fs").load_submods("lazies.languages")
		--vim.print(languages)
      --configs.setup({
      --  ensure_installed = { "c", "go", "lua", "javascript", "html" },
      --  sync_install = false,
      --  highlight = { enable = true },
      --  indent = { enable = true },  
      --})
		local opts = {
        ensure_installed = { "c", "lua", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },  
		}
	   --go.treesitter.setup(configs, opts)
		for name, cfg in pairs(languages) do
         --vim.print(cfg.treesitter.setup)
			--cfg.treesitter.setup(configs, opts)
		end

		configs.setup(opts)
    end
 }
