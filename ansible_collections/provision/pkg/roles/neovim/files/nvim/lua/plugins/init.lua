local icons = require("core.icons")

-- Load plugins without complex configurations
return {
  -- Press `jk` to work as `Escape`
  { "max397574/better-escape.nvim", opts = { mapping = {'jk'} } },

  -- Beautify diagnostics
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        icons = false,
        signs = {
          -- icons / text used for a diagnostic
          error = icons.diagnostics.Error,
        }
      })
    end
  },
}
