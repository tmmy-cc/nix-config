{ config, lib, pkgs, ... }:

{
  # Enable MPV
  programs.mpv = {
    enable = true;
  };
}
