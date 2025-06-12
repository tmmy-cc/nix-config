{ config, lib, pkgs, ... }:

{
  home.file."./Library/KeyBindings/DefaultKeyBinding.dict".source = ./DefaultKeyBinding.dict;
  home.file."./.config/karabiner/karabiner.json".source = ./karabiner.json;
}
