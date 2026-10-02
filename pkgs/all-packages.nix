{
  pkgs,
  brewSrc ? null,
}:
{
  commitlint = pkgs.callPackage ./commitlint/package.nix { };
  nixos-rebuild = pkgs.callPackage ./nixos-rebuild.nix { };
}
// pkgs.lib.optionalAttrs (brewSrc != null) {
  homebrew-tahoe = pkgs.callPackage ./homebrew-tahoe.nix { inherit brewSrc; };
}
