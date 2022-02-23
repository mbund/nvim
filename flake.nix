{
  description = "Neovim IDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    "plugin:gitsigns" = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    "plugin:onedark-vim" = { url = "github:joshdick/onedark.vim"; flake = false; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pluginOverlay = final: prev:
          let
            inherit (prev.vimUtils) buildVimPluginFrom2Nix;
            treesitterGrammars = prev.tree-sitter.withPlugins (_: prev.tree-sitter.allGrammars);
            plugins = builtins.filter
              (s: (builtins.match "plugin:.*" s) != null)
              (builtins.attrNames inputs);
            plugName = input:
              builtins.substring
                (builtins.stringLength "plugin:")
                (builtins.stringLength input)
                input;
            buildPlug = name: buildVimPluginFrom2Nix {
              pname = plugName name;
              version = "master";
              src = builtins.getAttr name inputs;

              # Tree-sitter fails for a variety of lang grammars unless using :TSUpdate
              # For now install imperatively
              #postPatch =
              #  if (name == "nvim-treesitter") then ''
              #    rm -r parser
              #    ln -s ${treesitterGrammars} parser
              #  '' else "";
            };
          in
          {
            neovimPlugins = builtins.listToAttrs (map
              (plugin: {
                name = plugName plugin;
                value = buildPlug plugin;
              })
              plugins);
          };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            pluginOverlay
            inputs.neovim-nightly-overlay.overlay
          ];
        };

        neovimBuilder =
          { package
          , customLua ? ""
          , extraPackages ? [ ]
          , start ? builtins.attrValues pkgs.neovimPlugins
          , opt ? [ ]
          }:
          let
            neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
              configure = {
                customRC = ''
                  " add our derivation's project root so we can use our lua
                  set runtimepath^=${./.}

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
        };

        apps.nvim = { type = "app"; program = "${packages.nvim}/bin/nvim"; };

        defaultPackage = packages.nvim;
        defaultApp = apps.nvim;
      }
    );
}
