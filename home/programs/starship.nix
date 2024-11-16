{ config, lib, pkgs, ... }:

{
  # Enable starship.rs
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      aws.disabled = true;

      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };
}
