let 
  pkgs = import <nixpkgs> {overlays = [ (import ./neovim.nix)];};
in
pkgs.buildEnv {
  name = "neovimEnv";
  paths = with pkgs; [ 
    neovim 
    nodejs 
  ];
}

