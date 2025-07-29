{
  description = "Funny Instructions";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = { nixpkgs, utils, hooks, ... }:
    utils.lib.eachDefaultSystem
      (system:
        let

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          baseInputs = with pkgs; [
            pkg-config
            openssl
            openssl.dev
          ];

          devInputs = with pkgs; [
            semgrep
            jq
            ragenix
            docker-compose
          ];

          specificSystemInputs = with pkgs;
            (if stdenv.isDarwin then [
              darwin.apple_sdk.frameworks.Security
              darwin.apple_sdk.frameworks.SystemConfiguration
              libiconv
            ] else if stdenv.isLinux then [
              fd
            ] else [ ]);

          formatting = hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              deadnix.enable = true;
              statix.enable = true;
              markdownlint = {
                enable = true;
                settings = {
                  configuration = {
                    default = true;
                    #MD013 = {
                    #  strict = false;
                    #  stern = false;
                    #};
                    MD013 = false;
                    #MD047 = false;
                    MD024 = false;
                    MD033 = false;
                    MD041 = false;
                    MD022 = false;
                  };
                };
              };
              shellcheck.enable = true;
              typos = {
                enable = true;
                pass_filenames = false;
                settings.configPath = ".typos.toml";
              };
              yamllint.enable = true;
              yamlfmt.enable = true;
              # trufflehog.enable = true;
              ripsecrets.enable = true;
              hadolint.enable = true;
              editorconfig-checker.enable = true;
            };
          };
          # Mostly to allow people to run directly the tools
          check-tools = with pkgs; [
            deadnix
            markdownlint-cli
            nixpkgs-fmt
            statix
            typos
            yamlfmt
            yamllint
            shellcheck
            trufflehog
            ripsecrets
            hadolint
            editorconfig-checker
            convco
          ];


        in
        {
          checks = {
            inherit formatting;
          };
          packages = { };
          devShells.default = with pkgs; mkShell {
            name = "private";
            buildInputs = baseInputs ++ devInputs ++ specificSystemInputs ++ check-tools;

            shellHook = ''
              echo "Agenix development environment loaded!"
              echo "Available commands:"
              echo "  agenix -e instructions.age -i ~/.ssh/your-key # Edit encrypted file"
              echo "  agenix -r -i ~/.ssh/your-key # Rekey all secrets"
              echo ""
              echo ""
            '';

            DONT_PROMPT_WSL_INSTALL = "nope";
          };
        }
      );
}
