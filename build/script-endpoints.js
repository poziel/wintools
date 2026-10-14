import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'

export const siteUrl = 'https://wintools.poziel.dev'

export function getScriptEndpoints(publicDir) {
  const catalog = JSON.parse(readFileSync(resolve(publicDir, 'tools.json'), 'utf8'))
  const reserved = new Set(['get', 'index', 'quick', 'assets', 'scripts', 'commons', 'tools', 'favicon'])
  const names = new Set()
  const endpoints = new Map([
    ['/get', resolve(publicDir, 'get.ps1')],
    ['/get.txt', resolve(publicDir, 'get.ps1')],
  ])

  if (!catalog.tools?.length || !catalog.categories) throw new Error('The tool catalog is empty or invalid.')

  for (const tool of catalog.tools) {
    if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(tool.name) || reserved.has(tool.name)) {
      throw new Error(`Invalid or reserved tool name: ${tool.name}`)
    }
    if (names.has(tool.name)) throw new Error(`Duplicate tool name: ${tool.name}`)
    if (!catalog.categories[tool.category]) throw new Error(`Unknown category for ${tool.name}`)
    if (tool.url !== `${siteUrl}/${tool.name}.txt`) throw new Error(`Incorrect command URL for ${tool.name}`)
    if (!tool.displayName || !tool.description || !Array.isArray(tool.features)) {
      throw new Error(`Incomplete metadata for ${tool.name}`)
    }
    names.add(tool.name)
    endpoints.set(`/${tool.name}`, resolve(publicDir, 'scripts', `${tool.name}.ps1`))
    endpoints.set(`/${tool.name}.txt`, resolve(publicDir, 'scripts', `${tool.name}.ps1`))
  }

  for (const [route, path] of endpoints) {
    if (!readFileSync(path).length) throw new Error(`Empty script for ${route}`)
  }
  for (const filename of readdirSync(resolve(publicDir, 'scripts'))) {
    if (filename.endsWith('.ps1') && !names.has(filename.slice(0, -4))) {
      throw new Error(`Script is missing from the catalog: ${filename}`)
    }
  }
  for (const filename of readdirSync(resolve(publicDir, 'commons'))) {
    if (filename.endsWith('.ps1')) endpoints.set(`/commons/${filename}.txt`, resolve(publicDir, 'commons', filename))
  }
  return endpoints
}

export function scriptEndpoints() {
  let publicDir
  let isBuild
  return {
    name: 'wintools-script-endpoints',
    configResolved(config) {
      publicDir = config.publicDir
      isBuild = config.command === 'build'
    },
    configureServer(server) {
      server.middlewares.use((request, response, next) => {
        const pathname = new URL(request.url, 'http://localhost').pathname
        try {
          const path = getScriptEndpoints(publicDir).get(pathname)
          if (!path) return next()
          const body = readFileSync(path)
          response.setHeader('Content-Type', 'text/plain; charset=utf-8')
          response.end(request.method === 'HEAD' ? undefined : body)
        } catch (error) {
          next(error)
        }
      })
    },
    buildStart() {
      if (!isBuild) return
      for (const [route, path] of getScriptEndpoints(publicDir)) {
        this.emitFile({ type: 'asset', fileName: route.slice(1), source: readFileSync(path) })
      }
    },
  }
}
