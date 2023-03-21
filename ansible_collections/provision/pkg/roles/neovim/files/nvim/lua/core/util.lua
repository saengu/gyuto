-- This module provides functions frequently used and not properly to
-- put in other modules. Functions in this module should not rely on
-- any other modules otherwise will encounter circular reference.

local M = {}


-- Set highlight colors
-- Since Terminal.app on MacOS only supports 256 colors, which is not the 24-bit color that truecolors uses,
-- characters will look dim, please set both bg/fg and ctermbg/ctermfg colors
function M.highlight(name, options)
  if options.default ~= false then
    options.default = true
  end
  -- For NeoVim >= 0.9
  vim.api.nvim_set_hl(0, name, options)
end


-- Require module without execption
-- @param m string: module name to load
-- @return module, error string
function M.prequire(m)
  local ok, val = pcall(require, m) 
  if ok then
    return val, nil -- module
  else
    return nil, val -- error message
  end
end


return M
