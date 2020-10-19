self: super: {
  achilles = self.buildEnv {
    name = "achilles-desktop";
    paths = with self.pkgs;
    let
      neovimEnv = import ../neovimEnv;
      devEnv = import ../devEnv pkgs.pkgs;
      terminalEnv = import ../terminalEnv pkgs.pkgs;
      desktopNvidia = import ../desktopEnv {
        pkgs = pkgs.pkgs; 
        monitorAssignment = ''nvidia-settings --assign CurrentMetaMode="DP-4: nvidia-auto-select +1920+0, DP-3.1: nvidia-auto-select +1920+0, DP-3.2: nvidia-auto-select +0+0, DP-3.3: nvidia-auto-select +3840+0"'';
      };
      systemdfiles = import ../systemdfiles pkgs.pkgs;
      fonts = import ../fonts pkgs.pkgs;
    in
      [
        systemdfiles
        fonts
        neovimEnv
        devEnv
        desktopNvidia
        terminalEnv
        onedrive
        gocryptfs
        htop
      ];
  };
}
