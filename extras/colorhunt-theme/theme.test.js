import assert from "node:assert/strict";
import { mkdtemp, readFile } from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import test from "node:test";
import Color from "colorjs.io";
import { run } from "./cli.js";
import { generateThemes, parseColorHuntSlug } from "./theme.js";

const EXAMPLE = "ffbe91ffddb0fffce1cfebff";
const EDGE_CASES = [
  "000000333333ccccccffffff",
  "ff000000ff000000ffffffff",
  "050505101010181818222222",
];

test("parses slugs and Color Hunt URLs", () => {
  const colors = ["#ffbe91", "#ffddb0", "#fffce1", "#cfebff"];
  assert.deepEqual(parseColorHuntSlug(EXAMPLE), colors);
  assert.deepEqual(parseColorHuntSlug(`https://colorhunt.co/palette/${EXAMPLE}`), colors);
  assert.throws(() => parseColorHuntSlug("ff00ff"), /exactly four/);
});

test("generates complete light and dark Base16 and Base24 palettes", () => {
  for (const example of [EXAMPLE, ...EDGE_CASES]) {
    const themes = generateThemes(example);
    assert.equal(Object.keys(themes.base16.dark).length, 16);
    assert.equal(Object.keys(themes.base16.light).length, 16);
    assert.equal(Object.keys(themes.base24.dark).length, 24);
    assert.equal(Object.keys(themes.base24.light).length, 24);

    for (const system of ["base16", "base24"]) {
      for (const variant of ["dark", "light"]) {
        const palette = themes[system][variant];
        const lightness = Array.from({ length: 8 }, (_, index) =>
          new Color(palette[`base0${index}`]).to("oklch").coords[0],
        );
        const expectedDirection = variant === "dark" ? 1 : -1;
        for (let index = 1; index < lightness.length; index += 1) {
          assert.ok((lightness[index] - lightness[index - 1]) * expectedDirection > 0);
        }

        const background = new Color(palette.base00);
        assert.ok(background.contrast(new Color(palette.base05), "WCAG21") >= 4.5);
        for (const slot of ["base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F"]) {
          assert.ok(
            background.contrast(new Color(palette[slot]), "WCAG21") >= 4.5,
            `${example} ${system} ${variant} ${slot}`,
          );
        }
        if (system === "base24") {
          for (const slot of ["base12", "base13", "base14", "base15", "base16", "base17"]) {
            assert.ok(
              background.contrast(new Color(palette[slot]), "WCAG21") >= 4.5,
              `${example} ${system} ${variant} ${slot}`,
            );
          }
        }
      }
    }
  }
});

test("CLI writes four schemes and a deterministic HTML preview", async () => {
  const directory = await mkdtemp(path.join(os.tmpdir(), "colorhunt-theme-"));
  const first = await run([EXAMPLE, "--output", directory, "--name", "Spring Glass", "--author", "Test"]);
  assert.equal(first.length, 5);

  const contents = await Promise.all(first.map((filename) => readFile(filename, "utf8")));
  assert.match(contents[0], /system: "base16"/);
  assert.match(contents[0], /name: "Spring Glass"/);
  assert.match(contents[0], /slug: "spring-glass-light"/);
  assert.match(contents[0], /description: "Generated from https:\/\/colorhunt\.co\/palette\//);
  assert.match(contents[0], /base0F: "#[0-9a-f]{6}"/);
  assert.match(contents[2], /base17: "#[0-9a-f]{6}"/);
  assert.match(contents[4], /<!doctype html>/);
  assert.match(contents[4], /<title>Spring Glass palette preview<\/title>/);
  assert.equal((contents[4].match(/<section class="palette /g) ?? []).length, 4);
  assert.match(contents[4], /Base16 light/);
  assert.match(contents[4], /Base24 dark/);
  assert.match(contents[4], /source 1/);

  await run([EXAMPLE, "--output", directory, "--name", "Spring Glass", "--author", "Test"]);
  const repeated = await Promise.all(first.map((filename) => readFile(filename, "utf8")));
  assert.deepEqual(repeated, contents);
});
