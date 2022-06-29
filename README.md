# My personnal dotfiles

I've learned a lot about software architechture and system administration here. Some refactoring is still needed, but patterns are emerging, and it keeps getting simpler.

Workflow is based on [stow](https://www.gnu.org/software/stow/), with extra scripts to manage cross-application theming and system files (root). It is also useful to manage small configuration differences between my different hosts. My configuration also features [xplr](https://github.com/sayanarijit/xplr) file manager and [neovim](https://github.com/neovim/neovim) text editor. Neovim is the most mature part of this config. I use [syncthing](https://syncthing.net/) to sync data between machines and favor applications that are compatible with this replication model. Secrets, including ssh keys, api keys and passwords are keept with [gpg](https://gnupg.org/) and [pass](https://www.passwordstore.org/), and are so kept apart from dotfiles.

 Commits are aweful as I often need to commit on the go to synchronise between machines. That need will eventually go away with next major refactoring.
