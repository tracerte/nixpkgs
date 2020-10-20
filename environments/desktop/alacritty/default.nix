{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;

let 
  color-scheme = gruvbox-dark;
  gruvbox-dark = (builtins.readFile ./schemes/gruvbox-dark.yml);
  gruvbox-light = (builtins.readFile ./schemes/gruvbox-light.yml);
  font = (builtins.readFile ./font/configuration.yml);
in
  writeText "alacritty.yml" ( ''
    # Background opacity
    #
    # Window opacity as a floating point number from `0.0` to `1.0`.
    # The value `0.0` is completely transparent and `1.0` is opaque.
    background_opacity: 0.9
    '' + "\n" + font + "\n" + color-scheme )
