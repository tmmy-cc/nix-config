{
  pkgs,
  brewSrc ? null,
  vzvmBase ? pkgs.vzvm,
  dockerStateDirectory ? "/var/lib/darwin-builder",
  dockerDiskSizeMiB ? 100 * 1024,
}:
{
  vzvm-docker = pkgs.callPackage ./vzvm-docker.nix {
    inherit vzvmBase dockerStateDirectory dockerDiskSizeMiB;
  };
  commitlint = pkgs.callPackage ./commitlint/package.nix { };
  nixos-rebuild = pkgs.callPackage ./nixos-rebuild.nix { };
}
// pkgs.lib.optionalAttrs (brewSrc != null) {
  homebrew-tahoe = pkgs.callPackage ./homebrew-tahoe.nix { inherit brewSrc; };
}
