{ config, lib, ... }:
let
  hostMacOSVersion = config.nix.linux-builder.hostMacOSVersion;
in
{
  options.nix.linux-builder.hostMacOSVersion = lib.mkOption {
    type = lib.types.str;
    example = "15.7.3";
    description = "Target macOS version used to select the Rosetta-compatible guest kernel.";
  };

  config.nix.linux-builder.config =
    { pkgs, ... }:
    {
      # Rosetta on Sequoia 15.5 and later requires a guest kernel older than Linux 6.13.
      boot.kernelPackages = lib.mkIf (
        lib.versionAtLeast hostMacOSVersion "15.5" && lib.versionOlder hostMacOSVersion "26"
      ) pkgs.linuxPackages_6_12;
    };
}
