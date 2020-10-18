self: super: 
let
  plugins = self.vimPlugins // self.callPackage ./plugins.nix {};
in
{
  neovimEnv = self.buildEnv {
    name = "neovimEnv";
    paths = with self.pkgs; [ nodejs ];
  };
  neovim = super.neovim.override {
    vimAlias = true;
    viAlias = true;
    configure = {
      customRC = builtins.readFile ./vimrc;
      packages.myVimPackages = {
      # loaded on launch
      start = with plugins; [ 
        vim-sensible 
        vim-nix 
        coc-nvim 
        ale
      ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [ ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
      };
    };
  };
}
