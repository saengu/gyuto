local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add('folke/tokyonight.nvim')
  add('sainnhe/gruvbox-material')
  add({ source = 'catppuccin/nvim', name = 'catppuccin-nvim' })
--   add('rebelot/kanagawa.nvim')
--   add('sainnhe/everforest')
--   add({ source = 'rose-pine/neovim', name = 'rose-pine' })
--   add('bluz71/vim-moonfly-colors')
  add('ellisonleao/gruvbox.nvim')
--   add('craftzdog/solarized-osaka.nvim')
--   add('navarasu/onedark.nvim')
--   add('projekt0n/github-nvim-theme')
--   add('marko-cerovac/material.nvim')
--   require('material').setup({ plugins = { 'mini' } })
--   add('EdenEast/nightfox.nvim')
--   add('scottmckendry/cyberdream.nvim')
--   add('Shatur/neovim-ayu')

--   Set color scheme
--   vim.cmd('colorscheme catppuccin')
end)
