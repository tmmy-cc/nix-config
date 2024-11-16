{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc13
  ];
}
