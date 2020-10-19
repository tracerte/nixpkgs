self: super:
with super;
let
  plugins = vimPlugins // callPackage ./plugins.nix {};
in
{
   neovim= neovim.override {
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
        vim-lsp-cxx-highlight
      ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [ ];
      # To automatically load a plugin when opening a filetype, add vimrc lines like:
      # autocmd FileType php :packadd phpCompletion
      };
    };
  };
}
