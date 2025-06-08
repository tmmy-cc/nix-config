{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
  ];

  dconf.settings = {
    "org/gnome/shell/extensions/blur-my-shell" = {
      "blacklist"="@as []";
      "blur-on-overview"=false;
      "brightness"="1.0";
      "customize"=true;
      "enable-all"=true;
      "opacity"="250";
      "sigma"="59";
      "blur"=true;
    };
  };
}

