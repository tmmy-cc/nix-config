#!/bin/sh
nix run .#nixos-rebuild -- switch --flake ".?submodules=1"
