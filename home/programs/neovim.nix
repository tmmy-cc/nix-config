{ config, lib, pkgs, ... }:

let
  configPath = "${config.home.homeDirectory}/nix-config/dotconfig/nvim/";
in
{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    # LSPs
    lua-language-server
    vscode-langservers-extracted
    clang-tools
    python311Packages.python-lsp-server
    rust-analyzer-unwrapped
    yaml-language-server
    nil
    #marksman
    #dockerfile-language-server-nodejs
    #docker-compose-language-service
    #black
    #nodejs_22
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.file."./.config/nvim/".source = config.lib.file.mkOutOfStoreSymlink configPath;
}
