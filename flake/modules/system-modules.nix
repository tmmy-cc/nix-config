{ ... }:
{
  flake = {
    nixosModules = { };
    darwinModules.git = import ../../modules/darwin/git.nix;
  };
}
