{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.tailscale
  ] ++ lib.optionals config.services.xserver.desktopManager.gnome.enable [ pkgs.trayscale ];

  services.tailscale.enable = true;
}
