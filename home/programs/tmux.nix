{ config, lib, pkgs, ... }:

{
  # Enable tmux
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 50000;
    mouse = true;
  };
}
