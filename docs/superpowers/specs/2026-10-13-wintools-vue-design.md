# WinTools Vue website and GitHub Pages deployment

Status: approved, with the user's subsequent scope correction below.

## Scope correction

Preserve all PowerShell script behavior and comments exactly, except for the URLs they fetch or document. Move the menu, catalog, scripts, and helpers into public/. Runner fixes, menu behavior changes, and PowerShell refactoring are excluded. The website must describe the current capabilities without claiming that the existing cleanup behavior has been fixed. This correction takes precedence over the runner corrections and menu enhancements originally proposed below.

## Purpose

WinTools helps Windows users find a utility, copy its PowerShell command, and run it on demand. The website is a catalog and command generator; execution happens in the user's terminal. The intended cleanup workflow remains subject to the existing runner limitations documented in README.md.

## Selected architecture

Use Vue 3 and Vite for a static application hosted at https://wintools.poziel.dev on GitHub Pages. Keep the existing PowerShell scripts and tools.json under public/ as the source of truth. No backend or client-side router is needed.

## Website

Provide a responsive utility catalog with text search, category filters, descriptions, vendors, features, source links, and per-tool copy buttons. Include the interactive-menu command prominently. Keep quick.html as a direct entry to a compact catalog view using the same Vue application. Use a restrained terminal-inspired visual style, clear typography, and accessible keyboard controls. Preserve the existing light/dark preference where available, and report clipboard failures with selectable command text.

## Static script distribution

A build step validates the catalog and copies public/ into the deployment artifact. It emits real extensionless files for /get and /<toolname>; these must never fall through to the website's HTML. It also emits identical .txt aliases for menu and helper fetches, so Invoke-WebRequest.Content returns text on static hosts. Keep explicit .ps1 URLs available as well. Do not rely on nginx rewrites, raw GitHub URLs, or HTML redirects for scripts.

The menu fetches https://wintools.poziel.dev/tools.json instead of a branch-specific GitHub URL. Catalog URLs use /<toolname>.txt; website commands use the equivalent short alias. Nested helper invocations use the new domain and .ps1.txt aliases. Menu logic remains unchanged.

## Preserved runner

Preserve the runner byte-for-byte apart from URL substitutions. The known NoCleanup, extracted-path, and PowerShell compatibility issues are documented for a separate authorized change.

Some entries execute upstream scripts or run installers. Describe these accurately instead of promising that every utility is portable or that its system changes are reverted.

## Publishing

Add a GitHub Actions workflow with pull-request validation and deployment on pushes to master or manual dispatch. Install from the lockfile, validate, build, upload the dist artifact, and deploy using GitHub's Pages actions with minimal job permissions and deployment concurrency. Include custom-domain configuration guidance and the intended CNAME value. GitHub Pages must use the GitHub Actions publishing source; the domain must be configured in repository settings and DNS.

Creating the workflow is part of this change. Pushing, triggering a live deployment, changing DNS, and renaming the remote GitHub repository are separate external actions requiring explicit authorization.

## Rename

Use WinTools in website text and wintools in project identifiers and domain references. Preserve upstream vendor names and repository URLs for third-party tools. Preserve script comments and branding under the user's narrower script constraint. The active checkout and remote repository keep their existing names; the request targets the contents of the folder and the website.

## Verification

Run the Vite production build and catalog/artifact integrity checks. Verify website search, categories, copy behavior, quick view, keyboard use, and mobile layout in a browser. Compare scripts against HEAD with only the permitted URL substitutions, parse script responses, and verify catalog/menu loading on PowerShell 5.1 and 7 without launching tools. Live endpoints, utility behavior, DNS, and remote deployment require separate verification after publishing.

## References

- https://vite.dev/guide/static-deploy.html
- https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages
- https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site
