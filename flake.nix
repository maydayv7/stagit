{
  description = "Personal Stagit Fork";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (
      system: with nixpkgs.legacyPackages.${system}; {
        packages.default = stdenv.mkDerivation {
          pname = "stagit";
          version = "1.2-custom";
          src = ./.;

          buildInputs = [
            libgit2
            md4c
          ];

          nativeBuildInputs = [
            pkg-config
            makeWrapper
          ];

          buildPhase = ''
            make PREFIX=$out \
              STAGIT_CFLAGS="-I${libgit2}/include -I${md4c}/include" \
              STAGIT_LDFLAGS="-L${libgit2}/lib -lgit2 -L${md4c}/lib -lmd4c -lmd4c-html"
          '';

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/doc/stagit
            cp stagit $out/bin/
            cp stagit-index $out/bin/
            cp favicon.png $out/share/doc/stagit/
            wrapProgram $out/bin/stagit --prefix PATH : ${lib.makeBinPath [ chroma ]}
          '';
        };
      }
    );
}
