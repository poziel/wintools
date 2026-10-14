# WinTools

A Vue website for discovering Windows utility scripts and copying their PowerShell commands.

**Website:** https://wintools.poziel.dev

```powershell
irm https://wintools.poziel.dev/get | iex
```

Browse all 19 tools on the website, filter by category or search, and copy a command. The website runs entirely in the browser; utilities run in PowerShell on the user's Windows PC.

## Development

Requires Node.js 22.12+ (Node 24 is used in CI).

```sh
npm ci
npm run dev
npm test
npm run build
npm run preview
```

`npm run build` creates `dist/` and verifies the deployed files. Both the development server and production build support `/get` and the extensionless tool URLs. Unknown routes return 404 instead of the Vue page.

## Project structure

- `src/` — Vue application, components, and styles
- `index.html` — Vite entry point
- `public/tools.json` — shared catalog, served at `/tools.json`
- `public/get.ps1` — interactive PowerShell menu, served at `/get.ps1`, `/get`, and `/get.txt`
- `public/scripts/` — tool scripts, served at `/scripts/<name>.ps1`, `/<name>`, and `/<name>.txt`
- `public/commons/` — shared helpers, served at `/commons/<name>.ps1` and `/commons/<name>.ps1.txt`
- `build/` — script endpoint generation and artifact verification
- `tests/` — catalog search, commands, and endpoint checks
- `.github/workflows/pages.yml` — validation and GitHub Pages deployment

Vite copies public assets without changing their content. The endpoint plugin emits byte-identical short and `.txt` aliases. GitHub Pages chooses response types by extension: `.txt` ensures the existing `Invoke-WebRequest(...).Content` calls receive strings. The menu's catalog URLs and helper fetch URLs therefore use those text aliases. Website commands use the short aliases through `Invoke-RestMethod`, which decodes the response as text. No script logic is changed to implement this.

## Publishing on GitHub Pages

The workflow validates pull requests to `master`. Pushes to `master`, or manual runs on `master`, build and publish `dist/` using the GitHub Pages artifact and deployment actions. It uses the repository's built-in `GITHUB_TOKEN`; no deployment secret is needed.

One-time configuration:

1. In the repository's **Settings → Pages**, select **GitHub Actions** as the build source.
2. Set the custom domain to **wintools.poziel.dev**.
3. At the DNS provider for `poziel.dev`, set the `wintools` CNAME to **poziel.github.io**. Replace any conflicting record for that subdomain.
4. Once GitHub has validated DNS and issued the certificate, enable **Enforce HTTPS**.
5. Push the reviewed changes to `master` or run the workflow from the Actions tab.

`public/CNAME` records the intended hostname. For an Actions deployment, the custom domain must also be configured in the Pages settings. Vite's base is `/` because the site uses a custom domain.

After deployment, verify the website and script responses:

```powershell
Invoke-WebRequest https://wintools.poziel.dev/get -UseBasicParsing
Invoke-RestMethod https://wintools.poziel.dev/tools.json
Invoke-WebRequest https://wintools.poziel.dev/cpuz -UseBasicParsing
```

These commands fetch content without executing a utility. The `/get` and `/cpuz` responses must contain PowerShell, not HTML.

GitHub Pages setup: https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages

Custom domain setup: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site

## Adding a tool

1. Create `public/scripts/<name>.ps1` following the existing script template.
2. Add its name, display name, category, description, features, URL, and website to `public/tools.json`.
3. Set its catalog URL to `https://wintools.poziel.dev/<name>.txt`. The website uses its equivalent short alias, `https://wintools.poziel.dev/<name>`.
4. Run `npm test` and `npm run build`.

The website and menu use the same catalog. The build rejects missing scripts, duplicate names, reserved paths, and incorrect command URLs.

## PowerShell scope and existing limitations

This website migration preserves the original PowerShell scripts and comments, changing only their URLs and repository locations. The menu now fetches `/tools.json` from the same site instead of the incorrect raw GitHub `main` URL. The scripts still display their original branding where it occurs in their text.

The intended portable-tool workflow is download, launch, then cleanup. The existing runner still has known issues: its `NoCleanup` condition is reversed, extracted executable paths are assembled incorrectly, and some helpers depend on Windows PowerShell-specific behavior. Upstream-script and installer entries do not all follow the portable workflow. This migration does not claim to fix or validate those behaviors; running a tool can also make persistent system changes. Script fixes require a separate change.

Source links currently point to the existing `poziel/wintool` GitHub repository. Renaming the GitHub repository and local checkout are separate from renaming the website and its domain.

## License

MIT — see [LICENSE](LICENSE).
