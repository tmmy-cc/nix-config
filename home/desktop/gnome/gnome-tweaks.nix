{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.gnome-tweaks
  ];
}
