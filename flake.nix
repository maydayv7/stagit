{
  description = "Personal Stagit Fork";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (
          ps: with ps; [
            pygments
            markdown
            pymdown-extensions
          ]
        );
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "stagit";
          version = "1.2-custom";
          src = ./.;
          buildInputs = [ pkgs.libgit2 ];
          nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.makeWrapper
          ];

          buildPhase = ''
            make PREFIX=$out \
              STAGIT_CFLAGS="-I${pkgs.libgit2}/include" \
              STAGIT_LDFLAGS="-L${pkgs.libgit2}/lib -lgit2"
          '';

          installPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/share/doc/stagit

            cp stagit $out/bin/
            cp stagit-index $out/bin/
            cp favicon.png $out/share/doc/stagit/

            cp render.py $out/bin/render
            sed -i "1i #!${pythonEnv}/bin/python3" $out/bin/render
            chmod +x $out/bin/render
            wrapProgram $out/bin/stagit --prefix PATH : "$out/bin"
          '';
        };
      }
    );
}
