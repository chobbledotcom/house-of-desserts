{
  inputs.nixpkgs.url = "nixpkgs";

  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          npmScripts = pkgs.symlinkJoin {
            name = "npm-scripts";
            paths = map (cmd: pkgs.writeShellScriptBin cmd "npm run ${cmd}") [
              "serve"
              "build"
              "update-pages"
              "fetch-google-reviews"
              "clean"
            ];
          };
        in
        pkgs.mkShell {
          buildInputs = [ pkgs.nodejs_23 npmScripts pkgs.pandoc ];
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