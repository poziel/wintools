# WinTools implementation plan

**Goal:** Deliver the approved Vue/Vite website and GitHub Pages workflow while preserving the PowerShell scripts except for URL replacements.

**Architecture:** public/ owns all distributable scripts and the catalog. Vue renders the shared catalog. A Vite plugin serves extensionless script aliases locally and emits the same aliases in dist/.

**Tech stack:** Vue 3, Vite, plain CSS, Node's built-in test runner, GitHub Pages.

**Spec:** ../specs/2026-10-13-wintools-vue-design.md, including the user's scope correction.

## Constraints

- Keep PowerShell comments and behavior identical to HEAD except URL substitutions.
- Use https://wintools.poziel.dev for first-party commands and catalog fetching.
- Preserve all 19 existing catalog entries and their metadata apart from URLs.
- Keep quick.html as a directly accessible compact view.
- Build and verify locally; prepare the workflow without pushing or deploying.

## Review focus

- Every catalog command resolves to a script file, never HTML.
- Clipboard denial leaves the command selectable and reports the failure.
- Empty results and combined search/category filters have a reset action.
- Mobile widths and long commands do not overflow the page.
- Existing theme preferences survive, including unavailable browser storage.

## Tasks

- [x] Move get.ps1, tools.json, scripts/, and commons/ into public/; replace only first-party URLs and the menu catalog URL. Compare every script to HEAD after normalizing these substitutions.
- [x] Add package.json, Vite configuration, build/script-endpoints.js, and tests/endpoints.test.js. Validate unique safe catalog names, categories, matching script files, and reserved path collisions; emit byte-identical extensionless aliases and reject missing paths. Also emit .txt aliases for text decoding by the unchanged Invoke-WebRequest calls.
- [x] Replace index.html and quick.html with Vite entries. Implement src/App.vue, src/components/CommandCopy.vue, src/components/ToolCard.vue, src/style.css, and src/main.js. Use one catalog import, search/categories, full/compact layouts, source links, selectable commands, and saved theme handling.
- [x] Add .github/workflows/pages.yml with pull-request build checks and master/manual deployment. Add domain files and document Pages settings, DNS, local development, source layout, and unchanged runner limitations.
- [x] Run npm test, npm run build, PowerShell parsing and script-preservation comparison. Check all HTTP endpoints and IRM response types in PowerShell 5.1/7 without running utilities. Inspect the interface and interactions in a real browser at desktop/mobile sizes.
- [x] Review the diff and report the remaining live deployment and script limitations accurately.

## Verification results

18 Node tests and the production build pass. The artifact verifier checks all 42 generated endpoints. All 22 original PowerShell files match HEAD after the allowed URL substitutions. HTTP-loaded menu startup/quit, 20 short command responses, and 22 text responses passed on PowerShell 5.1 and 7. Browser checks cover search, categories, empty/reset, clipboard success/denial, persisted theme, quick view, mobile overflow, and a clean development page console. Live publishing and utility execution were not performed.
