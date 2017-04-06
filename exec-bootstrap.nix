# | Evaluates to builtins.exec if nix is new enough, otherwise pulls
# in exec from nix-plugins using importNative
{ nix, nixUnstable, nix-plugins }:
  let nix' =
        if builtins.compareVersions builtins.nixVersion "1.11.9" >= 0
          then nixUnstable
          else nix;
      nix-plugins' = nix-plugins.override { nix = nix'; };
      nix-plugins-imported =
        builtins.importNative "${nix-plugins'}/lib/nix-plugins.nixc"
          "initialize";
  in
    builtins.exec or nix-plugins-imported.exec
