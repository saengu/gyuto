-- Deprecated
-- This file serves two purpose. The first one is as a normal lua module which is required in nvim/init.lua
-- to install lazy.nvim if not before. The other purpose is treated as a lua module to provides plugin spec,
-- as lazies directory is set as the folder to put plugin spec when lazy.nvim loaded. so this file will be
-- loaded twice, when neovim started to require lazy.nvim module and when lazy try to load plugin spec.
-- so here just return empty plugin spec to avoid require lazy.nvim again.
-- this is a little complicated to make file structure in lazies folder simple.
--local loaded = pcall(require, 'lazy')
--if loaded then
--  -- Return empty table to make lazy.nvim happy as we set lazies as import path,
--  -- so this file will be load as a lua module returning plugin spec 
--  return {}
--end

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
--require("lazy").setup("lazies.plugins")
require("lazy").setup({
  spec = {import = "lazies.plugins"},
  checker = { enabled = false },
})

