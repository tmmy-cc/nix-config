{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    clang_18
  ];
}
