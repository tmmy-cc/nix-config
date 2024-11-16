{ config, lib, pkgs, ... }:

{
  # Enable tmux
  programs.tmux = {
    enable = true;
    mouse = true;
  };
}
