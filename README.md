# tmmy-cc's personal NixOS/home-manager configuration

This is my personal NixOS/home-manager configuration.

*DISCLAIMER*: Since I'm a Nix noob, please do not expect any useful stuff here.

# Rebuild the nixos configuration

```shell
sudo nixos-rebuild switch --flake .
```

# Use with nixos-anywhere

Generate `hardware-configuration.nix` for remote host:

```shell
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./nixos/clara-mbp/hardware-configuration.nix --flake .#clara-mbp --target-host nixos@[IP]
```

Rebuild nixos configuration on remote host when SSH root login is allowed:

```shell
nixos-rebuild switch --target-host root@[IP] --flake .#clara-mbp
```

Or if root login isn't allowed:

```shell
nixos-rebuild switch --target-host clara@[IP] --use-remote-sudo --flake .#clara-mbp
```

