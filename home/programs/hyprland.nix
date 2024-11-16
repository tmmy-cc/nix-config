{ config, lib, pkgs, ... }:

{
  # Install hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
    };
  };
}
