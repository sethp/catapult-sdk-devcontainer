# Catapult SDK dev container

A dev container for use with Catapult Studio: https://marketplace.visualstudio.com/items?itemName=ImaginationTech.catapult-studio


## TODO

- [ ] devcontainer lock file?
- [ ] "install drivers" ?
- [ ] making sure all the right /sys/dev &c passthroughs are set up (cf. https://stackoverflow.com/questions/71366286/how-to-mount-dev-bus-usb-on-vscodes-devcontainer-for-docker )
- [ ] Getting started instructions
- [ ] build & push via https://github.com/devcontainers/ci
- [ ] dependabot?

## Contributing

Generating the lock file for reproducible builds happens via:

```
npx @devcontainers/cli upgrade --workspace-folder .
```
