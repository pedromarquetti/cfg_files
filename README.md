# Welcome to my Dotfiles

This is a collection of my basic config files for my _PopOS_ env, created with a bare git repo that auto-tracks my files (idea from [here](https://www.atlassian.com/git/tutorials/dotfiles))

I'll always be adding more stuff

## Contents:

1. setup.sh _(work in proggress)_ with automated installation.
2. .zshrc with my preferred aliases.
3. .config with vscode config/settings/snippets and dconf settings
4. .backup containing crontab-install-scripts and UBlockOrigin backup file

## Setup

### For an automated setup just run:

```
curl -L https://raw.githubusercontent.com/pedromarquetti/cfg_files/master/.local/bin/setup.sh | bash
```

### For non-root users (you have to run the above first)

```
curl -L https://raw.githubusercontent.com/pedromarquetti/cfg_files/master/.local/bin/setup_noroot.sh | bash
```

### Or you could do it manually

```
git clone https://github.com/pedromarquetti/cfg_files.git
# mv cfg_files/<file/dir> ~
```

## Scripts

Some useful script are located at `.local/bin`, they can be used to save your configs locally, my_cron_install and root_cron_install are useful crontabs I use to keep my system up to date

## Backups

At `.backup` and `.config/Code/Backups/`, there are some configs I use. The scripts mentioned above will update these configs

## Issues

Please report if you find any issues, I just learned Shell Scripting, so, errors are expected
