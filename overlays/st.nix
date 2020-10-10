self: super:

with super;
let
  my_src = ./st;
in
{
  st = st.overrideAttrs (old: {
    src = my_src;
  }
  );
}
