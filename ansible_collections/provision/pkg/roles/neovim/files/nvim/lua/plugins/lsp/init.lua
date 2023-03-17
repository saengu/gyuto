local util = require('core.util')


LspConfig = {
  "neovim/nvim-lspconfig",
  servers = { "clangd", "gopls", "pyright" },
}


-- Check whether options module file for specific language server exists or not
-- @param srv string: name of language server, like gopls, clangd
-- @return bool: true if options module file exists
local function options_exists(srv)
  -- Get absolute path of lua/plugins/lsp. debug.getinfo(1).source is the filepath of current script
  local plugin_dir = debug.getinfo(1).source:sub(2, -10) 
  local modfile = srv .. ".lua"

  return vim.fn.findfile(modfile, plugin_dir) ~= ''
end

-- Get language server installation commands from options file
function LspConfig:get_builds()
  builds = {}
  for _, srv in ipairs(self.servers) do
    -- Ignore module load error which will be notified when calling LspConfig.config()
    local opt, err = util.prequire("plugins.lsp." .. srv)
    if opt and opt.build then
      builds[#builds + 1] = opt.build
    end
  end

  return builds
end

-- Add lsp server install commands
-- Refer to: 
--   1. https://github.com/folke/lazy.nvim/blob/main/lua/lazy/manage/task/plugin.lua
--   2. https://github.com/talha-akram/anvil/blob/master/lua/plugins/init.lua
function LspConfig:new()
  -- Looks like lazy.nvim not respect __index key of lua table, merge table to bind config
  -- function to obj directly, otherwise lazy will not call config function.
  -- local obj = setmetatable({}, {__index = self})
  local obj = vim.tbl_deep_extend('keep', {}, self)

  -- TODO: use abstract pkg helper function to install package for different os
  -- Add installation commands of language servers to build key of lspconfig object
  obj.build = self:get_builds()

  return obj
end


-- According to spec of lazy.vim, plugin as self will be passed as first parameter
-- should use colon to define method
function LspConfig:config()
  local lsp = require("lspconfig")

  for _, srv in ipairs(self.servers) do
    -- Try to load language server options or use default options once fail

    -- opt returned by prequire is options table for lsp.setup()
    local opt, err = util.prequire("plugins.lsp." .. srv)

    -- Options for language server not exists or cannot load
    -- And try to use default options
    if err then
      -- Display module load error if options file do exists and fail to load
      if options_exists(srv) then
        vim.notify(
          "[ERROR] fail to load " .. modfile .. "\n" .. err,
          vim.log.levels.ERROR,
          { title = "lazy.nvim" }
        )
      end

      local Options = require("plugins.lsp.options")
      opt = Options:new()
    end

    lsp[srv].setup(opt)
  end
end

return LspConfig:new()
