# : Path -> [ Path ]
# | Get a list of paths in a git repo that are ignored by that repo's
# .gitignore
exec: { git, writeScriptBin, bash, coreutils, findutils }:
  let script = writeScriptBin "git-ignored-files"
        ''
          #!${bash}/bin/bash -e
          root="$1"
          if [ -d "$root" ]
          then
            cd "$root"
          else
            cd "$(${coreutils}/bin/dirname "$root")"
          fi
          echo "["
          ${findutils}/bin/find "$root" | \
            ${git}/bin/git check-ignore --stdin
	  echo "]"
        '';
  in root: exec [ "${script}/bin/git-ignored-files" root ]
