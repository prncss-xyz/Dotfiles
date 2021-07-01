-- bootstraping packer
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end

vim.cmd "packadd packer.nvim"
return require "packer".startup(
  function()
    use {"wbthomason/packer.nvim", opt = true}
    -- Utils
    use "tami5/sql.nvim"
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require "setup/treesitter"
      end
    }

    -- TUI
    use "nvim-lua/popup.nvim"
    use "nvim-lua/plenary.nvim"
    -- pictograms
    use {
      "onsails/lspkind-nvim",
      config = function()
        require("lspkind").init({File = " "})
      end
    }
    -- for lsp completion items
    use "kyazdani42/nvim-web-devicons"

    -- Projects
    use "windwp/nvim-projectconfig"
    use 'rmagatti/auto-session'
    use {
      'rmagatti/session-lens',
      requires = {'rmagatti/auto-session'}
    }

    -- Navigation
    use "kevinhwang91/nvim-hlslens"
    use "haya14busa/vim-asterisk"
    use 'andymass/vim-matchup'
    use {"jremmen/vim-ripgrep", command = {"Rg"}}
    use "bkad/CamelCaseMotion" -- ,w
    use 'ggandor/lightspeed.nvim'

    -- Edition
    use "matze/vim-move" -- Move current line/selection
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "RRethy/nvim-treesitter-textsubjects"
    use {
      "b3nj5m1n/kommentary",
      config = function()
        require("kommentary.config").configure_language(
          "default",
          {
            prefer_single_line_comments = true
          }
        )
      end
    }
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use {
      -- insert or delete brackets, parens, quotes in pair
      "windwp/nvim-autopairs",
      config = function()
        require "nvim-autopairs".setup()
      end
    }
    use {
      -- Use treesitter to autoclose and autorename html tag
      "windwp/nvim-ts-autotag",
    }
    use "machakann/vim-sandwich"
    -- NOT WORKING
    -- use {
    --   "blackCauldron7/surround.nvim",
    --   config = function()
    --     require "surround".setup {}
    --   end
    -- }
    use {
      "mattn/emmet-vim",
      config = function()
        vim.g.emmet_html5 = true
        vim.g.emmet_complete_tag = true
      end
    }
    
    -- Language support
    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup()
      end
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
      end
    }
    -- use "norcalli/snippets.nvim"
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/vim-vsnip-integ"
    use "~/Media/Projects/snippets"
    use "jose-elias-alvarez/nvim-lsp-ts-utils"
    use 'romgrk/nvim-treesitter-context'

    -- Language syntax
    use "potatoesmaster/i3-vim-syntax"

    -- UI
    -- Bbye allows you to do delete buffers (close files) without closing your windows or messing up your layout.
    use "moll/vim-bbye" 
    use 'wellle/visual-split.vim'
    use {"kevinhwang91/nvim-bqf"}
    use {
      "hrsh7th/nvim-compe",
      config = function()
        require "setup/compe"
      end
    }
    use {
      "lewis6991/gitsigns.nvim",
      config = function()
        require "setup/gitsigns"
      end
    }
    use 'iberianpig/tig-explorer.vim'
    use {
      "glepnir/galaxyline.nvim",
      config = function()
        require "setup/galaxyline"
      end
    }
    use 'brettanomyces/nvim-terminus'
    -- use {
    --   'romgrk/barbar.nvim',
    -- }
    use "akinsho/nvim-bufferline.lua"
    use {
      "lukas-reineke/indent-blankline.nvim",
      branch = "lua"
    }
    -- use {
    --   "liuchengxu/vista.vim"
    -- }
    use "p00f/nvim-ts-rainbow"
    use {
      "junegunn/goyo.vim",
      config = function()
        require "setup/goyo"
      end,
      command = {"Goyo", "Goyo!", "Goyo!!"}
    }
    use {
      "junegunn/limelight.vim",
      config = function()
        -- Default: 0.5
        vim.g.limelight_default_coefficient = 0.5
        -- Number of preceding/following paragraphs to include (default: 0)
        vim.g.limelight_paragraph_span = 2

        -- Beginning/end of paragraph
        -- When there's no empty line between the paragraphs
        -- and each paragraph starts with indentation
        vim.g.limelight_bop = [[^\s]]
        vim.g.limelight_eop = [[\ze\n^\s]]
        -- Highlighting priority (default: 10)
        -- Set it to -1 not to overrule hlsearch
        vim.g.limelight_priority = -1
      end,
      command = {"Goyo", "Goyo!", "Goyo!!"}
    }
    use "nvim-telescope/telescope-fzy-native.nvim"
    use {
      "nvim-telescope/telescope.nvim",
      config = function()
        require "setup/telescope"
      end
    }
    use {
      "metakirby5/codi.vim",
      command = {"Codi", "Codi!", "Codi!!"}
    }
    use {
      "nvim-treesitter/playground",
      command = {"TSPlaygroundToggle"}
    }

    -- Integration
    use "tpope/vim-eunuch"

    -- Natural languages
    use {
      "vigoux/LanguageTool.nvim",
      command = {"LanguageToolSetup", "LanguageToolCheck"}
    }
    -- Learning
    -- use {"tzachar/compe-tabnine", run = "sh install.sh"} -- is that ok? crashes
    use {
      "folke/which-key.nvim",
      config = function()
        require("which-key").setup {}
      end
    }
    use {
      "RishabhRD/nvim-cheat.sh",
      requires = "RishabhRD/popfix",
      command = {"Cheat", "CheatWithoutComments", "CheatList", "CheatListWithoutComments"}
    }
    use {
      "lifepillar/vim-cheat40",
      command = {"Cheat40"}
    }

    -- FX
    use {
      -- "edluffy/specs.nvim" -- not working
    }
    use {
      "karb94/neoscroll.nvim",
      config = function()
        require('neoscroll').setup{}
      end
    }

    -- Utilities
    -- use "oberblastmeister/neuron.nvim",
    use "~/Media/Projects/nononotes-nvim"

    -- Color schemes
    -- classics
    use "romainl/flattened"
    use "morhetz/gruvbox"
    -- monochromish
    use "fcpg/vim-orbital"
    use "arcticicestudio/nord-vim"
    use "wadackel/vim-dogrun"
    -- poly
    use "whatyouhide/vim-gotham"
    use "rakr/vim-one"
    use "cseelus/vim-colors-lucid"
    use "atelierbram/Base2Tone-vim"
    -- more poly
    use "pineapplegiant/spaceduck"
    use "sainnhe/sonokai"
    use "sainnhe/gruvbox-material"
    use "glepnir/oceanic-material"
  end
)
