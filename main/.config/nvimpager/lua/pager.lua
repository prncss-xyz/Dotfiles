local function replace_prefix(table, old_prefix, new_prefix)
  -- Escape all punctuation chars to protect from lua pattern chars.
  old_prefix = old_prefix:gsub('[^%w]', '%%%0')
  for index, value in ipairs(table) do
    table[index] = value:gsub('^' .. old_prefix, new_prefix, 1)
  end
  return table
end

local nvim = vim.api
  local runtimepath = nvim.nvim_list_runtime_paths()
  -- Remove the custom nvimpager entry that was added on the command line.
  -- runtimepath[#runtimepath] = nil
  local new
  for _, name in ipairs({"config", "data"}) do
    local original = nvim.nvim_call_function("stdpath", {name})
    new = original .."pager"
    runtimepath = replace_prefix(runtimepath, original, new)
  end
  runtimepath = table.concat(runtimepath, ",")
  nvim.nvim_set_option("packpath", runtimepath)
  -- runtimepath = os.getenv("RUNTIME") .. "," .. runtimepath
  nvim.nvim_set_option("runtimepath", runtimepath)
  new = new .. '/rplugin.vim'
  nvim.nvim_command("let $NVIM_RPLUGIN_MANIFEST = '" .. new .. "'")

-- require'impatient'.enable_profile()

local disabled_built_ins = {
  '2html_plugin',
  'filetypes', -- nathom/filetype.nvim
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'matchit',
  'netrw',
  'netrwFileHandlers',
  'netrwPlugin',
  'netrwSettings',
  'rrhelper',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end


require 'options'
require 'bindings'
require('nvim-treesitter.configs').setup{
  highlight = {
    enable = true,
  }
}

require('filetype').setup {
  overrides = {
    extensions = {
      -- sh = 'sh',
    },
    literal = {
      BufRead = 'json',
      BufNewFile = 'json',
      ['.eslintrc'] = 'json',
      ['.stylelintrc'] = 'json',
      ['.htmlhintrc'] = 'json',
    },
    complex = {
      ['.config/sway/config.d/*'] = 'sway',
      ['.config/kitty/*'] = 'kitty',
    },
  },
}
