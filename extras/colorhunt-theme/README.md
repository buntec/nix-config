# Color Hunt theme generator

Generate matching light and dark Base16 and Base24 YAML schemes from the four colors encoded in a
[Color Hunt](https://colorhunt.co/) palette slug. Color calculations, OKLCH interpolation, contrast checks, and
sRGB gamut mapping use [Color.js](https://colorjs.io/).

## Usage

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
