self: super: {
  achilles = self.buildEnv {
    name = "achilles-desktop";
    paths = with self.pkgs;
    let
      environments = import ../environments;
      neovimEnv = import environments.neovim {};
      devEnv = import environments.developer {};
      terminalEnv = import environments.terminal {};
      desktopEnv = import environments.desktop {
        monitorAssignment = ''nvidia-settings --assign CurrentMetaMode="DP-4: nvidia-auto-select +1920+0, DP-3.1: nvidia-auto-select +1920+0, DP-3.2: nvidia-auto-select +0+0, DP-3.3: nvidia-auto-select +3840+0"'';
      };
      files =  devEnv.files // desktopEnv.files // terminalEnv.files // neovimEnv.files; 
      symHome = self.callPackage ../symHome {nixpkgs = pkgs.pkgs; inherit files;};
      systemdfiles = import ../systemdfiles pkgs.pkgs;
      fonts = import ../fonts pkgs.pkgs;
    in
      [
        systemdfiles
        fonts
        neovimEnv.env
        devEnv.env
        desktopEnv.env
        terminalEnv.env
        onedrive
        gocryptfs
        htop
        symHome
      ];
  };
}
