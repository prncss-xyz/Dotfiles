local M = {}

function M.setup()
  require('utils').deep_merge(vim.g, {
    -- ['test#strategy'] = 'neovim', -- 'shtuff' , 'harpoon', 'neovim'
    shtuff_receiver = 'devrunner',
    -- nvim --headless -c "PlenaryBustedDirectory tests/plenary/ {minimal=true}"
    ultest_use_pty = 1,
    ultest_env = {
      NODE_OPTIONS = '--experimental-vm-modules',
    },
  })
end

function M.config()
  require('ultest').setup {
    builders = {
      ['javascript#jest'] = function(cmd)
        local filename = cmd[#cmd]
        print(filename)
        -- require('utils').dump(cmd)
        return {
          dap = {
            type = 'node2',
            request = 'launch',
            cwd = vim.fn.getcwd(),
            args = {
              '--inspect-brk',
              'node_modules/.bin/jest',
              filename,
            },
            sourceMaps = true,
            protocol = 'inspector',
            skipFiles = { '<node_internals>/**/*.js' },
            console = 'integratedTerminal',
            port = 9229,
          },
        }
      end,
    },
  }
  require('utils').augroup('Tests', {
    {
      events = { 'BufWritePost' },
      targets = { '*' },
      modifiers = { 'silent!' },
      command = 'UltestNearest',
    },
  })
end

return M
