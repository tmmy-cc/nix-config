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
