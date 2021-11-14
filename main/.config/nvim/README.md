# Nvim

This is the most involved part of my configuration. Here are a few highlights.

TODO:
- setup-session
- telescope
- window title

## Clipboard

Clipboard workflow is inspired by [vim-cutlass](https://github.com/svermeulen/vim-cutlass). `d` and `c` do not write to clipboard, while `x`, the cut operator, do so. This is implemented by remapping of relevant keys as done in Cutlass. This also makes it practical to sync clipboard with system clipboard (`vim.o.clipboard = 'unnamedplus'`). Finally, [nvim-hclipboard](https://github.com/kevinhwang91/nvim-hclipboard) with some custom configuration prevents clipboard from being written when pasting over visual selection or typing in selection mode (snippet completion). I have also written some compatibility functions to use this workflow with [AckslD/nvim-anywise-reg.lua](https://github.com/AckslD/nvim-anywise-reg.lua), although I am not currently using it.

## File templates

I made a little hack around luasnip. I declare snippets in a pseudo language called `TEMPLATES`, where the trigger is a glob expression (here). Then, when a new file is created (either a BufNewFile autocommand or a nvim-tree event), template with the most specific match is expanded (here) and (here). You then benefit of all luasnip possibilities without the need for new mappings, yet it still triggers on file creation.

## Utilities

- `lua/wrap_win.lua` creates simple commands to wrap window navigation (that is, going left of leftmost windows brings to rightmost window, etc.)
- `lua/browser.lua` group utilities to search stuff in browser based on current word or selection
- `lua/alt-jump.lua` is a very simple script using marks to work around two alternative (and evolving) focus points
- `lua/theme-exprter.lua` exports colors from active colorschemes that are used elsewhere to produce system-wide theming

## Pager

I have a minimal configuration to use as a pager. Which configuration is launched is determined by `lua/pager.lua` according to environment variables. This is still much of a work in progress. It also can launch 'subnut/nvim-ghost.nvim' upon request. (Default behaviour creates a server for every nvim instance, while a most one running instance can be useful.)

