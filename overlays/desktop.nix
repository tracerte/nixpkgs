self: super: {
  desktop = self.buildEnv {
    name = "desktop";
    paths = with self.pkgs; 
     let        
       dotfiles = import ../dotfiles pkgs.pkgs;
       fonts = import ../fonts pkgs.pkgs;
     in [
      dotfiles
      fonts
      xorg.xev
      xorg.xbacklight
      feh
      dwm
      dmenu
      slstatus
      lf
      picom
      st
      rxvt-unicode
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
