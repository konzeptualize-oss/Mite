// Downloads the Google Fonts the app uses into www/fonts so it works offline in the APK.
// Run once (needs internet, Node 18+):  node scripts/bundle-fonts.mjs
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
const file = 'www/index.html';
let html = readFileSync(file, 'utf8');
const m = html.match(/<link rel="stylesheet" href="(https:\/\/fonts\.googleapis\.com\/css2[^"]+)">/);
if (!m) { console.log('Fonts already bundled (no Google Fonts link found).'); process.exit(0); }
const UA = 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/120 Mobile Safari/537.36';
const css = await (await fetch(m[1].replace(/&amp;/g, '&'), { headers: { 'User-Agent': UA } })).text();
mkdirSync('www/fonts', { recursive: true });
let out = css, i = 0;
for (const u of [...new Set([...css.matchAll(/url\((https:\/\/fonts\.gstatic\.com[^)]+)\)/g)].map(x => x[1]))]) {
  const name = `f${String(++i).padStart(3, '0')}.woff2`;
  writeFileSync(`www/fonts/${name}`, Buffer.from(await (await fetch(u)).arrayBuffer()));
  out = out.split(u).join(`${name}`);
}
writeFileSync('www/fonts/fonts.css', out);
html = html.replace(m[0], '<link rel="stylesheet" href="fonts/fonts.css">');
writeFileSync(file, html);
console.log(`Done: ${i} font files saved to www/fonts and index.html updated.`);
