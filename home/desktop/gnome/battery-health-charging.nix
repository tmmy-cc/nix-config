{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.battery-health-charging
  ];
}
