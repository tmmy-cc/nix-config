{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      localPackages = import ../../pkgs/all-packages.nix { inherit pkgs; };
    in
    {
      packages.nixos-rebuild = localPackages.nixos-rebuild;
      apps.nixos-rebuild = {
        type = "app";
        program = "${localPackages.nixos-rebuild}/bin/nixos-rebuild";
      };
      devShells.default = pkgs.mkShell {
        packages = [ localPackages.nixos-rebuild ];
      };
      formatter = pkgs.nixfmt-rfc-style;
    };
}
