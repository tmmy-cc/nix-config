{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Enable git
  programs.git = {
    enable = true;
    userName = "Thomas Stahl";
    userEmail = "me@tmmy.cc";
  };

  home.packages = with pkgs; [
    neofetch

    zip
    xz
    unzip
    p7zip

    mtr
    iperf3
    dnsutils
    ldns
    socat
    nmap
    ipcalc

    file
    which
    tree
    gawk
    gnutar
    gnused
    gnupg

    hugo
    glow
    ripgrep
    fzf
  ];

  imports = [
    ../../programs/btop.nix
    ../../programs/eza.nix
    ../../programs/neovim.nix
    ../../programs/starship.nix
    ../../programs/tmux.nix
    ../../programs/zsh.nix
  ];
}
