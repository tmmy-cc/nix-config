{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-history-substring-search
  ];

  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      HISTORY_SUBSTRING_SEARCH_PREFIXED=1
      HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

      bindkey '^[OA' history-substring-search-up    # Up
      bindkey '^[[A' history-substring-search-up    # Up
      bindkey '^[OB' history-substring-search-down  # Down
      bindkey '^[[B' history-substring-search-down  # Down

      bindkey '^[[1;5C' forward-word                # C-Right
      bindkey '^[0c'    forward-word                # C-Right
      bindkey '^[[5C'   forward-word                # C-Right

      bindkey '^[[1;5D' backward-word               # C-Left
      bindkey '^[0d'    backward-word               # C-Left
      bindkey '^[[5D'   backward-word               # C-Left
    '';
  };
}
