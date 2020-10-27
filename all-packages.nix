with import <nixpkgs>;
{
  alacritty = ./alacritty;
  direnv = ./direnv;
  dunst = ./dunst;
  feh = ./feh;
  git = ./git;
  homenid = fetchTarball {
    url = "https://github.com/tracerte/homenid/archive/f9b8247f31a8aa9740434ed13a43e78caf2ec675.tar.gz";
    sha256 = "1h3682ig9ys6gd5vk42w2v4k6kxsv9d4pif3pj6m2fabxrwb59y5";
  };
  i3 = ./i3;
  mpd = ./mpd;
  neovim = ./neovim;
  onedrive = ./onedrive;
  polybar = ./polybar;
  xresources = ./xresources;
  xsession = ./xsession;
  zsh = ./zsh;
}
