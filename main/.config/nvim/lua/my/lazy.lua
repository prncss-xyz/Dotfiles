local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
    vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "my.plugins" },
    },
    defaults = { lazy = true },
    install = {
      colorscheme = { "rose-pine" }
    },
    performance = {
        rtp = {
          reset = true,
          disabled_plugins = {
            "gzip",
            -- "matchit",
            -- "matchparen",
            "netrwPlugin",
            "rplugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
})
