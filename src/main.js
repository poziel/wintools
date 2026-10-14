import { createApp } from 'vue'
import App from './App.vue'
import './style.css'

let theme = 'light'
try {
  const saved = localStorage.getItem('theme')
  if (saved === 'dark' || saved === 'light') theme = saved
} catch { /* Storage may be unavailable in private or restricted contexts. */ }
document.documentElement.dataset.theme = theme

createApp(App).mount('#app')
