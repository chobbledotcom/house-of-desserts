{
  outputs = { self }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = import <nixpkgs> { };
          pnpmScripts = pkgs.symlinkJoin {
            name = "pnpm-scripts";
            paths = map (cmd: pkgs.writeShellScriptBin cmd "pnpm run ${cmd}") [
              "serve"
              "build"
              "update-pages"
              "fetch-google-reviews"
              "clean"
            ];
          };
        in
        pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_24
            pkgs.pnpm
            pnpmScripts
            pkgs.pandoc
          ];
          shellHook = ''
            cat <<EOF

            Available commands:
             serve               - Start development server
             build               - Build the project
             update-pages        - Update pages
             fetch-google-reviews - Fetch Google Maps reviews
             clean               - Clean build directory

            EOF
            git pull
          '';
        };
    };
}