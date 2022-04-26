# Welcome to my Dotfiles

This is a collection of my basic config files for my _PopOS_ env, created with a bare git repo that auto-tracks my files (idea from [here](https://www.atlassian.com/git/tutorials/dotfiles))

I'll always be adding more stuff

## Contents:

1. setup.sh _(work in proggress)_ with automated installation.
2. .zshrc with my preferred aliases.
3. .config with vscode config/settings/snippets and dconf settings 
5. .backup containing crontab-install-scripts and UBlockOrigin backup file

## Setup

1. For an automated setup just run:

```
curl -L https://raw.githubusercontent.com/PedroMarquetti/cfg_files/master/.local/bin/setup.sh | bash
```

2. Or you could do it manually

```
git clone https://github.com/PedroMarquetti/cfg_files.git
```

and copy files manually

3. To install my [list of VSCode extensions](https://github.com/PedroMarquetti/cfg_files/blob/08b38e9830382f88b1896c6309623591cbe8f69d/.config/Code/Backups/code_extensions.lst), run vscode first:

`code .`

then

```
cd $HOME/.config/Code/Backups
chmod u+x $HOME/.config/Code/Backups/code_extensions.lst && $HOME/.config/Code/Backups/code_extensions.lst
```

some errors may occur, but you can always do it manually
