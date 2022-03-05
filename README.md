# nvim
Personal neovim setup as a fully featured IDE

## Installation and usage
Add this repository as an input to your flake, and use its
default package. It would look something like this:
```nix
{
  inputs.nvim.url = "github:mbund/nvim";
  # ...
  outputs = { ... }@inputs: {
    # now add this inside your home.packages = [] or environment.systemPackages = []
    inputs.nvim.defaultPackage.${pkgs.system}
  };
}
```

Or you can run it directly without installation with
```
nix run github:mbund/nvim
```

## Supported languages
These languages have integration into this neovim configuration,
if you have the appropriate packages installed. The package names
are what they are in `nixpkgs`, and I would recommend that you
add them as dependencies in your nix development shell for each
individual project.

### lua
sumneko-lua-language-server
stylua
lua53Packages.luacheck

### nix
rnix-lsp

### haskell
haskell-language-server
haskellPackages.fourmolu

### rust
rust-analyzer
rustfmt

### python
python39Packages.autopep8
python39Packages.flake8
nodePackages.pyright

### javascript/typescript
nodePackages.eslint_d

### c/c++
clang
clang-tools
cppcheck

