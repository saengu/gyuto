local M = require("core.fn").make_safetable()

---@param plugin module Plugin to config
---@param opts   table  Options for treesitter plugin. This opts table is shared by other languages treesitter.setup
---                     function, pay attention when making changes to it.
function M.treesitter.setup(plugin, opts)
  vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
end

---@param plugin module Plugin to config
---@param opts   table  Shared options from lazies.lsp
function M.lspconfig.setup(plugin, opts)
  plugin.gopls.setup({})
end

return M
