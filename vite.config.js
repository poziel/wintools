import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { scriptEndpoints } from './build/script-endpoints.js'

export default defineConfig({
  base: '/',
  appType: 'mpa',
  plugins: [vue(), scriptEndpoints()],
})
