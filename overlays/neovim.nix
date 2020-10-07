self: super: {
  neovim = super.neovim.override {
    vimAlias = true;
    viAlias = true;
    configure = {
      packages.myVimPackages = with super.vimPlugins; {
        start = [ vim-nix vim-sensible ];
      };
    };
  };
}
