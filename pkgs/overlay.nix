inputs: final: prev:
let inherit (final) callPackage;
in
{
  commitlint = callPackage ./commitlint/package.nix { };
}
