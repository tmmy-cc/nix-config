{ ... }:
{
  flake = {
    nixosModules = { };
    darwinModules = {
      git = import ../../modules/darwin/git.nix;
      linux-builder = import ../../modules/darwin/linux-builder.nix;
    };
  };
}
