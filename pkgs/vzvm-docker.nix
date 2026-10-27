{
  lib,
  writeShellApplication,
  coreutils,
  jq,
  vzvmBase,
  dockerStateDirectory,
  dockerDiskSizeMiB,
}:
writeShellApplication {
  name = "vzvm";
  runtimeInputs = [
    coreutils
    jq
  ];
  text = ''
    state_directory=${lib.escapeShellArg dockerStateDirectory}
    docker_disk="$state_directory/docker.img"
    config_file="$state_directory/docker-vzvm.json"

    if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
        exec ${lib.getExe vzvmBase} "$@"
    fi

    mkdir -p "$state_directory"
    if [ ! -e "$docker_disk" ]; then
        truncate -s ${toString dockerDiskSizeMiB}M "$docker_disk"
    fi

    jq --arg disk "$docker_disk" \
        '.disks += [{path: $disk, readOnly: false}]' "$1" > "$config_file"
    exec ${lib.getExe vzvmBase} "$config_file"
  '';
}
