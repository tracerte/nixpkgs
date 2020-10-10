self: super:

with super;
let
  my_src = ./dwm;
in
{
  dwm = dwm.overrideAttrs (old: {
    src = my_src;
  }
  );
}
