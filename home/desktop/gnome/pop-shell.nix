{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.pop-shell
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = true;
      fullscreen-launcher = true;
      gap-inner = 2;
      gap-outer = 2;
      mouse-cursor-focus-location = 1;
      show-skip-taskbar = false;
      show-title = false;
      tile-by-default = true;
    };
  };
}
