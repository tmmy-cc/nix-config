{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    #clang-tools
    cmake
    gcc13
    #clang_18
  ];
}
