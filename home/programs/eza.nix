{ config, lib, pkgs, ... }:

{
  # Enable eza
  programs.eza= {
    enable = true;
    enableZshIntegration = true;
  };
}
