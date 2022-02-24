{
  description = "Neovim IDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";


  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-nightly-overlay.overlay
          ];
        };

        neovimBuilder =
          { package
          , customLua ? ""
          , dir
          , extraPackages ? [ ]
          , start ? builtins.attrValues pkgs.neovimPlugins
          , opt ? [ ]
          }:
          let
            neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
              configure = {
                customRC = ''
                  " add our derivation's project root so we can use our lua
                  set runtimepath^=${dir}

                  lua << EOF
                    ${customLua}
                  EOF
                '';
                packages.myVimPackage = with pkgs.neovimPlugins; {
                  start = start;
                  opt = opt;
                };
              };
            };

            extraMakeWrapperArgs = pkgs.lib.optionalString (extraPackages != [ ])
              ''--suffix PATH : "${pkgs.lib.makeBinPath extraPackages}"'';
          in
          pkgs.wrapNeovimUnstable package (neovimConfig // {
            wrapperArgs = (pkgs.lib.escapeShellArgs neovimConfig.wrapperArgs) + " "
              + extraMakeWrapperArgs;
            wrapRC = false;
          });

      in
      rec {
        packages.nvim = neovimBuilder
          {
            package = pkgs.neovim-nightly;
            customLua = builtins.readFile ./init.lua;
            dir = ./.;
            extraPackages = with pkgs; [
              neovim-remote
              (tree-sitter.withPlugins (p: builtins.attrValues p)) # activiate all tree-sitter languages
              xclip
              ripgrep # required for telescope
              fd # required for telescope

              rnix-lsp
              haskell-language-server
              rust-analyzer
              nodePackages.bash-language-server
              nodePackages.typescript-language-server
              nodePackages.vim-language-server

              python39Packages.autopep8
              python39Packages.flake8
              nodePackages.pyright
              rustfmt
              nodePackages.eslint_d
              stylua
              clang
              clang-tools
              cppcheck
              lua53Packages.luacheck
              haskellPackages.fourmolu
            ];
            start = with pkgs.vimPlugins;
              [
                # dependencies
                plenary-nvim
                popup-nvim
                nvim-web-devicons

                # UI
                onedark-vim
                bufferline-nvim
                nvim-tree-lua
                telescope-nvim
                telescope-fzf-native-nvim
                telescope-file-browser-nvim
                # harpoon
                nvim-code-action-menu
                lsp_signature-nvim
                nvim-lightbulb
                vim-hexokinase
                nvim-treesitter
                nvim-treesitter-context
                gitsigns-nvim
                lualine-nvim
                trouble-nvim

                # motions, remaps, text-editing improvements
                vim-sneak
                vim-commentary
                vim-indent-object
                vim-textobj-user
                vim-sort-motion
                vim-exchange
                vim-unimpaired
                vim-surround
                vim-repeat
                nvim-autopairs
                vim-sleuth

                # completion
                nvim-cmp
                cmp-buffer
                luasnip
                cmp_luasnip
                lspkind-nvim
                cmp-path
                cmp-treesitter

                # lsp
                nvim-lspconfig
                null-ls-nvim
                cmp-nvim-lsp

                # rust
                crates-nvim
                rust-tools-nvim

                # web development
                nvim-ts-autotag

              ];
          };

        apps.nvim = { type = "app"; program = "${packages.nvim}/bin/nvim"; };

        defaultPackage = packages.nvim;
        defaultApp = apps.nvim;
      }
    );
}
