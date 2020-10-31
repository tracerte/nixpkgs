self: super: {
  achilles = self.buildEnv {
    name = "achilles-desktop";
    paths = with self.pkgs;
    let
      lpkgs = import ../all-packages.nix;
      zsh = import lpkgs.zsh {};
      emacs = import lpkgs.emacs {};
      direnv = import lpkgs.direnv {};
      git = import lpkgs.git {};
      xsession = import lpkgs.xsession {
      monitorAssignment = ''nvidia-settings --assign CurrentMetaMode="DP-4: nvidia-auto-select +0+1080, DP-3.1: nvidia-auto-select +1920+0, DP-3.2: nvidia-auto-select +0+0, DP-3.3: nvidia-auto-select +3840+0"'';
      };
      mpd = import lpkgs.mpd {music_directory = "~/OneDrive/Music";};
      alacritty = import lpkgs.alacritty {};
      onedrive = import lpkgs.onedrive {};
      files =  zsh.files // emacs.files // direnv.files // git.files // xsession.files // mpd.files // alacritty.files // onedrive.files; 
      services = zsh.services // emacs.services // direnv.services // git.services // xsession.services // mpd.services // alacritty.services // onedrive.services;  
      fonts = zsh.fonts // emacs.fonts // direnv.fonts // git.fonts // xsession.fonts // mpd.fonts // alacritty.fonts // onedrive.fonts; 
      homenid = import lpkgs.homenid {nixpkgs = pkgs.pkgs; inherit files services fonts;};
    in
      [
        zsh.env
        emacs.env
        direnv.env
        git.env
        xsession.env
        mpd.env
        alacritty.env
        onedrive.env
        tmux
        zip
        unzip
        htop
        homenid
        pcmanfm
        firefox
        chromium
        libreoffice-fresh
        hunspell
        hunspellDicts.en-us
        pavucontrol
      ];
  };
}
