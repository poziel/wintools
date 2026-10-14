import { createRequire } from 'node:module'
import { readFile, writeFile, mkdir } from 'node:fs/promises'
import { resolve } from 'node:path'

// Supply an installed sharp module path to regenerate without changing project dependencies.
const require = createRequire(import.meta.url)
const sharp = require(process.env.WINTOOLS_SHARP_MODULE || 'sharp')
const root = resolve('public/icons')
const forest = '#142b23'
const badgeBackground = '#f7f8f4'
const sizes = [16, 24, 32, 48, 64, 96, 128, 256, 512, 1024]

function ico(images) {
  const header = Buffer.alloc(6 + images.length * 16)
  header.writeUInt16LE(1, 2)
  header.writeUInt16LE(images.length, 4)
  let offset = header.length
  images.forEach(({ size, png }, i) => {
    const entry = 6 + i * 16
    header[entry] = header[entry + 1] = size === 256 ? 0 : size
    header.writeUInt16LE(1, entry + 4)
    header.writeUInt16LE(32, entry + 6)
    header.writeUInt32LE(png.length, entry + 8)
    header.writeUInt32LE(offset, entry + 12)
    offset += png.length
  })
  return Buffer.concat([header, ...images.map(image => image.png)])
}

function icns(images) {
  const chunks = images.map(({ type, png }) => {
    const header = Buffer.alloc(8)
    header.write(type)
    header.writeUInt32BE(png.length + 8, 4)
    return Buffer.concat([header, png])
  })
  const header = Buffer.alloc(8)
  header.write('icns')
  header.writeUInt32BE(8 + chunks.reduce((sum, chunk) => sum + chunk.length, 0), 4)
  return Buffer.concat([header, ...chunks])
}



const directory = resolve(root, 'tool-socket')
await mkdir(directory, { recursive: true })
const masters = {}
const pngs = {}
for (const theme of ['light', 'dark']) {
  masters[theme] = await readFile(resolve(directory, `logo-${theme}.svg`), 'utf8')
  pngs[theme] = new Map()
  for (const size of sizes) {
    const png = await sharp(Buffer.from(masters[theme])).resize(size,size).png().toBuffer()
    pngs[theme].set(size,png)
    await writeFile(resolve(directory, `icon-${theme}-${size}.png`),png)
  }
  await writeFile(resolve(directory,`favicon-${theme}.ico`),ico([16,32,48].map(size=>({size,png:pngs[theme].get(size)}))))
}
const body=masters.light.slice(masters.light.indexOf('>')+1,masters.light.lastIndexOf('</svg>'))
function device(scale=.8) {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="none"><path fill="${badgeBackground}" d="M0 0h256v256H0Z"/><g transform="translate(${128*(1-scale)} ${128*(1-scale)}) scale(${scale})">${body}</g></svg>`
}
for (const [file,size,scale] of [
  ['apple-touch-icon',180,.8],['android-chrome-192',192,.8],['android-chrome-512',512,.8],
  ['maskable-512',512,.65],['app-store-1024',1024,.8],['mstile-150x150',150,.8],['mstile-310x310',310,.8],
]) await writeFile(resolve(directory,`${file}.png`),await sharp(Buffer.from(device(scale))).resize(size,size).png().toBuffer())
const backed=new Map()
for(const size of sizes) backed.set(size,await sharp(Buffer.from(device(.9))).resize(size,size).png().toBuffer())
await writeFile(resolve(directory,'favicon.ico'),ico([16,32,48].map(size=>({size,png:backed.get(size)}))))
await writeFile(resolve(directory,'windows.ico'),ico([16,24,32,48,64,128,256].map(size=>({size,png:backed.get(size)}))))
await writeFile(resolve(directory,'macos.icns'),icns([[16,'icp4'],[32,'icp5'],[64,'icp6'],[128,'ic07'],[256,'ic08'],[512,'ic09'],[1024,'ic10']].map(([size,type])=>({type,png:backed.get(size)}))))
await writeFile(resolve(directory,'site.webmanifest'),JSON.stringify({name:'WinTools',short_name:'WinTools',start_url:'/',display:'standalone',background_color:badgeBackground,theme_color:forest,icons:[192,512].map(size=>({src:`android-chrome-${size}.png`,sizes:`${size}x${size}`,type:'image/png',purpose:'any'})).concat([{src:'maskable-512.png',sizes:'512x512',type:'image/png',purpose:'maskable'}])},null,2)+'\n')
const adaptive=masters.light.replace('</svg>',`<style>@media (prefers-color-scheme: dark) { path:nth-of-type(1) { fill: #c2f16a; } path:nth-of-type(2) { fill: #142b23; } path:nth-of-type(3) { stroke: #c2f16a; } }</style></svg>`)
await writeFile(resolve('public/favicon.svg'),adaptive)
await writeFile(resolve('public/favicon.ico'),await fsRead('favicon.ico'))
function fsRead(name){return readFile(resolve(directory,name))}
const composites=[]
for(const [i,theme] of ['light','dark'].entries()) {
 const bg=theme==='light'?'#f7f8f4':'#141a17'
 composites.push({input:Buffer.from(`<svg width="450" height="470" xmlns="http://www.w3.org/2000/svg"><path fill="${bg}" d="M0 0h450v470H0Z"/></svg>`),left:i*450,top:0})
 composites.push({input:pngs[theme].get(256),left:i*450+97,top:70})
 for(const [j,size] of [16,32,48,64].entries()) composites.push({input:pngs[theme].get(size),left:i*450+70+j*80,top:380})
}
composites.push({input:Buffer.from('<svg width="900" height="470" xmlns="http://www.w3.org/2000/svg"><g font-family="Segoe UI, sans-serif" font-size="18"><text x="35" y="40" fill="#142b23">Tool socket / Light mode</text><text x="485" y="40" fill="#c2f16a">Tool socket / Dark mode</text></g></svg>'),left:0,top:0})
await writeFile(resolve(root,'preview.png'),await sharp({create:{width:900,height:470,channels:4,background:badgeBackground}}).composite(composites).png().toBuffer())
console.log('Generated tool socket theme variants, device assets, favicons, and preview.')
