local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add('hrsh7th/nvim-cmp')
  add('hrsh7th/cmp-nvim-lsp')
  add('hrsh7th/cmp-buffer')
  add('hrsh7th/cmp-path')
  add('hrsh7th/cmp-cmdline')

  -- Use NeoVim native snippet engine
  local cmp = require('cmp')
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          -- cmp.select_next_item()  -- This will insert the current candidate to buffer
          -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })  -- ONLY choose next candidate without update buffer

          if #cmp.get_entries() == 1 then
            -- Trigger an 'Enter'('<CR>') key event to expand snippet. Use 'm' to allow remap '<CR>', otherwise insert newline.
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'm', true)
          else
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })  -- ONLY choose next candidate without update buffer
          end
        elseif vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })  -- ONLY choose next candidate without update buffer
        elseif vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    })
  })
end)
