-- This is stuff we're trying to figure out
-- won't be sourced unless env NVIM_EXPERIMENTS is set to 'true'
-- can also be sourced manually

local function conceal()
  vim.cmd [[
    set syntax=on
    syntax match True "true" conceal cchar=⊤
    syntax match False "false" conceal cchar=⊥
  ]]
end

-- trying to figure it out
vim.api.nvim_create_user_command('Conceal', conceal, { nargs = 0 })

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*.lua',
  callback = conceal,
})

local test = true

-- true
