<script setup>
import { computed, ref, watchEffect } from 'vue'
import { ArrowDown, ArrowUpRight, Check, Command, Moon, Search, Sun, Terminal, X } from '@lucide/vue'
import catalog from '../public/tools.json'
import { filterTools } from './catalog.js'
import CommandCopy from './components/CommandCopy.vue'
import ToolCard from './components/ToolCard.vue'
import GitHubIcon from './components/GitHubIcon.vue'
import MadeWithLove from './components/MadeWithLove.vue'

const query = ref('')
const category = ref('all')
const theme = ref(document.documentElement.dataset.theme || 'light')
watchEffect(() => {
  const favicon = document.querySelector('#theme-favicon')
  if (favicon) favicon.href = `/icons/logo-${theme.value}.svg`
})
const visibleTools = computed(() => filterTools(catalog, query.value, category.value))
const categories = Object.entries(catalog.categories).map(([key, value]) => ({
  key, ...value, count: catalog.tools.filter(tool => tool.category === key).length,
}))
const menuCommand = 'irm https://wintools.poziel.dev/get | iex'
const selectedCategory = computed(() => catalog.categories[category.value])

function toggleTheme() {
  theme.value = theme.value === 'light' ? 'dark' : 'light'
  document.documentElement.dataset.theme = theme.value
  try { localStorage.setItem('theme', theme.value) } catch { /* The theme still works without persistence. */ }
}

function reset() {
  query.value = ''
  category.value = 'all'
}
</script>

<template>
  <a class="skip-link" href="#catalog">Skip to tools</a>
  <div class="site-shell" >
    <header class="site-header">
      <a class="brand" href="/" aria-label="WinTools home"><span class="brand-mark"><img :src="`/icons/logo-${theme}.svg`" width="37" height="37" alt="" /></span>WinTools<span class="brand-dot">.</span></a>
      <nav class="header-nav" aria-label="Main navigation">
        <a href="#catalog" class="nav-catalog">Toolbox</a>
        <a href="#how-it-works">How it works</a>
        <span class="nav-divider" aria-hidden="true"></span>
        <a href="https://github.com/poziel/WinTools" class="icon-button" target="_blank" rel="noopener noreferrer" aria-label="Source code on GitHub (opens in a new tab)"><GitHubIcon /></a>
        <button type="button" class="icon-button" :aria-label="`Switch to ${theme === 'light' ? 'dark' : 'light'} theme`" @click="toggleTheme"><Moon v-if="theme === 'light'" :size="19" /><Sun v-else :size="19" /></button>
      </nav>
    </header>

    <main>
      <section class="hero" aria-labelledby="page-title">
        <div class="hero-copy">
          <p class="eyebrow"><span></span> YOUR WINDOWS TOOLBOX</p>
          <h1 id="page-title">The right tool.<br /><span>One command away.</span></h1>
          <p class="hero-description">A small collection for the things Windows needs help with. Find your utility, copy its command, and run it in PowerShell.</p>
          <a class="browse-link" href="#catalog">Explore the tools <ArrowDown :size="16" aria-hidden="true" /></a>
        </div>
        <div class="terminal-panel">
          <div class="terminal-bar"><span><Terminal :size="15" aria-hidden="true" /> POWERSHELL</span><span class="terminal-status"><span></span> READY WHEN YOU ARE</span></div>
          <div class="terminal-body">
            <p class="terminal-comment"># Your whole toolbox, in one command</p>
            <h2>Start with the menu.</h2>
            <p>Browse and launch a utility right from your terminal.</p>
            <CommandCopy :text="menuCommand" label="Copy menu command" />
            <div class="terminal-footnote"><Check :size="14" aria-hidden="true" /> Windows 10 / 11 <span aria-hidden="true">·</span> PowerShell</div>
          </div>
        </div>
      </section>

      <section id="catalog" class="catalog" aria-labelledby="catalog-title">
        <div class="catalog-heading">
          <div class="catalog-title"><h2 id="catalog-title">The toolbox</h2><span class="count-badge">{{ catalog.tools.length }} tools</span></div>
        </div>
        <div class="search-field">
          <Search :size="20" aria-hidden="true" />
          <label class="sr-only" for="tool-search">Search tools</label>
          <input id="tool-search" v-model="query" type="search" placeholder="Search tools, tasks, or publishers…" autocomplete="off" />
          <button v-if="query" class="icon-button" type="button" aria-label="Clear search" @click="query = ''"><X :size="17" /></button>
          <span v-else class="search-hint">Find what you need</span>
        </div>
        <div class="category-filters" role="group" aria-label="Filter by category">
          <button type="button" :class="{ selected: category === 'all' }" :aria-pressed="category === 'all'" @click="category = 'all'">All tools <span>{{ catalog.tools.length }}</span></button>
          <button v-for="item in categories" :key="item.key" type="button" :class="{ selected: category === item.key }" :aria-pressed="category === item.key" @click="category = item.key">{{ item.name }} <span>{{ item.count }}</span></button>
        </div>
        <div class="results-caption">
          <p role="status">{{ visibleTools.length }} {{ visibleTools.length === 1 ? 'tool' : 'tools' }}{{ selectedCategory ? ` in ${selectedCategory.name}` : ' for your next task' }}{{ query.trim() ? ` matching “${query.trim()}”` : '' }}</p>
          <button v-if="query || category !== 'all'" class="text-button" type="button" @click="reset">Reset filters <X :size="13" aria-hidden="true" /></button>
          <span v-else class="results-note">Pick a tool. Copy. Run.</span>
        </div>
        <div v-if="visibleTools.length" class="tools-grid">
          <ToolCard v-for="tool in visibleTools" :key="tool.name" :tool="tool" :category="catalog.categories[tool.category]" />
        </div>
        <div v-else class="empty-state">
          <Search :size="30" aria-hidden="true" />
          <h3>No tools found.</h3>
          <p>Try a different name, publisher, or category.</p>
          <button type="button" class="primary-button" @click="reset">Show all tools</button>
        </div>
      </section>

      <section id="how-it-works" class="how-it-works" aria-labelledby="how-title">
        <div class="how-intro"><p class="eyebrow">FROM BROWSER TO TERMINAL</p><h2 id="how-title">Three small steps.</h2><p>Your browser finds the tool.<br />PowerShell takes it from there.</p></div>
        <ol>
          <li><span class="step-number">01</span><h3>Find your tool</h3><p>Search the catalog or open the interactive menu to see what’s available.</p></li>
          <li><span class="step-number">02</span><h3>Copy the command</h3><p>Open PowerShell on your Windows PC and paste the command.</p></li>
          <li><span class="step-number">03</span><h3>Get to work</h3><p>Press Enter to download and launch. Some tools will ask for administrator access.</p></li>
        </ol>
      </section>
      <aside class="usage-note"><Command :size="17" aria-hidden="true" /><p>Commands run on your PC. Tools can change system settings; close the application when you’re finished. <a href="/commons/downloadrun.ps1.txt" target="_blank" rel="noopener noreferrer">Inspect the runner <ArrowUpRight :size="13" aria-hidden="true" /></a></p></aside>
    </main>

    <footer class="site-footer"><span class="footer-brand">WinTools<span class="brand-dot">.</span></span><MadeWithLove /></footer>
  </div>
</template>
