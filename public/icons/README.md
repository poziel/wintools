# WinTools tool socket icon kit

Concept 7 is the website identity. Both SVG masters use identical hexagonal geometry and two colors: forest #142b23 and lime #c2f16a.

All current assets live directly in public/icons/:

- logo-light.svg: forest shell, lime center, forest command chevron.
- logo-dark.svg: lime shell, forest center, lime command chevron.
- icon-light-{size}.png and icon-dark-{size}.png: transparent square exports at 16, 24, 32, 48, 64, 96, 128, 256, 512, 1024 px.
- favicon-light.ico and favicon-dark.ico: theme-specific 16/32/48 px containers.
- favicon.ico: transparent fallback using the light logo at 16/32/48 px.
- windows.ico: universal 16/24/32/48/64/128/256 px container.
- macos.icns: universal 16/32/64/128/256/512/1024 px container.
- apple-touch-icon.png: opaque 180 px platform icon.
- android-chrome-192.png and android-chrome-512.png: opaque platform icons.
- maskable-512.png: extra padding for platform masks.
- app-store-1024.png: opaque native packaging source.
- mstile-150x150.png and mstile-310x310.png: opaque Windows tiles.
- site.webmanifest: website application branding metadata.

The Vue header and SVG favicon use these logo files directly and follow the website theme, including the saved preference on reload. Universal platform assets use the light logo on an opaque off-white backing; SVG masters and browser favicons remain transparent. The manifest does not provide offline support.

preview.png shows both variants at large size and actual 16/32/48/64 px. Earlier artwork is preserved in docs/branding-archive/ and excluded from the current kit.

## Regenerate

Edit both SVG masters, then run from the repository root:

```powershell
$env:WINTOOLS_SHARP_MODULE = 'C:/path/to/node_modules/sharp'
node build/generate-icons.mjs
```
