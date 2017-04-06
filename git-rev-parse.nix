# : Path -> String
# | Get the git revision of the repo containing the input path.
exec: { git, writeScriptBin, bash, coreutils }:
  let script = writeScriptBin "git-rev-parse"
        ''
          #!${bash}/bin/bash -e
          root="$1"
          if [ -d "$root" ]
          then
            cd "$root"
          else
            cd "$(${coreutils}/bin/dirname "$root")"
          fi
          echo \"$(${git}/bin/git rev-parse HEAD)\"
        '';
  in root: exec [ "${script}/bin/git-rev-parse" root ]
