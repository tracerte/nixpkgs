self: super: {
  desktop = self.buildEnv {
    name = "desktop";
    paths = with self.pkgs; 
     let        
       dotfiles = import ../dotfiles pkgs.pkgs;
     in [
      dotfiles
      xorg.xev
      xorg.xbacklight
      feh
      dwm
      dmenu
      slstatus
      lf
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
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];
  };
}
