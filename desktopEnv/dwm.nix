self: super:

with super;
{
  dwm = dwm.overrideAttrs (old: {
    src = ./dwm;
  }
  );
}
