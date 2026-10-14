import { test } from 'node:test'
import assert from 'node:assert/strict'
import { mkdtempSync, mkdirSync, writeFileSync, rmSync, readFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, resolve } from 'node:path'
import { getScriptEndpoints, scriptEndpoints } from '../build/script-endpoints.js'

function fixture(t, change = () => {}) {
  const directory = mkdtempSync(join(tmpdir(), 'wintools-endpoints-'))
  t.after(() => rmSync(directory, { recursive: true, force: true }))
  mkdirSync(join(directory, 'scripts'))
  mkdirSync(join(directory, 'commons'))
  writeFileSync(join(directory, 'get.ps1'), '# menu')
  writeFileSync(join(directory, 'scripts/cpuz.ps1'), '# tool')
  const catalog = {
    categories: { hardware: { name: 'Hardware' } },
    tools: [{ name: 'cpuz', displayName: 'CPU-Z', description: 'Hardware information', features: [], category: 'hardware', url: 'https://wintools.poziel.dev/cpuz.txt' }],
  }
  change(catalog)
  writeFileSync(join(directory, 'tools.json'), JSON.stringify(catalog))
  return directory
}

test('all production catalog commands have extensionless script endpoints', () => {
  const directory = resolve('public')
  const catalog = JSON.parse(readFileSync(join(directory, 'tools.json'), 'utf8'))
  const endpoints = getScriptEndpoints(directory)
  assert.equal(endpoints.size, (catalog.tools.length + 1) * 2 + 2)
  assert.equal(endpoints.get('/get'), join(directory, 'get.ps1'))
  for (const tool of catalog.tools) {
    assert.equal(endpoints.get(new URL(tool.url).pathname), join(directory, 'scripts', `${tool.name}.ps1`))
    assert.equal(endpoints.get(`/${tool.name}`), join(directory, 'scripts', `${tool.name}.ps1`))
  }
  assert.equal(endpoints.get('/commons/downloadrun.ps1.txt'), join(directory, 'commons/downloadrun.ps1'))
})

test('duplicate tool names cannot overwrite script endpoints', t => {
  const directory = fixture(t, catalog => catalog.tools.push(catalog.tools[0]))
  assert.throws(() => getScriptEndpoints(directory), /Duplicate/)
})

for (const name of ['../get', 'get', 'index', 'quick', 'assets', 'CPUZ']) {
  test(`rejects unsafe or reserved endpoint ${name}`, t => {
    const directory = fixture(t, catalog => { catalog.tools[0].name = name })
    assert.throws(() => getScriptEndpoints(directory), /Invalid or reserved/)
  })
}

test('a stale domain fails the build', t => {
  const directory = fixture(t, catalog => { catalog.tools[0].url = 'https://example.com/cpuz' })
  assert.throws(() => getScriptEndpoints(directory), /Incorrect command URL/)
})

test('an unknown category fails the build', t => {
  const directory = fixture(t, catalog => { catalog.tools[0].category = 'missing' })
  assert.throws(() => getScriptEndpoints(directory), /Unknown category/)
})

test('missing or empty scripts cannot be published', t => {
  const directory = fixture(t)
  writeFileSync(join(directory, 'scripts/cpuz.ps1'), '')
  assert.throws(() => getScriptEndpoints(directory), /Empty script/)
  rmSync(join(directory, 'scripts/cpuz.ps1'))
  assert.throws(() => getScriptEndpoints(directory), /ENOENT/)
})

test('scripts omitted from the catalog cannot be silently stranded', t => {
  const directory = fixture(t)
  writeFileSync(join(directory, 'scripts/extra.ps1'), '# another tool')
  assert.throws(() => getScriptEndpoints(directory), /missing from the catalog/)
})

test('the development server never calls the build-only asset emitter', () => {
  const plugin = scriptEndpoints()
  plugin.configResolved({ publicDir: resolve('public'), command: 'serve' })
  plugin.buildStart.call({ emitFile() { throw new Error('emitFile is unsupported in serve mode') } })
})

test('production emits both short and text aliases with unchanged contents', () => {
  const publicDir = resolve('public')
  const plugin = scriptEndpoints()
  plugin.configResolved({ publicDir, command: 'build' })
  const emitted = new Map()
  plugin.buildStart.call({ emitFile(asset) { emitted.set(`/${asset.fileName}`, asset.source) } })
  for (const [route, filename] of getScriptEndpoints(publicDir)) {
    assert.deepEqual(emitted.get(route), readFileSync(filename))
  }
})
