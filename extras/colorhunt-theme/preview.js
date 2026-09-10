import Color from "colorjs.io";

function escapeHtml(value) {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function labelColor(background) {
  const color = new Color(background);
  return color.contrast("#111111", "WCAG21") >= color.contrast("#ffffff", "WCAG21") ? "#111111" : "#ffffff";
}

function swatch(label, color) {
  return `<div class="swatch" style="--swatch: ${color}; --label: ${labelColor(color)}">
  <strong>${escapeHtml(label)}</strong>
  <code>${escapeHtml(color)}</code>
</div>`;
}

function palettePanel(system, variant, palette) {
  const colors = Object.entries(palette).map(([slot, color]) => swatch(slot, color)).join("\n");
  return `<section class="palette ${variant}" style="--background: ${palette.base00}; --foreground: ${palette.base05}; --border: ${palette.base02}">
  <header>
    <h2>${escapeHtml(system)} ${escapeHtml(variant)}</h2>
    <span>${Object.keys(palette).length} colors</span>
  </header>
  <div class="swatches">
    ${colors}
  </div>
</section>`;
}

export function themesToHtml({ name, author, source, sourceColors, themes }) {
  const sourceSwatches = sourceColors.map((color, index) => swatch(`source ${index + 1}`, color)).join("\n");
  const panels = [
    palettePanel("Base16", "light", themes.base16.light),
    palettePanel("Base16", "dark", themes.base16.dark),
    palettePanel("Base24", "light", themes.base24.light),
    palettePanel("Base24", "dark", themes.base24.dark),
  ].join("\n");

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${escapeHtml(name)} palette preview</title>
  <style>
    * { box-sizing: border-box; }
    body {
      margin: 0;
      background: #181818;
      color: #eeeeee;
      font: 15px/1.5 system-ui, sans-serif;
    }
    main { width: min(1440px, 100%); margin: auto; padding: 2rem; }
    h1, h2, p { margin-top: 0; }
    h1 { margin-bottom: 0.25rem; }
    a { color: #9ecbff; }
    .source { margin: 2rem 0; }
    .source .swatches { max-width: 720px; }
    .themes { display: grid; grid-template-columns: repeat(auto-fit, minmax(min(100%, 32rem), 1fr)); gap: 1.5rem; }
    .palette {
      padding: 1.25rem;
      border: 1px solid var(--border);
      border-radius: 0.75rem;
      background: var(--background);
      color: var(--foreground);
    }
    .palette header { display: flex; align-items: baseline; justify-content: space-between; gap: 1rem; }
    .palette header span { opacity: 0.75; }
    .swatches { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); }
    .swatch {
      min-height: 5rem;
      padding: 0.65rem;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      overflow: hidden;
      background: var(--swatch);
      color: var(--label);
    }
    .swatch strong { font-size: 0.8rem; }
    .swatch code { font-size: 0.75rem; color: inherit; }
    @media (max-width: 500px) {
      main { padding: 1rem; }
      .swatches { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    }
  </style>
</head>
<body>
  <main>
    <h1>${escapeHtml(name)}</h1>
    <p>By ${escapeHtml(author)} · <a href="${escapeHtml(source)}">View the source palette on Color Hunt</a></p>
    <section class="source">
      <h2>Source palette</h2>
      <div class="swatches">
        ${sourceSwatches}
      </div>
    </section>
    <div class="themes">
      ${panels}
    </div>
  </main>
</body>
</html>
`;
}
