{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden
  ];
}
