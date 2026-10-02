{ brewSrc }:
final: _prev:
let
  localPackages = import ./all-packages.nix {
    pkgs = final;
    inherit brewSrc;
  };
in
{
  inherit (localPackages) commitlint homebrew-tahoe;
}
