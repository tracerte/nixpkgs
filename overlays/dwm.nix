self: super:

with super;

let
  my_src = ./dwm;
in
  {
    dwm = dwm.overrideAttrs ( old: {
      name = "dwm-tracerte";
      src=my_src;
    }
    );
  }
