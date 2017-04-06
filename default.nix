{ callPackage
, lib
, # | The exec builtin or plugin
  #
  # This is passed as an argument so that all of the expressions in
  # nixpkgs can be automatically verified to be safe to evaluate with
  # allow-unsafe-native-code-during-evaluation on: You have to
  # actually pass in `exec` yourself if you want to do anything with
  # it.
  exec
}:
  let files = builtins.attrNames (builtins.readDir ./.);
      blacklist =
        [ "README.md" "LICENSE" ".git" "default.nix" "test.nix"
          "exec-bootstrap.nix" ".gitignore"
        ];
      expressions =
        builtins.filter (file: !builtins.elem file blacklist) files;
  in
    builtins.listToAttrs (map (expr:
      { name = lib.removeSuffix ".nix" expr;
        value = callPackage (import (./. + "/${expr}") exec) {};
      }) expressions)
