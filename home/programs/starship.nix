{ config, lib, pkgs, ... }:

{
  # Enable starship.rs
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws.disabled = true;
    };
  };
}
