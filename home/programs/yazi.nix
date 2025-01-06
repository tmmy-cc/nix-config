{ config, lib, pkgs, ... }:

{
  # Enable yazi
  programs.yazi = {
    enable = true;
  };
}
