{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib) mkIf hm;
  # 收集當前使用者環境安裝的所有 packages
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = [ "/Applications" ];
  };
in
{
  # 僅在 darwin (macOS) 環境生效
  config = mkIf pkgs.stdenv.hostPlatform.isDarwin {
    home.extraActivationPath = [ pkgs.rsync ];

    # 在 Home Manager activation 階段執行同步與建立替身
    home.activation.copyApplications = hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Setting up ~/Applications for Spotlight/Raycast indexing..."
      $DRY_RUN_CMD rm -rf "$HOME/Applications/Home Manager Apps"
      $DRY_RUN_CMD mkdir -p "$HOME/Applications/Home Manager Apps"

      # 遍歷 Nix store 中的所有 .app
      if [ -d "${apps}/Applications" ]; then
        for app in "${apps}/Applications/"*.app; do
          if [ -e "$app" ]; then
            appName="$(basename "$app")"
            targetDir="$HOME/Applications/Home Manager Apps/$appName"
            
            # 使用 osascript 製作 Finder 替身 (Alias) 供 Spotlight 索引
            $DRY_RUN_CMD osascript -e "tell application \"Finder\" to make alias file to (POSIX file \"$app\") at (POSIX file \"$HOME/Applications/Home Manager Apps\")" 2>/dev/null || true
          fi
        done
      fi
    '';
  };
}
