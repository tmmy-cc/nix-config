{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.blur-my-shell
  ];
}
