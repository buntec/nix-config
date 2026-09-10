import Color from "colorjs.io";

const SEMANTIC_HUES = {
  base08: 25,
  base09: 55,
  base0A: 90,
  base0B: 145,
  base0C: 195,
  base0D: 250,
  base0E: 320,
  base0F: 40,
};

const BRIGHT_BASES = {
  base12: "base08",
  base13: "base0A",
  base14: "base0B",
  base15: "base0C",
  base16: "base0D",
  base17: "base0E",
};

const NEUTRAL_LIGHTNESS = {
  dark: [0.18, 0.24, 0.32, 0.46, 0.61, 0.76, 0.86, 0.94],
  light: [0.98, 0.93, 0.84, 0.62, 0.5, 0.4, 0.3, 0.21],
};

const DEEP_BACKGROUND_LIGHTNESS = {
  dark: [0.12, 0.07],
  light: [0.99, 1],
};

export function parseColorHuntSlug(input) {
  const candidate = input.trim().replace(/^https?:\/\/colorhunt\.co\/palette\//i, "").replace(/\/$/, "");

  if (!/^[0-9a-f]{24}$/i.test(candidate)) {
    throw new Error("expected a Color Hunt slug containing exactly four six-digit hex colors");
  }

  return Array.from({ length: 4 }, (_, index) => `#${candidate.slice(index * 6, index * 6 + 6).toLowerCase()}`);
}

function clamp(value, minimum, maximum) {
  return Math.max(minimum, Math.min(maximum, value));
}

function angularDistance(first, second) {
  return Math.abs(((first - second + 540) % 360) - 180);
}

function interpolateHue(from, to, factor) {
  const difference = ((to - from + 540) % 360) - 180;
  return (from + difference * factor + 360) % 360;
}

function circularMean(entries) {
  let x = 0;
  let y = 0;

  for (const { hue, weight } of entries) {
    const radians = (hue * Math.PI) / 180;
    x += Math.cos(radians) * weight;
    y += Math.sin(radians) * weight;
  }

  return (Math.atan2(y, x) * 180) / Math.PI < 0
    ? (Math.atan2(y, x) * 180) / Math.PI + 360
    : (Math.atan2(y, x) * 180) / Math.PI;
}

function median(values) {
  const sorted = [...values].sort((a, b) => a - b);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2 === 0 ? (sorted[middle - 1] + sorted[middle]) / 2 : sorted[middle];
}

function toOklch(hex) {
  const color = new Color(hex).to("oklch");
  const [lightness, chroma, hue] = color.coords;
  return {
    lightness,
    chroma,
    hue: Number.isFinite(hue) ? hue : 0,
  };
}

function fromOklch(lightness, chroma, hue) {
  return new Color("oklch", [lightness, chroma, hue]);
}

function toSrgb(color) {
  return color.clone().toGamut({ space: "srgb", method: "css" }).to("srgb");
}

export function toHex(color) {
  const [red, green, blue] = toSrgb(color).coords.map((component) =>
    clamp(Math.round(component * 255), 0, 255),
  );
  return `#${[red, green, blue].map((component) => component.toString(16).padStart(2, "0")).join("")}`;
}

function contrast(first, second) {
  return toSrgb(first).contrast(toSrgb(second), "WCAG21");
}

function deriveIdentity(colors) {
  const sources = colors.map(toOklch);
  const chromaticSources = sources.filter(({ chroma }) => chroma >= 0.01);
  const weightedSources = (chromaticSources.length > 0 ? chromaticSources : sources).map(({ hue, chroma }) => ({
    hue,
    weight: Math.max(chroma, 0.01),
  }));
  const sourceChroma = median(sources.map(({ chroma }) => chroma));

  return {
    sources,
    neutralHue: circularMean(weightedSources),
    neutralChroma: clamp(sourceChroma * 0.2, 0.008, 0.028),
    accentChroma: clamp(sourceChroma * 1.05, 0.065, 0.16),
  };
}

function accentFor(identity, semanticHue, variant, bright = false) {
  const source = identity.sources.reduce((closest, candidate) =>
    angularDistance(candidate.hue, semanticHue) < angularDistance(closest.hue, semanticHue) ? candidate : closest,
  );
  const hue = interpolateHue(semanticHue, source.hue, 0.28);
  const sourceInfluence = clamp(source.chroma, identity.accentChroma * 0.7, identity.accentChroma * 1.35);
  const chroma = clamp((identity.accentChroma + sourceInfluence) / 2 * (bright ? 1.12 : 1), 0.055, 0.18);
  const initialLightness = variant === "dark" ? (bright ? 0.84 : 0.76) : bright ? 0.48 : 0.54;
  return fromOklch(initialLightness, chroma, hue);
}

function ensureContrast(color, background, variant, minimum = 4.5) {
  const adjusted = color.to("oklch");
  const direction = variant === "dark" ? 1 : -1;

  for (let attempts = 0; attempts < 80 && contrast(adjusted, background) < minimum; attempts += 1) {
    adjusted.coords[0] = clamp(adjusted.coords[0] + direction * 0.005, 0.25, 0.95);
  }

  return adjusted;
}

function neutral(identity, lightness, index) {
  const centerWeight = 1 - Math.abs(index - 3.5) / 4.5;
  return fromOklch(lightness, identity.neutralChroma * (0.55 + centerWeight * 0.45), identity.neutralHue);
}

function renderVariant(identity, variant, system) {
  const palette = {};
  const neutralRamp = NEUTRAL_LIGHTNESS[variant];

  neutralRamp.forEach((lightness, index) => {
    palette[`base0${index}`] = neutral(identity, lightness, index);
  });

  for (const [slot, hue] of Object.entries(SEMANTIC_HUES)) {
    palette[slot] = ensureContrast(accentFor(identity, hue, variant), palette.base00, variant);
  }

  if (system === "base24") {
    DEEP_BACKGROUND_LIGHTNESS[variant].forEach((lightness, index) => {
      palette[`base1${index}`] = neutral(identity, lightness, variant === "dark" ? index : 7 - index);
    });

    for (const [slot, normalSlot] of Object.entries(BRIGHT_BASES)) {
      palette[slot] = ensureContrast(
        accentFor(identity, SEMANTIC_HUES[normalSlot], variant, true),
        palette.base00,
        variant,
      );
    }
  }

  return Object.fromEntries(Object.entries(palette).map(([slot, color]) => [slot, toHex(color)]));
}

export function generateThemes(input) {
  const colors = parseColorHuntSlug(input);
  const identity = deriveIdentity(colors);

  return {
    colors,
    base16: {
      dark: renderVariant(identity, "dark", "base16"),
      light: renderVariant(identity, "light", "base16"),
    },
    base24: {
      dark: renderVariant(identity, "dark", "base24"),
      light: renderVariant(identity, "light", "base24"),
    },
  };
}

function quoteYaml(value) {
  return JSON.stringify(value);
}

export function themeToYaml({ system, name, slug, author, description, variant, palette }) {
  const lines = [
    `system: ${quoteYaml(system)}`,
    `name: ${quoteYaml(name)}`,
    `slug: ${quoteYaml(slug)}`,
    `author: ${quoteYaml(author)}`,
    `description: ${quoteYaml(description)}`,
    `variant: ${quoteYaml(variant)}`,
    "palette:",
    ...Object.entries(palette).map(([slot, color]) => `  ${slot}: ${quoteYaml(color)}`),
  ];
  return `${lines.join("\n")}\n`;
}
