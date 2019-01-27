# Ansible vault tools

[git-crypt](https://github.com/AGWA/git-crypt) is a tool to transparently
encrypt and decrypt sensitive files in a git repository.
One big problem with it is when auto-merging files,
for example, to resolve a merge conflict.
This repo contains a helper script to solve this problem.

## Caveat
1. Only works with named/alternative keys, not `default` keys (more details
[here](https://github.com/AGWA/git-crypt/blob/master/doc/multiple_keys.md))

2. Does not work with GPG keys

## Installation and uninstallation
 Run `make install` or `make uninstall` to install or uninstall the tool.

## Git configuration

Please ensure that you have a proper `.gitattributes` and a local `.gitconfig`
file set up to use this tool correctly.

The configuration for the git-crypt diff handler goes into
`$HOME/.gitconfig`. Update the `/use/local/bin` path as necessary, and ensure
that the right key name is specified here.
If there are any merge conflicts, `$EDITOR` is opened allowing you to resolve
the conflict before the merged file is re-encrypted.

```ini
# gitconfig
[merge "git-crypt-<key name>"]
	name = git-crypt merge driver
	driver = /usr/local/bin/git-crypt-merge.sh -b %O -c %A -o %B -l %P -k <key name>
	recursive = binary
```

## Thanks

This effort has been inspired by the comment
[here](https://github.com/AGWA/git-crypt/issues/140#issuecomment-361031719).

The majority of the repository structure is based on the
[ansible-vault-tools](https://github.com/building5/ansible-vault-tools)
repository

