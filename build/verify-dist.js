import assert from 'node:assert/strict'
import { readFileSync, readdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { getScriptEndpoints } from './script-endpoints.js'

const publicDir = resolve('public')
const distDir = resolve('dist')
const endpoints = getScriptEndpoints(publicDir)

for (const [route, source] of endpoints) {
  assert.deepEqual(readFileSync(resolve(distDir, route.slice(1))), readFileSync(source), route)
}
for (const directory of ['scripts', 'commons']) {
  for (const filename of readdirSync(resolve(publicDir, directory))) {
    assert.deepEqual(
      readFileSync(resolve(distDir, directory, filename)),
      readFileSync(resolve(publicDir, directory, filename)),
      `${directory}/${filename}`,
    )
  }
}
for (const filename of ['get.ps1', 'tools.json']) {
  assert.deepEqual(readFileSync(resolve(distDir, filename)), readFileSync(resolve(publicDir, filename)), filename)
}
for (const filename of ['index.html']) {
  assert.match(readFileSync(resolve(distDir, filename), 'utf8'), /assets\//)
}
console.log(`Verified ${endpoints.size} script endpoints, original scripts, catalog, and the website entry.`)
