self: super:

with super;
let
  my_src = ./st;
in
{
  st = st.overrideAttrs (old: {
    name = "st-tracerte";
    src = my_src;
  }
  );
}
