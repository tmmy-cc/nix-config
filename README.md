# tmmy-cc's personal NixOS/home-manager configuration

This is my personal NixOS/home-manager configuration.

*DISCLAIMER*: Since I'm a Nix noob, please do not expect any useful stuff here.

# Rebuild the nixos configuration

```shell
sudo nixos-rebuild switch --flake .
```

or

```shell
darwin-rebuild switch --flake .#thst-mbp
```

# macOS Linux builder

Both macOS configurations use [vzvm](https://github.com/applicative-systems/vzvm)
through `nix.linux-builder`, with Rosetta for `x86_64-linux` builds and native
`aarch64-linux` builds. The VM has 8 cores, 16 GiB RAM, a 100 GiB writable disk,
and supports 4 concurrent build jobs.

The launchd service keeps the VM running. Its writable disk is recreated on each
start (`ephemeral = true`); the read-only guest store image is cached between
starts. Rosetta is installed by the macOS activation script. Hosts running macOS
Sequoia 15.5 and later use Linux 6.12 for Rosetta compatibility; Tahoe uses the
default guest kernel. Set `nix.linux-builder.hostMacOSVersion` to the target Mac’s version and
update it when upgrading macOS.

Read VM logs with:

```shell
/usr/bin/log stream --predicate 'subsystem == "systems.applicative.vzvm"'
```

# Docker

The Macs use the Docker CLI with Colima. Home Manager supplies a Colima template
with Apple virtualization, Rosetta, 4 cores, 4 GiB RAM, and 100 GiB disk space.
Start the container VM and select its Docker context after rebuilding:

```shell
colima start
docker context use colima
docker run --rm hello-world
docker compose version
docker buildx version
```

Stop the VM with `colima stop`. The template applies to new Colima profiles;
existing profiles retain their configuration. Container images and volumes persist
across VM restarts.

The NixOS hosts run Docker Engine and grant their configured regular users access
through the `docker` group. Log in again after switching to pick up group changes.
The standalone Home Manager configuration supplies Docker client tools; its host
must provide Docker Engine and socket access.

# Use with nixos-anywhere

Generate `hardware-configuration.nix` for remote host:

```shell
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./nixos/clara-mbp/hardware-configuration.nix --flake .#clara-mbp --target-host nixos@[IP]
```

Rebuild nixos configuration on remote host when SSH root login is allowed:

```shell
nix run .#nixos-rebuild -- switch --target-host root@[IP] --flake .#clara-mbp
```

Or if root login isn't allowed:

```shell
nix run .#nixos-rebuild -- switch --target-host clara@[IP] --use-remote-sudo --flake .#clara-mbp
```

# Uninstalled from thst-mbp

Uninstalling libgpg-error... (50 files, 1.7MB)
Uninstalling libassuan... (18 files, 564.2KB)
Uninstalling libgcrypt... (24 files, 3.3MB)
Uninstalling libksba... (19 files, 529.9KB)
Uninstalling libusb... (23 files, 619.8KB)
Uninstalling npth... (13 files, 168.8KB)
Uninstalling pinentry... (13 files, 458.0KB)
Uninstalling gnupg... (145 files, 14.8MB)
Uninstalling gpgme... (110 files, 4.8MB)
Uninstalling nspr... (82 files, 1.2MB)
Uninstalling nss... (215 files, 19.5MB)
Uninstalling poppler... (443 files, 29.7MB)
