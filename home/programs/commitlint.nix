{ config, lib, pkgs, ... }:

let
  configPath = pkgs.writeText "commitlint.yaml" ''
    version: v0.10.1
    formatter: default
    rules:
    - header-min-length
    - header-max-length
    - body-max-line-length
    - footer-max-line-length
    - type-enum
    severity:
      default: error
    settings:
      body-max-length:
        argument: -1
      body-max-line-length:
        argument: 100
      body-min-length:
        argument: 0
      description-max-length:
        argument: -1
      description-min-length:
        argument: 0
      footer-enum:
        argument: []
      footer-max-length:
        argument: -1
      footer-max-line-length:
        argument: 72
      footer-min-length:
        argument: 0
      footer-type-enum:
        argument: []
      header-max-length:
        argument: 72
      header-min-length:
        argument: 10
      scope-charset:
        argument: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/,
      scope-enum:
        argument: []
        flags:
          allow-empty: true
      scope-max-length:
        argument: -1
      scope-min-length:
        argument: 0
      type-charset:
        argument: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
      type-enum:
        argument:
        - feat
        - fix
        - docs
        - style
        - refactor
        - perf
        - test
        - build
        - ci
        - chore
        - revert
      type-max-length:
        argument: -1
      type-min-length:
        argument: 0
  '';
in
{
  home.packages = with pkgs; [
    commitlint
  ];

  home.sessionVariables = {
    COMMITLINT_CONFIG = configPath;
  };
}
