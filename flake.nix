{
  description = "YorikSar's resume";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils}: 
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      makeScripts = attrs: builtins.mapAttrs (name: value: {
        type = "app";
        program = "${pkgs.writeShellScriptBin name value}/bin/${name}";
      }) attrs;
      git = "${pkgs.git}/bin/git";
    in rec {
      defaultApp = apps.page;
      apps = makeScripts rec {
        worktree = "[ -d .html ] || ${git} worktree add .html gh-pages";
        page = "${worktree}; ${pkgs.docutils}/bin/rst2html.py resume.rst .html/index.html";
        commit-page = ''
          ${page}
	      cd .html
          if [ "$$(${git} status -s)" ]; then
              ${git} commit -am "Update to master branch"
          fi
        '';
      };
    });
}
