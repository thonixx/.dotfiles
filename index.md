# Howto

## Adding new modules

`git subtree add --squash --prefix=<path> <url> <version/branch>`

## Updating existing subtree to new release

`git subtree pull --squash --prefix=<path> <url> <version/branch>`

# List of used third party modules

The following modules come with subtree merging:

| Module                     | URL                                                   |  Version       |
| -------------------------- | ----------------------------------------------------- |  ------------- |
| vim-puppet                 | <https://github.com/rodjek/vim-puppet>                |  master        |
| tlib_vim                   | <https://github.com/tomtom/tlib_vim>                  |  master        |
