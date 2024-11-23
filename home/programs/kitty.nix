{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    kitty-themes
    nerdfonts
  ];

  home.sessionVariables = {
    TERM = "kitty";
  };

  # Enable font config
  fonts.fontconfig.enable = lib.mkOptionDefault true;

  # Enable kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    theme = "Tokyo Night";
    settings = {
      hide_window_decorations = false;
      linux_display_server = "x11";
      copy_on_select = true;

      mouse_hide_wait = "2.0";
      window_padding_width = 5;

      dynamic_background_opacity = true;
      background_opacity = "0.95";
      background_blur = 5;
      background = "#000000";
    };
  };
}
