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

    -- Text Edition
    use "farmergreg/vim-lastplace"
    use "matze/vim-move"
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
      "windwp/nvim-autopairs",
      config = function()
        require "nvim-autopairs".setup()
      end
    }
    use {
      "mhartington/formatter.nvim",
      config = function()
        require "setup/formatter"
      end
    }
    use {
      "windwp/nvim-ts-autotag"
    }
    -- use "sickill/vim-pasta"
    -- use "tpope/vim-surround"
    use "machakann/vim-sandwich"
    use {
      "mattn/emmet-vim",
      config = function()
        vim.g.emmet_html5 = true
        vim.g.emmet_complete_tag = true
      end
    }
    -- Language support
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require "setup/treesitter"
      end
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require "setup/lsp"
      end
    }
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/vim-vsnip-integ"

    -- Language specific
    use "dag/vim-fish"
    use "potatoesmaster/i3-vim-syntax"

    -- Snippets
    --  wget https://raw.githubusercontent.com/microsoft/vscode/main/extensions/typescript-basics/snippets/typescript.code-snippets -O typescript.json
    --  wget https://raw.githubusercontent.com/microsoft/vscode/main/extensions/javascript/snippets/javascript.code-snippets -O javacript.json
    --
    -- Environement
    use "mhinz/vim-sayonarmhinz/vim-sayonara"
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
    use {
      "glepnir/galaxyline.nvim",
      config = function()
        require "setup/galaxyline"
      end
    }
    use {
      "akinsho/nvim-bufferline.lua",
      config = function()
        require "setup/bufferline"
      end
    }
    use {
      "lukas-reineke/indent-blankline.nvim",
      branch = "lua"
    }
    use "liuchengxu/vista.vim"
    use "p00f/nvim-ts-rainbow"
    -- use {"tzachar/compe-tabnine", run = "sh install.sh"} -- is that ok?
    use {
      "junegunn/goyo.vim",
      config = function()
        require "setup/goyo"
      end
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
      end
    }
    use "RishabhRD/nvim-cheat.sh"
    use "RishabhRD/popfix"
    use "lifepillar/vim-cheat40"
    use "psliwka/vim-smoothie"

    use {
      "nvim-telescope/telescope.nvim",
      config = function()
        --        require "setup/telescope"
      end
    }
    use "nvim-telescope/telescope-frecency.nvim"
    use "nvim-telescope/telescope-project.nvim"
    use "metakirby5/codi.vim"

    -- Integration
    use "tpope/vim-eunuch"

    -- Utilities
    use {
      "oberblastmeister/neuron.nvim",
      config = function()
        require "setup/neuron"
      end
    }
    -- Color schemes
    -- classics
    use "romainl/flattened"
    use "morhetz/gruvbox"
    -- monochromish
    use "fcpg/vim-orbital"
    use "arcticicestudio/nord-vim"
    use "wadackel/vim-dogrun"
    use "co1ncidence/mountaineer.vim"
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
