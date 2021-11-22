local m = {}

function m.setup()
  require('modules.utils').deep_merge(vim.g, {
    ultest_use_pty = 1,
    ultest_env = {
      NODE_OPTIONS = '--experimental-vm-modules',
    },
  })
end

function m.config()
  require('ultest').setup {
    builders = {
      ['javascript#jest'] = function(cmd)
        local filename = cmd[#cmd]
        print(filename)
        -- require('modules.utils').dump(cmd)
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
end

return m
