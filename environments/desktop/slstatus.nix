self: super:

with super;

{
  slstatus = slstatus.override {
    conf = builtins.readFile ./slstatus/config.h;
  };
}
