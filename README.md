# Dajabe dotfile repository

Here you will find the dotfiles that I use to run my dev environments.
I tried some dotfile managers and in the end decided that rolling some of my
own scripts while stealing ideas from others would ultimately be a better 
experience for me.

# Usage

Each directory contains the config files for a specific application.
To setup the config files for that application simply run the `<app>/link` script inside
which will remove the directory that currently exists in the system for that
application and replace it with a link to the directory in this repository.

I use both Mac and Linux platforms and where it makes sense the config will be further
split into `MacOS` and `Nix` folders underneath or something similar.

## Repository location

These configs are moving towards storing personal repositories under `~/dev/dajabe`.
Tools that open this dotfiles repository will prefer `~/dev/dajabe/.dotfiles` and
`~/dev/dajabe/.ds-dots`.

During migration, `tec` will still use repositories found directly under `~/dev`, but
it will print a reminder in the `home/config` tmux window to move them to
`~/dev/dajabe` or set `REPOSITORY_DIR` for a host-specific override.

## Tmux plugins

TPM and tmux plugins are moving towards TPM's default location:

```text
~/.tmux/plugins
```

The tmux config first checks for TPM at `~/.tmux/plugins/tpm`. During migration it
will also load an existing TPM install from `~/.config/tmux/plugins/tpm`. New setups
should install TPM into `~/.tmux/plugins/tpm`.

# TODO

[ ] Setup a main entry point script that prompts you for what you want to install.
[ ] Add some confirmation before `rm -rf` perhaps a way to save the old directory
