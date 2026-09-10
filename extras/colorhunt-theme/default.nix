{
  lib,
  buildNpmPackage,
  runCommand,
}:
slug:
assert lib.assertMsg (
  builtins.match "[0-9a-fA-F]{24}" slug != null
) "Color Hunt slugs must contain exactly 24 hexadecimal characters";
let
  normalizedSlug = lib.toLower slug;
  name = "color-hunt-${normalizedSlug}";
  generator = buildNpmPackage {
    pname = "colorhunt-theme";
    version = "0.1.0";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./package.json
        ./package-lock.json
        ./cli.js
        ./theme.js
        ./preview.js
        ./theme.test.js
      ];
    };
    npmDepsHash = "sha256-vjM3TamYmA7b0FE7OFTVIV17fdfGpUo0BH18uFyCsdM=";
    dontNpmBuild = true;
    doCheck = true;
    checkPhase = ''
      runHook preCheck
      npm test
      runHook postCheck
    '';
  };
  themes =
    runCommand name
      {
        nativeBuildInputs = [ generator ];
        passthru = {
          base16 = lib.genAttrs [ "light" "dark" ] (mode: "${themes}/base16/${name}-${mode}.yaml");
          base24 = lib.genAttrs [ "light" "dark" ] (mode: "${themes}/base24/${name}-${mode}.yaml");
          preview = "${themes}/${name}.html";
        };
      }
      ''
        colorhunt-theme ${lib.escapeShellArg normalizedSlug} --output "$out"
      '';
in
themes
