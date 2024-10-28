local M = require("core.fn").make_safetable()

---@param plugin module Plugin to config
---@param opts   table  Options passed to setup function of plugin
function M.treesitter.setup(plugin, opts)
  vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
end

---@param plugin module Plugin to config
---@param opts   table  Options passed to setup function of plugin
function M.lspconfig.setup(plugin, opts)
  plugin.gopls.setup({})
end

return M
