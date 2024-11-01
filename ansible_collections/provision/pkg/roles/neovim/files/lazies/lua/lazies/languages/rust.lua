-- Need to install rust-analyzer manually to make lspconfig work for rust
--
-- run below commands to install rust and rust-analyzer
--     > rustup default stable
--     > rustup component add rust-analyzer


local M = require("core.fn").make_safetable() 

---@param plugin module Plugin to config
---@param opts   table  Options for treesitter plugin. This opts table is shared by other languages treesitter.setup
---                     function, pay attention when making changes to it.
function M.treesitter.setup(plugin, opts)
  vim.list_extend(opts.ensure_installed, { "rust", "toml" })
end

---@param plugin module Plugin config
---@param opts   table  Shared options from lazies.lsp
function M.lspconfig.setup(plugin, opts)
	plugin.rust_analyzer.setup(opts)
end

return M
