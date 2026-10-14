import { test } from 'node:test'
import assert from 'node:assert/strict'
import { readFileSync } from 'node:fs'
import { filterTools, commandFor } from '../src/catalog.js'

const catalog = JSON.parse(readFileSync(new URL('../public/tools.json', import.meta.url), 'utf8'))

test('search matches names, publishers, and capabilities regardless of case or whitespace', () => {
  assert.deepEqual(filterTools(catalog, '  CPU-Z ').map(tool => tool.name), ['cpuz'])
  assert.ok(filterTools(catalog, 'MICROSOFT', 'sysinternals').length > 0)
  assert.ok(filterTools(catalog, 'temperature', 'hardware').length > 0)
})

test('search and category filters combine and can produce zero results', () => {
  assert.deepEqual(filterTools(catalog, 'cpu-z', 'privacy'), [])
  assert.deepEqual(filterTools(catalog, 'no-matching-utility'), [])
  assert.equal(filterTools(catalog, '   ').length, catalog.tools.length)
  assert.ok(filterTools(catalog, '', 'hardware').every(tool => tool.category === 'hardware'))
})

test('multiword search matches terms across name and publisher', () => {
  assert.deepEqual(filterTools(catalog, 'explorer microsoft').map(tool => tool.name), ['microsoft-procexp'])
})

test('copied commands use the short aliases of the catalog text endpoints', () => {
  for (const tool of catalog.tools) {
    assert.equal(commandFor(tool), `irm https://wintools.poziel.dev/${tool.name} | iex`)
  }
})
