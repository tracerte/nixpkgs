{ pkgs, ... }:

{
  vim-lsp-cxx-highlight = pkgs.vimUtils.buildVimPlugin {
    name = "vim-lsp-cxx-highlight";
    src = pkgs.fetchFromGitHub {
      owner = "jackguo380";
      repo = "vim-lsp-cxx-highlight";
      rev = "7c47d39d808118f0ef030b15db28ff3995d91cb6";
      sha256 = "0yiyxfhicqhhpp83ilknngr8l9r8z9bchkn3xd2ri8bx0bm7i4l7";
    };
  };

}
