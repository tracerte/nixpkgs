{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs;

let
  snazzy = (builtins.readFile ./xresources-themes/snazzy);
  gruvbox-dark = (builtins.readFile ./xresources-themes/gruvbox-dark);
  gruvbox-light = (builtins.readFile ./xresources-themes/gruvbox-light);
  color-theme = gruvbox-dark;
in
writeText "Xresources" (''
  st.opacity: 0.95
  st.font: MesloLGS NF-7
''
+ "\n" + color-theme )
