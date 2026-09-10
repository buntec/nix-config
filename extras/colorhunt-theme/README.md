# Color Hunt theme generator

Generate matching light and dark Base16 and Base24 YAML schemes from the four colors encoded in a
[Color Hunt](https://colorhunt.co/) palette slug. Color calculations, OKLCH interpolation, contrast checks, and
sRGB gamut mapping use [Color.js](https://colorjs.io/).

## Usage

From Nix, pass a 24-character Color Hunt slug to the utility:

```nix
let
  themes = pkgs.callPackage ./extras/colorhunt-theme { } "007dccffb900d10056b2054c";
in
{
  stylix.base16Scheme = themes.base16.dark;
}
```

The derivation generates both Base16 and Base24 variants and an HTML preview in the Nix store.
Use `themes.base16.light`, `themes.base24.dark`, `themes.base24.light`, or `themes.preview`
to select other outputs. Dependencies are pinned, and generation requires no network access.
Change the slug in `flake.nix` to select a new palette; no generated files need to be committed.
Stylix reads the generated YAML during evaluation, so evaluation can build this derivation
(import from derivation). The flake uses the evaluator's platform with `--impure`, allowing
checks to evaluate other hosts. Pure evaluation falls back to the configuration's build
platform and requires a matching builder.

The generator can also be run directly from this directory:

```console
npm ci
./cli.js ffbe91ffddb0fffce1cfebff --name "Spring Glass"
```

The command writes four theme files and a self-contained HTML preview below `generated/` by default:

```text
generated/
├── spring-glass.html
├── base16/
│   ├── spring-glass-dark.yaml
│   └── spring-glass-light.yaml
└── base24/
    ├── spring-glass-dark.yaml
    └── spring-glass-light.yaml
```

Open `generated/spring-glass.html` in a browser to compare the source colors and all four generated palettes. The
preview has inline styling and no network dependencies.

Use `--output` to select another output root. A full Color Hunt palette URL is accepted in place of the slug.

## Model

The four input colors define a shared palette identity: a weighted hue for tinted neutrals, a chroma profile, and
preferred accent hues. Separate lightness profiles render that identity as light and dark schemes. Semantic accent
hues remain recognizable while being pulled toward the nearest source hue. Every accent is adjusted to reach a
WCAG 2.1 contrast ratio of at least 4.5 against `base00`, then gamut-mapped to sRGB using the CSS Color 4 algorithm.

Run the tests with:

```console
npm test
```
