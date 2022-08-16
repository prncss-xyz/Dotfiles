local M = {}

function M.init()
  if false then
    require('grammar-guard').init()
    lspconfig.grammar_guard.setup {
      cmd = { '/usr/bin/ltex-ls' },
      settings = {
        ltex = {
          language = 'en',
        },
      },
    }
  else
    local language_id_mapping = {
      bib = 'bibtex',
      plaintex = 'tex',
      rnoweb = 'sweave',
      rst = 'restructuredtext',
      tex = 'latex',
      xhtml = 'xhtml',
      sh = 'shellscript',
    }

    require('lspconfig').ltex.setup {
      filetypes = {
        'html',
        'bib',
        'gitcommit',
        'markdown',
        'org',
        'plaintex',
        'rst',
        'rnoweb',
        'tex',
        -- causes too many false positives
        -- 'sh',
        'go',
        'javascript',
        'javascriptreact',
        'lua',
        'python',
        'sql',
        'typescript',
        'typescriptreact',
        'NeogitCommitMessage',
      },
      get_langugage_id = function(_, filetype)
        local language_id = language_id_mapping[filetype]
        if language_id then
          return language_id
        else
          return filetype
        end
      end,
      settings = {
        ltex = {
          enabled = true and {
            'shellscript',
            'go',
            'javascript',
            'javascriptreact',
            'lua',
            'python',
            'sql',
            'typescript',
            'typescriptreact',
            'markdown',
          } or {},
          -- language = 'en',
          -- autodetection does not work well for source files and keyword heavy notes
          -- language = 'auto',
          -- additionalRules = {
          --   motherTongue = {
          --     'fr',
          --   },
          -- },
          completionEnabled = true,
        },
      },
    }
  end
end

return M
