{
  stdenv,
  writeShellScriptBin,
  nixos-rebuild,
}:
if stdenv.hostPlatform.isDarwin then
  # Remote Linux rebuilds retain the macOS-compatible local launcher.
  writeShellScriptBin "nixos-rebuild" ''
    export _NIXOS_REBUILD_REEXEC=1
    exec ${nixos-rebuild}/bin/nixos-rebuild "$@"
  ''
else
  nixos-rebuild
