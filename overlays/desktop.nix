self: super: {
  desktop = self.buildEnv {
    name = "desktop";
    paths = with self.pkgs;
      let
        df =  {
          ".zshrc" = import ../dotfiles/zshrc.nix pkgs.pkgs;
          ".zshenv" = ../dotfiles/zshenv;
          ".p10k.zsh" = ../dotfiles/p10k.zsh;
          ".gitconfig" = ../dotfiles/gitconfig;
          ".Xresources" = ../dotfiles/Xresources;
          ".xsession" = import ../dotfiles/xsession.nix {
            pkgs = pkgs.pkgs; 
            monitorAssignment = ''nvidia-settings --assign CurrentMetaMode="DP-4: nvidia-auto-select +1920+0, DP-3.1: nvidia-auto-select +1920+0, DP-3.2: nvidia-auto-select +0+0, DP-3.3: nvidia-auto-select +3840+0"'';
          };
          ".config/dunst/dunstrc" = ../dotfiles/dunstrc;
          ".direnvrc" = ../dotfiles/direnvrc;
        };
        dotfiles = import ../dotfiles {pkgs = pkgs.pkgs; files = df;};
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
        neovimEnv
        neovim-qt
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
        hunspell
        hunspellDicts.en-us
        libreoffice-fresh
        onedrive
        gocryptfs
        neovim
        direnv
        nix-direnv
        niv
        htop
        gitAndTools.gitFull
      ];
  };
}
