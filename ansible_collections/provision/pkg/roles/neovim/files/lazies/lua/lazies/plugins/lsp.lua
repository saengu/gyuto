return {
    "neovim/nvim-lspconfig",
    config = function () 
      local lspconfig = require("lspconfig")
      local languages = require("core.fs").load_submods("lazies.languages")


		vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		--vim.diagnostic.config({
		--   float = { border = "rounded" },
		--})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set(
					"n",
					"<Leader>a",
					vim.lsp.buf.code_action,
					{ noremap = true, silent = true }
				)
			end,
		})

		for name, cfg in pairs(languages) do
		   local opts = {}
			if require("core.fn").iscallable(cfg.lspconfig.setup) then
			    cfg.lspconfig.setup(lspconfig, opts)
			end
		end
    end
 }
