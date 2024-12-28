{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    ghostty.default
  ];

  home.sessionVariables = {
    TERM = "ghostty";
  };

  # Enable font config
  fonts.fontconfig.enable = lib.mkDefault true;
}
