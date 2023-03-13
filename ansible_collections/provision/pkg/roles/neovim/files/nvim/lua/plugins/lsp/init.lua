local util = require('util')


LspConfig = {
  "neovim/nvim-lspconfig",
  servers = { "clangd", "gopls" },
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

-- Add lsp server install commands
-- Refer to: 
--   1. https://github.com/folke/lazy.nvim/blob/main/lua/lazy/manage/task/plugin.lua
--   2. https://github.com/talha-akram/anvil/blob/master/lua/plugins/init.lua
function LspConfig:new()
  local obj = setmetatable({}, {__index = self})

  -- Add installation commands of language servers to build key of lspconfig object
  obj.build = {}
  for _, srv in ipairs(self.servers) do
    -- Ignore module load error which will be notified when calling LspConfig.config()
    local opt, err = util.prequire("plugins.lsp." .. srv)
    if opt and opt.build then
      obj.build[#obj.build + 1] = opt.build
    end
  end

  -- Bind config function directly to obj, otherwise lazy will not call config function
  -- And since lazy.core.loader.config will call plugin.config by passing plugin object as first
  -- parameter, so it is ok to define LazyConfig:config with colon and use self inside
  obj.config = self.config

  return obj
end


-- According to spec of lazy.vim, plugin/self will be passed as first parameter
-- should use colon to define method
function LspConfig:config()
  local lsp = require("lspconfig")

  for _, srv in ipairs(self.servers) do
    -- Try to load language server options or use default options once fail

    -- opt returned by prequire is options table for lsp.setup()
    local opt, err = util.prequire("plugins.lsp." .. srv)
    if not err then -- options for language server exists and loaded
      opt.on_attach = on_attach
    else
      -- Display module load error if options file exists
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
