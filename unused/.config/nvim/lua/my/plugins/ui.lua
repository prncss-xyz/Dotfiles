-- indent-blankline
local ibl_highlight = {
  'CursorColumn',
  'Whitespace',
}

-- tabline framework
local function hl(name)
  local succ, res = pcall(require('my.utils').extract_nvim_hl, name)
  if succ then
    return res
  end
end

local render = function(f)
  local default = hl 'lualine_b_normal'
  local active = hl 'lualine_a_normal'
  local buffstory = require 'buffstory'
  if default then
    f.set_colors(default)
  end
  local function format_buf(info)
    if info.current and active then
      f.set_fg(active.fg)
      f.set_bg(active.bg)
    end
    f.add ' '
    f.add(f.icon(info.filename))
    f.add ' '

    local succ, title = pcall(vim.api.nvim_buf_get_var, info.buf, 'title')
    f.add(succ and title or info.filename)
    f.add ' '
  end
  f.make_bufs(format_buf, buffstory.display_list)
end

-- ufo
local ftMap = {
  vim = 'indent',
  markdown = 'treesitter', -- markdown folds handled by 'masukomi/vim-markdown-folding'
  NeogitCommitMessage = '',
}
local function handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ('  %d '):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2rd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, 'MoreMsg' })
  return newVirtText
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = false,
        globalstatus = true,
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            max_length = math.max(20, vim.o.columns - 20),
            mode = 1,
            path = 3,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        -- lualine_z = { 'overseer' },
        lualine_y = { require 'my.utils.uiline.overseer' },
        -- FIXME:
        lualine_z = { 'branch' },
      },
      winbar = {
        lualine_a = { require 'my.utils.uiline.file' },
      },
      inactive_winbar = {
        lualine_a = { require 'my.utils.uiline.file' },
      },
      sections = {
        lualine_a = { require 'my.utils.uiline.aerial' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = { require 'my.utils.uiline.coordinates' },
        lualine_y = {},
        lualine_z = {},
      },
    },
    dependencies = 'MunifTanjim/nui.nvim',
  },
  {
    'kyazdani42/nvim-web-devicons',
    opts = { default = true },
  },
  {
    's1n7ax/nvim-window-picker',
    opts = {
      selection_chars = require('my.config.binder.parameters').selection_chars:upper(),
      show_prompt = false,
      filter_rules = {
        include_current_win = true,
        bo = {
          filetype = {},
          buftype = {},
        },
      },
    },
  },
  -- git
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Gitsigns',
    opts = {
      watch_gitdir = {
        interval = 100,
      },
      sign_priority = 5,
      status_formatter = nil, -- Use default
      numhl = false,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      word_diff = false,
    },
  },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    opts = {
      disable_builtin_notifications = true,
      kind = 'split',
      integrations = {
        diffview = true,
      },
    },
    enabled = false,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    name = 'ibl',
    event = 'BufReadPost',
    opts = {
      indent = { highlight = ibl_highlight, char = ' ' },
      whitespace = {
        highlight = ibl_highlight,
      },
      exclude = {
        filetypes = { 'help', 'packer', 'markdown' },
        buftypes = { 'terminal', 'help', 'nofile' },
      },
    },
  },
  {
    'lukas-reineke/headlines.nvim',
    opts = {},
    ft = { 'markdown', 'orgmode', 'neorg' },
    enabled = false,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { 'markdown', 'Avante' },
    cmd = { 'RenderMarkdown' },
  },
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
  },
  {
    dir = require('my.utils').local_repo 'buffstory.nvim',
    event = 'BufEnter',
    opts = {},
  },
  {
    'rafcamlet/tabline-framework.nvim',
    -- requires vim.o.showtabline = 2 -- always show tabline
    opts = { render = render },
    event = 'VeryLazy',
    enabled = false,
  },
  {
    'stevearc/dressing.nvim',
    opts = {
      input = {
        prefer_width = 70,
      },
    },
    event = 'VeryLazy',
  },
  {
    'folke/trouble.nvim',
    opts = {
      position = 'left',
      width = require('my.parameters').pane_width,
      use_diagnostic_signs = true,
      action_keys = {
        close = {},
        refresh = 'r',
        jump = '<cr>',
        cancel = '<c-c>',
        open_split = '<c-x>',
        open_vsplit = '<c-v>',
        jump_close = 'o',
        toggle_fold = 'z',
        close_folds = {},
        switch_severity = {},
        hover = 'h',
        open_folds = {},
        toggle_mode = 'm', -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = 'l', -- toggle auto_preview
        preview = 'p', -- preview the diagnostic location
        next = require('my.config.binder.parameters').d.down,
        previous = require('my.config.binder.parameters').d.up,
      },
    },
    cmd = { 'Trouble', 'TroubleClose', 'TroubleToggle', 'TroubleRefresh' },
  },
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    opts = {
      keywords = {
        WAIT = { icon = '', color = 'warning' },
        TODO = {
          icon = ' ',
          color = 'info',
          alt = {
            'BUILD',
            'CI',
            'DOCS',
            'FEAT',
            'REFACT',
            'STYLE',
            'TEST',
            'QUESTION',
          },
        },
      },
    },
    cmd = {
      'TodoTrouble',
      'TodoTelescope',
    },
  },
  {
    'folke/zen-mode.nvim',
    cmd = { 'ZenMode' },
    opts = function()
      local current_line_blame
      return {
        window = {
          height = 1,
          width = 100,
        },
        plugins = {
          options = {
            ruler = true,
            showcmd = false,
          },
          gitsigns = { enabled = true },
          twilight = { enabled = false },
        },
        on_open = function()
          current_line_blame =
            require('gitsigns').toggle_current_line_blame(false)
          local Job = require('plenary').job
          Job:new({ command = 'wtype', args = { '-M', 'ctrl', '--', '+++++' } })
            :sync()
          --[[ Job:new({ command = 'swaymsg', args = { 'fullscreen', 'enable' } }) :sync() ]]
        end,
        on_close = function()
          require('gitsigns').toggle_current_line_blame(current_line_blame)
          local Job = require('plenary').job
          Job:new({ command = 'wtype', args = { '-M', 'ctrl', '--', '-----' } })
            :sync()
          --[[ Job:new({ command = 'swaymsg', args = { 'fullscreen', 'disable' } }) :sync() ]]
        end,
      }
    end,
  },
  {
    'rcarriga/nvim-notify',
    opts = {
      level = 1,
      stages = 'static',
      render = 'wrapped-compact',
      timeout = 3000,
    },
    config = function(_, opts)
      require('notify').setup(opts)
      vim.notify = require 'notify'
    end,
    event = 'VimEnter',
    enabled = false,
  },
  {
    'folke/noice.nvim',
    event = 'VimEnter',
    cmd = 'Noice',
    opts = {
      commands = {
        history = {
          view = 'popup',
        },
      },
      lsp = {
        progress = {
          -- ltex_ls gets really annoying otherwise
          throttle = 1000,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
  },
  {
    'folke/edgy.nvim',
    event = 'VeryLazy',
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = 'screen'
    end,
    opts = {
      options = {
        left = { size = 40 },
        right = { size = 60 },
      },
      left = {
        {
          title = 'Overseer',
          ft = 'OverseerList',
        },
        {
          title = 'Aerial',
          ft = 'aerial',
        },
        {
          title = 'Trouble',
          ft = 'trouble',
        },
        {
          title = 'Neo-Tree',
          ft = 'neo-tree',
        },
        {
          ft = 'Outline',
          open = 'SymbolsOutlineOpen',
        },
        -- any other neo-tree windows
        'neo-tree',
        {
          ft = 'codecompanion',
          title = 'Code Companion Chat',
        },
      },
      right = {
        {
          ft = 'grug-far',
          title = 'Grug Far',
        },
        {
          ft = 'mchat',
          title = 'Mchat',
        },
      },
    },
  },
  {
    'anuvyklack/windows.nvim',
    event = 'VeryLazy',
    dependencies = { 'anuvyklack/middleclass' },
    init = function()
      --[[ vim.o.winwidth = 100 ]]
      --[[ vim.o.winminwidth = 65 ]]
      --[[ vim.o.equalalways = false ]]
    end,
    opts = {},
    cmd = {
      'WindowsMaximize',
      'WindowsMaximizeVertically',
      'WindowsMaximizeHorizontally',
      'WindowsEqualize',
      'WindowsEnableAutowidth',
      'WindowsDisableAutowidth',
      'WindowsToggleAutowidth',
    },
    enabled = false,
  },
  {
    'karb94/neoscroll.nvim',
    opts = {
      mappings = {},
    },
  },
  { 'tzachar/highlight-undo.nvim', opts = {}, keys = { 'u', '<c-r>' } },

  -- folds
  {
    'kevinhwang91/nvim-ufo',
    opts = {
      fold_virt_text_handler = handler,
      provider_selector = function(_, filetype)
        return ftMap[filetype]
      end,
    },
    name = 'ufo',
    event = 'VeryLazy',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    init = function()
      vim.o.foldcolumn = '0' -- '0' hidden, '1', visible
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },
  {
    'jghauser/fold-cycle.nvim',
    opts = {
      open_if_max_closed = true, -- closing a fully closed fold will open it
      close_if_max_opened = true, -- opening a fully open fold will close it
      softwrap_movement_fix = false, -- see below
    },
  },
}
