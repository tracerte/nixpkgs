self: super:
with super;
{
  st = st.overrideAttrs (old: {
    src = ./st;
  }
  );
}
