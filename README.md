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

# TODO

[ ] Setup a main entry point script that prompts you for what you want to install.
[ ] Add some confirmation before `rm -rf` perhaps a way to save the old directory
