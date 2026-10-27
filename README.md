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

## Initialize Docker on macOS

The Macs run Docker Engine in the vzvm Nix builder. Both workloads share its
8 cores and 16 GiB RAM. Apply the configuration for the matching host:

```shell
darwin-rebuild switch --flake .#tmmy-mbp
```

Open a new terminal and initialize the Docker context as your regular user:

```shell
unset DOCKER_HOST DOCKER_CONTEXT
docker-builder-init
docker version
docker run --rm hello-world
docker compose version
docker buildx version
```

The `vzvm` context connects through SSH to `docker-builder`. Launchd manages the
VM automatically. Docker images and named volumes live on the persistent
`/var/lib/darwin-builder/docker.img` disk (100 GiB initially). The Nix builder's
writable disk remains ephemeral and resets when the VM restarts.

Ports 8080 and 5432 forward from Mac localhost to the same guest ports. Publish
a container port and connect through `http://localhost:8080`:

```shell
docker run --rm -p 8080:80 nginx:alpine
```

Configure additional TCP ports with `nix.linux-builder.docker.forwardedPorts` in
the host configuration, then rebuild. Forwarding binds to `127.0.0.1`.
The Mac user's home directory is shared at the same path inside the guest;
bind mounts must use paths inside that home:

```shell
docker run --rm -v "$HOME/projects:/workspace" alpine ls /workspace
```

Before switching from Colima, stop its VM with `colima stop`. Existing Colima
images and volumes stay in its disk; transfer data you need before removing
that profile. Use the Colima executable from the old system generation or
`nix run nixpkgs#colima -- delete` to remove its VM disk after migration.

## Run x86-64 containers on Apple Silicon

The ARM vzvm guest runs `linux/amd64` containers through Rosetta. Select the image platform explicitly:

```shell
docker run --rm --platform linux/amd64 alpine uname -m
```

The expected output is `x86_64`. ARM containers run natively:

```shell
docker run --rm --platform linux/arm64 alpine uname -m
```

For Compose, set the platform on the service:

```yaml
services:
  app:
    image: your-image:tag
    platform: linux/amd64
```

Rosetta translates x86-64 user-space binaries; the guest kernel remains ARM.
Native ARM images are preferable when available. Rosetta's compatibility depends
on the host macOS version. The shared guest uses Linux 6.12 on Sequoia 15.5 and
later; Tahoe uses the default kernel. See [Docker's platform option](https://docs.docker.com/reference/cli/docker/container/run/).

## Initialize Docker on Linux

The NixOS hosts run Docker Engine and grant their configured regular users access
through the `docker` group. Apply the configuration, replacing the host name as
needed:

```shell
sudo nixos-rebuild switch --flake .#tmmy-yoga
```

Log out and back in to pick up group membership, then verify Docker:

```shell
systemctl status docker
docker run --rm hello-world
docker compose version
docker buildx version
```

The standalone Home Manager configuration supplies Docker client tools; its host
must provide Docker Engine and socket access. The x86-64 NixOS hosts run
`linux/amd64` containers natively.

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
