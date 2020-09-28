self: super: {
  desktop = self.buildEnv {
    name = "desktop";
    paths = with self.pkgs; [
      xorg.xev
      xorg.xbacklight
      dwm
      dmenu
      slstatus
      nnn
      picom
      st
      dvtm
      abduco
      pcmanfm
      zip
      unzip
      firefox
      libreoffice-fresh
      onedrive
      gocryptfs
      neovim
      htop
      gitAndTools.gitFull
    ];
  };
}
