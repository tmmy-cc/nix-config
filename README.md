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

## Initialize Docker and Colima on macOS

The Macs use the Docker CLI with Colima. Home Manager supplies a Colima template
with Apple virtualization, Rosetta, 4 cores, 4 GiB RAM, and 100 GiB disk space.
Apply the configuration first, choosing the matching host:

```shell
darwin-rebuild switch --flake .#tmmy-mbp
```

Open a new terminal, then initialize and start Colima as your regular user:

```shell
unset DOCKER_HOST DOCKER_CONTEXT
colima start --runtime docker --vm-type vz --vz-rosetta
docker context use colima
colima status
docker version
docker run --rm hello-world
docker compose version
docker buildx version
```

The first start downloads and creates the container VM. Subsequent starts use
`colima start`; stop it with `colima stop`. Container images and volumes persist
across VM restarts. This VM is separate from the vzvm Nix builder.

The template applies to new Colima profiles. Existing profiles retain their
configuration; inspect `~/.colima/default/colima.yaml` and use
`colima start --edit` to change it. VM type and architecture are fixed when the
profile is created. See the [Colima configuration documentation](https://colima.run/docs/configuration/).

## Run x86-64 containers on Apple Silicon

Colima's ARM Linux VM runs `linux/amd64` containers through Rosetta when `vz` and
`rosetta: true` are enabled. Select the image platform explicitly:

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
on the macOS version and the Colima guest kernel; the Nix builder's Linux 6.12 pin
applies only to the separate Nix builder VM. See [Colima's Rosetta settings](https://colima.run/docs/configuration/#rosetta)
and [Docker's platform option](https://docs.docker.com/reference/cli/docker/container/run/).

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
