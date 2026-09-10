#!/usr/bin/env node

import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { pathToFileURL } from "node:url";
import { themesToHtml } from "./preview.js";
import { generateThemes, themeToYaml } from "./theme.js";

function usage() {
  return `Usage: colorhunt-theme <slug-or-url> [options]

Generate matching light and dark Base16 and Base24 schemes from one Color Hunt palette.

Options:
  -o, --output <directory>  Output root (default: generated)
  -n, --name <name>         Scheme name (default: derived from the colors)
  -a, --author <author>     Scheme author (default: Color Hunt)
  -h, --help                Show this help
`;
}

function parseArguments(argv) {
  const options = { output: "generated", author: "Color Hunt" };
  let input;

  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];
    if (argument === "-h" || argument === "--help") return { help: true };
    if (argument === "-o" || argument === "--output") options.output = optionValue(argv, ++index, argument);
    else if (argument === "-n" || argument === "--name") options.name = optionValue(argv, ++index, argument);
    else if (argument === "-a" || argument === "--author") options.author = optionValue(argv, ++index, argument);
    else if (argument.startsWith("-")) throw new Error(`unknown option: ${argument}`);
    else if (input === undefined) input = argument;
    else throw new Error(`unexpected argument: ${argument}`);
  }

  if (!input) throw new Error("missing Color Hunt slug");
  if (!options.output || !options.author) throw new Error("options must not have empty values");
  return { input, ...options };
}

function optionValue(argv, index, option) {
  const value = argv[index];
  if (!value || value.startsWith("-")) throw new Error(`missing value for ${option}`);
  return value;
}

function fileSlug(name) {
  return name
    .normalize("NFKD")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

export async function run(argv) {
  const options = parseArguments(argv);
  if (options.help) {
    process.stdout.write(usage());
    return [];
  }

  const themes = generateThemes(options.input);
  const compactColors = themes.colors.map((color) => color.slice(1).toUpperCase()).join(" · ");
  const name = options.name ?? `Color Hunt ${compactColors}`;
  const slug = fileSlug(options.name ?? `color-hunt-${themes.colors.map((color) => color.slice(1)).join("")}`);
  if (!slug) throw new Error("scheme name must contain at least one letter or number");
  const sourceSlug = themes.colors.map((color) => color.slice(1)).join("");
  const source = `https://colorhunt.co/palette/${sourceSlug}`;
  const written = [];

  for (const system of ["base16", "base24"]) {
    const directory = path.resolve(options.output, system);
    await mkdir(directory, { recursive: true });

    for (const variant of ["light", "dark"]) {
      const filename = path.join(directory, `${slug}-${variant}.yaml`);
      const yaml = themeToYaml({
        system,
        name,
        slug: `${slug}-${variant}`,
        author: options.author,
        description: `Generated from ${source}`,
        variant,
        palette: themes[system][variant],
      });
      await writeFile(filename, yaml, "utf8");
      written.push(filename);
    }
  }

  const previewFilename = path.resolve(options.output, `${slug}.html`);
  const preview = themesToHtml({
    name,
    author: options.author,
    source,
    sourceColors: themes.colors,
    themes,
  });
  await writeFile(previewFilename, preview, "utf8");
  written.push(previewFilename);

  for (const filename of written) process.stdout.write(`${filename}\n`);
  return written;
}

if (import.meta.url === pathToFileURL(process.argv[1]).href) {
  run(process.argv.slice(2)).catch((error) => {
    process.stderr.write(`colorhunt-theme: ${error.message}\n`);
    process.exitCode = 1;
  });
}
