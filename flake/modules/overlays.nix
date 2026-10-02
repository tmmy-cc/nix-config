{ inputs, ... }:
let
  inherit (inputs) nixpkgs-unstable ghostty;
in
{
  flake.overlays = {
    default = import ../../pkgs/overlay.nix {
      brewSrc = inputs.nix-homebrew.inputs.brew-src;
    };
    unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit (prev) system;
        inherit (prev) config;
      };
    };
    ghostty = final: prev: {
      ghostty = import ghostty.packages {
        inherit (prev) system;
        inherit (prev) config;
      };
    };
    qemu-apple-m4 = final: prev: {
      qemu = prev.qemu.overrideAttrs (
        final: prev: {
          patches = prev.patches ++ [ ../../patches/qemu-fix-apple-m4.patch ];
        }
      );
    };
    karabiner-elements = final: prev: {
      karabiner-elements = prev.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";

        src = prev.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
      });
    };
  };
}
