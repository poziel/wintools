<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/icons/logo-dark.svg">
    <img src="public/icons/logo-light.svg" alt="WinTools logo" width="112" height="112">
  </picture>
</p>

<h1 align="center">WinTools</h1>

<p align="center">Windows utilities, one command away.</p>

WinTools brings useful Windows tools together in a searchable website and a PowerShell menu. Find a utility, copy its command, and launch it from your terminal without manually hunting down a download.

**[Browse the tools at wintools.poziel.dev](https://wintools.poziel.dev)**

## Get started

Open a PowerShell session on Windows and run:

```powershell
irm https://wintools.poziel.dev/get | iex
```

The interactive menu loads the tool catalog. Enter a tool number to launch it, **L** to list commands, or **Q** to quit.

You need an internet connection to fetch scripts and applications. Some utilities require administrator privileges; follow the selected tool's requirements.

### Run a tool directly

Each tool has its own command. For example, to launch CPU-Z:

```powershell
irm https://wintools.poziel.dev/cpuz | iex
```

Or open Process Explorer:

```powershell
irm https://wintools.poziel.dev/microsoft-procexp | iex
```

`irm` is short for `Invoke-RestMethod`: it downloads the script. `iex` is short for `Invoke-Expression`: it executes that script in PowerShell.

### Find a tool on the website

On [the WinTools website](https://wintools.poziel.dev), search by name or description, or filter the catalog by category. Each card includes a description, expandable features, and a link to the tool's official website.

Use **Copy command** to copy a ready-to-run PowerShell command. The adjacent icon buttons let you **copy the tool name** or **view its script** before running it. The website helps you browse; the utilities run locally on your Windows computer.

## What's in the toolbox?

| Category | What it helps with | Examples |
| --- | --- | --- |
| Hardware & Diagnostics | Inspect hardware, monitor sensors and drive health, and benchmark storage. | CPU-Z, HWiNFO, CrystalDiskInfo, CrystalDiskMark |
| Privacy & Optimization | Adjust privacy settings, reduce telemetry, and manage unwanted applications. | O&O ShutUp10++, O&O AppBuster, Optimizer, xd-AntiSpy |
| Microsoft Sysinternals | Investigate startup entries, running processes, and system activity. | Autoruns, Process Explorer, Process Monitor |
| System Utilities | Search files, clean up Windows, and work with the registry and other system tasks. | Everything, Cleanmgr+, O&O RegEditor |
| Package Managers | Browse, install, update, and remove software through a graphical interface. | UniGetUI |

The [website catalog](https://wintools.poziel.dev/#catalog) contains the full selection and details for each tool.

## How it works

The website and terminal menu share one catalog. Each entry points to a small PowerShell script that defines how to obtain and start the selected utility.

For portable applications, the intended workflow is to download the application, extract it when needed, launch it, and remove its temporary files after use. Shared helpers handle downloading and launching. Some entries instead invoke an upstream script or installer, so their behavior depends on that project.

### Current limitations

The shared runner waits for the launched process and removes its own temporary folder by default; `-NoCleanup` retains it. Utilities that start separate processes or run installers may have a different lifecycle. Some other helpers still rely on Windows PowerShell-specific behavior, and upstream downloads can change or become unavailable.

Cleanup concerns downloaded files; it does not undo settings changed by a tool or software installed through it. Review scripts with **View script** and consult the original project's documentation for the utility's behavior and requirements.

## Contributing

Tool descriptions and categories live in [public/tools.json](public/tools.json). Individual launch scripts live in [public/scripts/](public/scripts/), with shared helpers in [public/commons/](public/commons/).

To add a tool:

1. Create `public/scripts/<name>.ps1`, following an existing script's structure and documenting its purpose and usage.
2. Add its `name`, `displayName`, `category`, `description`, `features`, `url`, and `website` to the catalog. Include `vendor` when applicable.
3. Set the catalog URL to `https://wintools.poziel.dev/<name>.txt`. The website presents the shorter command URL without `.txt`.
4. Run `npm test` and `npm run build` to validate the catalog and generated script endpoints.

The shared catalog keeps the website and terminal menu in sync.

### Work on the website

The frontend uses Vue and Vite. Development requires Node.js 22.12 or newer.

```sh
npm ci
npm run dev
```

Run the checks and create a production build:

```sh
npm test
npm run build
npm run preview
```

Application components and styles live in `src/`. The build creates `dist/` and verifies that the script endpoints preserve the original script contents. These checks do not launch the Windows utilities.

On Windows, run `pwsh -NoProfile -File tests/downloadrun.ps1` and `powershell -NoProfile -ExecutionPolicy Bypass -File tests/downloadrun.ps1` to check the runner in both PowerShell versions. These checks use dummy downloads and a simulated process launch; they also run before deployment.

### Branding assets

The [current icon kit](public/icons/) contains the SVG masters, light and dark variants, favicons, and platform exports as individual files. Its [asset guide](public/icons/README.md) describes the formats and how to regenerate them.

Earlier portable-case, WT badge, and WT ligature concepts are preserved in the [branding archive](docs/branding-archive/) as part of the project's design history.

## License

WinTools is available under the [MIT License](LICENSE). Third-party utilities retain their own licenses and terms.
