local cmd = vim.cmd
local g = vim.g
return {
  setup = function()
    -- Color name (:help cterm-colors) or ANSI code
    g.limelight_conceal_ctermfg = "gray"
    g.limelight_conceal_ctermfg = 240

    -- Color name (:help gui-colors) or RGB color
    g.limelight_conceal_guifg = "DarkGray"
    g.limelight_conceal_guifg = "#777777"

    -- vim.o.background = "dark"
    vim.o.background = 'light'

    --cmd "color Base2Tone_LavenderLight"
    --cmd"color flattened_dark"
    cmd'color flattened_light'
    --cmd"color orbital"
    --cmd"color nord"
    --cmd "color dogrun"
    --cmd"color gotham"
    --cmd"color mountaineer"
    --cmd"color mountaineer-grey"
    --cmd"color mountaineer-light"
    --cmd"color gruvbox"
    --cmd"color one"
    --cmd "color lucid"
    --cmd"color Base2Tone"
    -- g:gruvbox_invert_selection
    -- g:gruvbox_italicize_comments
    -- g:gruvbox_contrast_light
    -- g:gruvbox_contrast_dark
    -- set background=dark    " Setting dark mode
    -- set background=light   " Setting light mode
  end
}
