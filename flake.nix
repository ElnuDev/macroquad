/*
TODO
1. Find and replace "helloworld" with your package name for **ALL FILES IN REPOSITORY**
2. Add a flake description that describes the workspace on line 27
3. Add a package description on line 70
4. (optional) uncomment `nativeBuildInputs` and `buildInputs` on lines 43 and 44 if you need openssl
5. (optional) set your project homepage, license, and maintainers list on lines 48-51
6. (optional) uncomment the NixOS module and update it for your needs
7. Delete this comment block
*/

/*
Some utility commands:
- `nix flake update --commit-lock-file`
- `nix flake lock update-input <input>`
- `nix build .#helloworld` or `nix build .`
- `nix run .#helloworld` or `nix run .`
*/

{
  description = "Cross-platform game engine in Rust.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      overlays = [ (import rust-overlay) ];
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system overlays;
      };
      rustSettings = with pkgs; {
        src = ./.;
        #nativeBuildInputs = [ pkg-config ];
        #buildInputs = [ openssl ];
        cargoHash = nixpkgs.lib.fakeHash;
      };
      meta = with nixpkgs.lib; {
        homepage = "https://macroquad.rs/";
        license = [ licenses.asl20 ];
        platforms = [ system ];
      };
    in {
      devShells.${system}.default = with pkgs; mkShell {
        packages = [
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" ];
          })
          cargo-edit
          bacon
        ];
      };
    };
}
