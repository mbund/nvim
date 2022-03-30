{
  description = "Neovim IDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-code-action-menu = { url = "github:weilbith/nvim-code-action-menu"; flake = false; };
    startup-nvim = { url = "github:startup-nvim/startup.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-overlay.overlay
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
        packages.nvim = neovimBuilder {
          package = pkgs.neovim-nightly;
          customLua = builtins.readFile ./init.lua;
          dir = ./.;
          extraPackages = with pkgs; [
            neovim-remote
            (tree-sitter.withPlugins (p: builtins.attrValues p)) # activiate all tree-sitter languages
            gcc # a c compiler is required for treesitter
            xclip
            ripgrep # required for telescope
            fd # required for telescope
          ];
          start =
            let
              externalPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
            in
            with pkgs.vimPlugins;
            [
              # dependencies
              plenary-nvim
              popup-nvim
              nvim-web-devicons

              # UI
              onedark-vim
              tokyonight-nvim
              (externalPlugin { pname = "startup-nvim"; version = "master"; src = inputs.startup-nvim; })
              bufferline-nvim
              nvim-tree-lua
              telescope-nvim
              telescope-fzf-native-nvim
              telescope-file-browser-nvim
              harpoon
              (externalPlugin { pname = "nvim-code-action-menu"; version = "master"; src = inputs.nvim-code-action-menu; })
              (externalPlugin { pname = "nvim-lightbulb"; version = "master"; src = inputs.nvim-lightbulb; })
              lsp_signature-nvim
              vim-hexokinase
              nvim-cursorline
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
              nvim-lsputils
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

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            sumneko-lua-language-server
            stylua
            lua53Packages.luacheck
            rnix-lsp
          ];
        };

        overlay = (self: super: {
          inherit neovimBuilder;
          neovimMB = packages.nvim;
        });
      }
    );
}
