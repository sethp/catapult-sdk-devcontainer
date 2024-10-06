# Development Notes

## Features

Why? Because despite their lawful evil release process energy, they at least will set things up to match expectations.

Why not? They're very much a NIH-syndrome half-baked replacement for BuildKit's execution graph that's opaque, hard to configure, and doesn't play nicely with others (caches, concurrency, etc). Unfortunately, repair here would look like 1) reverse engineering all their present and future steps to work better, and/or 2) building a custom BuildKit frontend that would allow semi-automatic composition of the same.

So, instead, we choose to document why they're here, and thus what it would minimally take to replace them.

### common-utils

e.g. https://github.com/devcontainers/features/tree/feature_common-utils_2.4.1/src/common-utils

- Adds a `vscode` user
- Installs a set of "expected" packages (`zsh`, `jq`, `less`, `strace`, etc.)
- Adds rc snippets to shells to match vscode's expectations (e.g. `$GIT_EDITOR`)

### git

e.g. https://github.com/devcontainers/features/tree/feature_git_1.2.0/src/git

Installs a relatively modern git version, rather than whatever ancient thing the distro's packages hold.
