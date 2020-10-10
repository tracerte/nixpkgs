self: super: {
  desktop = self.buildEnv {
    name = "desktop";
    paths = with self.pkgs;
      let
        dotfiles = import ../dotfiles pkgs.pkgs;
        systemdfiles = import ../systemdfiles pkgs.pkgs;
        fonts = import ../fonts pkgs.pkgs;
      in
      [
        dotfiles
        systemdfiles
        fonts
        xorg.xev
        xorg.xbacklight
        neovim
        neovim-qt
        nmap
        feh
        dwm
        dunst
        libnotify
        dmenu
        slstatus
        lf
        picom
        st
        tmux
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
