{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.forge
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/forge" = {
      css-last-update = 37;
      tiling-mode-enabled = true;
      window-gap-size-increment = 2;
      workspace-skip-tile = "";
    };
    "org/gnome/shell/extensions/forge/keybindings" = {
      con-split-horizontal = ["<Super>z"];
      con-split-layout-toggle = ["<Super>g"];
      con-split-vertical = ["<Super>v"];
      con-stacked-layout-toggle = ["<Shift><Super>s"];
      con-tabbed-layout-toggle = ["<Shift><Super>t"];
      con-tabbed-showtab-decoration-toggle = ["<Control><Alt>y"];
      focus-border-toggle = ["<Super>x"];
      prefs-tiling-toggle = ["<Control><Super>w"];
      window-focus-down = ["<Super>j"];
      window-focus-left = ["<Super>h"];
      window-focus-right = ["<Super>l"];
      window-focus-up = ["<Super>k"];
      window-gap-size-decrease = ["<Control><Super>minus"];
      window-gap-size-increase = ["<Control><Super>plus"];
      window-move-down = ["<Shift><Super>j"];
      window-move-left = ["<Shift><Super>h"];
      window-move-right = ["<Shift><Super>l"];
      window-move-up = ["<Shift><Super>k"];
      window-resize-bottom-decrease = ["<Shift><Control><Super>i"];
      window-resize-bottom-increase = ["<Control><Super>u"];
      window-resize-left-decrease = ["<Shift><Control><Super>o"];
      window-resize-left-increase = ["<Control><Super>y"];
      window-resize-right-decrease = ["<Shift><Control><Super>y"];
      window-resize-right-increase = ["<Control><Super>o"];
      window-resize-top-decrease = ["<Shift><Control><Super>u"];
      window-resize-top-increase = ["<Control><Super>i"];
      window-snap-center = ["<Control><Alt>c"];
      window-snap-one-third-left = ["<Control><Alt>d"];
      window-snap-one-third-right = ["<Control><Alt>g"];
      window-snap-two-third-left = ["<Control><Alt>e"];
      window-snap-two-third-right = ["<Control><Alt>t"];
      window-swap-down = ["<Control><Super>j"];
      window-swap-last-active = ["<Super>Return"];
      window-swap-left = ["<Control><Super>h"];
      window-swap-right = ["<Control><Super>l"];
      window-swap-up = ["<Control><Super>k"];
      window-toggle-always-float = ["<Shift><Super>c"];
      window-toggle-float = ["<Super>c"];
      workspace-active-tile-toggle = ["<Shift><Super>w"];
    };
  };
}
