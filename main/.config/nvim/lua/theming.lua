-- TODO: require theme plugins here

local cmd = vim.cmd
local g = vim.g
local theme = require"theme"

return {
  setup = function()
    --Broken
    --theme = "one"
    --theme = "lucid"
    --theme = "orbital"
    --theme = "Base2Tone_LavenderLight"

    -- Light
    -- vim.o.background = "light"
    --theme = "gruvbox-material"
    --theme = "flattened_light"

    -- Dark
    vim.o.background = "dark"
    --theme = "spaceduck"
    --theme = "oceanic_material":
    --theme = "dogrun"
    --theme = "gotham"
    theme = "flattened_dark"
    --theme = "nord"
    --theme = "sonokai"

    -- Color name (:help cterm-colors) or ANSI code
    g.limelight_conceal_ctermfg = "gray"
    g.limelight_conceal_ctermfg = 240
    -- Color name (:help gui-colors) or RGB color
    g.limelight_conceal_guifg = "DarkGray"
    g.limelight_conceal_guifg = "#777777"

    --[[
    --
    -- https://github.com/neovim/neovim/issues/2897#issuecomment-115464516::
    g.terminal_color_0 = "#2e3436"
    g.terminal_color_1 = "#cc0000"
    g.terminal_color_2 = "#4e9a06"
    g.terminal_color_3 = "#c4a000"
    g.terminal_color_4 = "#3465a4"
    g.terminal_color_5 = "#75507b"
    g.terminal_color_6 = "#0b939b"
    g.terminal_color_7 = "#d3d7cf"
    g.terminal_color_8 = "#555753"
    g.terminal_color_9 = "#ef2929"
    g.terminal_color_10 = "#8ae234"
    g.terminal_color_11 = "#fce94f"
    g.terminal_color_12 = "#729fcf"
    g.terminal_color_13 = "#ad7fa8"
    g.terminal_color_14 = "#00f5e9"
    g.terminal_color_15 = "#eeeeec"
    --]]
    cmd("colorscheme " .. theme)

    --cm "color Base2Tone_LavenderLight"
    --cmd"color flattened_dark"
    --cmd'color flattened_light'
    --cmd"color orbital"
    --cmd"color nord"
    --cmd"color dogrun"
    --cmd"color gotham"
    --cmd"color mountaineer"
    --cmd"color mountaineer-grey"
    --cmd"color mountaineer-light"
    --cmd"color gruvbox"
    --cmd "color one" -- https://github.com/joshdick/onedark.vim might work better with term
    --cmd"color lucid"
    --cmd"color Base2Tone"
    -- g:gruvbox_invert_selection
    -- g:gruvbox_italicize_comments
    -- g:gruvbox_contrast_light
    -- g:gruvbox_contrast_dark
    -- set background=dark    " Setting dark mode
    -- set background=light   " Setting light mode
  end
}

-- NVIM_TUI_ENABLE_TRUE_COLOR=0
