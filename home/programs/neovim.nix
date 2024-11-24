{ config, lib, pkgs, ... }:

let
  treesitterWithGrammars = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
    bash
    comment
    css
    dockerfile
    #fish
    gitattributes
    gitignore
    go
    gomod
    gowork
    hcl
    javascript
    #jq
    json5
    json
    lua
    make
    markdown
    nix
    python
    rust
    toml
    #typescript
    #vue
    yaml
  ]));

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = treesitterWithGrammars.dependencies;
  };

in
{
  home.packages = with pkgs; [
    ripgrep
    fd
    lua-language-server
    vscode-langservers-extracted
    nil
    clang-tools
    marksman
    python311Packages.python-lsp-server
    dockerfile-language-server-nodejs
    docker-compose-language-service
    yaml-language-server
    rust-analyzer-unwrapped
    black
    nodejs_22
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    coc.enable = false;
    withNodeJs = true;
    plugins = [
      treesitterWithGrammars
    ];
  };

  home.file."./.config/nvim/" = {
    source = ../../dotconfig/nvim;
    recursive = true;
  };

  # Treesitter is configured as a locally developed module in lazy.nvim
  # we hardcode a symlink here so that we can refer to it in our lazy config
  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    recursive = true;
    source = treesitterWithGrammars;
  };
}
