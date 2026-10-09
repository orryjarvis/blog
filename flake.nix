{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    zine = {
      url = "https://github.com/kristoff-it/zine/releases/download/v0.14.0/x86_64-linux-musl.tar.xz";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,

      zine,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      zinePackage = pkgs.stdenvNoCC.mkDerivation {
        pname = "zine";
        version = "0.14.0";
        src = zine;
        dontBuild = true;
        dontStrip = true;
        installPhase = ''
          runHook preInstall
          install -Dm755 zine "$out/bin/zine"
          runHook postInstall
        '';
      };
    in
    {
      formatter.${system} = pkgs.nixfmt;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          zinePackage

          nixd
          nixfmt
        ];
      };
    };
}
