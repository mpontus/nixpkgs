{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree {
          nosql-workbench = pkgs.appimageTools.wrapType2 {
            name = "nosql-workbench";
            src = pkgs.fetchurl {
              url =
                "https://s3.amazonaws.com/nosql-workbench/NoSQL%20Workbench-linux-x86_64-3.3.0.AppImage";
              hash = "sha256-15C4R1gUEQjkENdlEep6l88+QcCx8LYHM2bBKpoPcig=";
            };
          };
          gitAndTools = pkgs.gitAndTools;
        };
        defaultPackage = packages.nosql-workbench;
        apps.nosql-workbench =
          flake-utils.lib.mkApp { drv = packages.nosql-workbench; };
        defaultApp = apps.nosql-workbench;
      });
}
