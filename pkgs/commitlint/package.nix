{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "commitlint";
  version = "0.10.1";

  commit_revision = "e9a606ce7074ac884ea091765be1651be18356d4";

  src = fetchFromGitHub {
    owner = "conventionalcommit";
    repo = "commitlint";
    rev = "v${version}";
    hash = "sha256-OJCK6GEfs/pcorIcKjylBhdMt+lAzsBgBVUmdLfcJR0=";
  };

  vendorHash = "sha256-4fV75e1Wqxsib0g31+scwM4DYuOOrHpRgavCOGurjT8=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Command line utility that checks if your commit message meets the conventional commit format";
    homepage = "https://github.com/conventionalcommit/commitlint";
    license = licenses.mit;
    #maintainers = with maintainers; [ tmmy ];
    mainProgram = "commitlint";
  };
}
