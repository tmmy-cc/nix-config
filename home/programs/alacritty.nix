{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty-theme
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
  ];

  # Enable font config
  fonts.fontconfig.enable = lib.mkDefault true;

  # Enable alacritty
  programs.alacritty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.alacritty);
    settings = {
      general.import = [ "${pkgs.alacritty-theme.outPath}/tokyo_night.toml" ];
      env.TERM = "xterm-256color";
      window.padding = {
        x = 10;
        y = 10;
      };
      window = {
        #decorations = "none";
        opacity = 0.7;
        blur = true;
        dynamic_title = true;
      };
      scrolling.history = 1000;
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        size = (if pkgs.stdenv.isDarwin then 14 else 11);
      };
      selection.save_to_clipboard = true;
    };
  };
}
