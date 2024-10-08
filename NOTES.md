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

Why no "upgradePackages"? Because that would couple the output image artifact to the time at which the build was run. Upgrading OS packages can be achieved by changing the pinned SHA for the ubuntu base container in the `FROM`.

### git

e.g. https://github.com/devcontainers/features/tree/feature_git_1.2.0/src/git

Installs a relatively modern git version, rather than whatever ancient thing the distro's packages hold.

Oof, but it adds an extra 2+ minutes to every image build. Good thing that's being done ahead of time?

## udev Rules

```udev
# xilinx pcusb
ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"

# xilinx diligent
ATTR{idVendor}=="1443", MODE:="666"
ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"

# xilinx ftdi usb
ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
```

Writing those rules to e.g. `/etc/udev/rules.d/55-xilinx-perms.rules` and then re-triggering udev:

```
sudo sh -c 'udevadm control --reload-rules && udevadm trigger'
```

Will resolve all permissions issues by simply removing any permission checks. Here's to hoping for the best!
