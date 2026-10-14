<script setup>
import { ref } from 'vue'
import { ArrowUpRight, ChevronDown, Code, Cpu, Gauge, Package, ShieldCheck, Tag, Wrench } from '@lucide/vue'
import CommandCopy from './CommandCopy.vue'
import { commandFor } from '../catalog.js'

defineProps({
  tool: { type: Object, required: true },
  category: { type: Object, required: true },
})
const expanded = ref(false)
const icons = { hardware: Cpu, privacy: ShieldCheck, sysinternals: Gauge, utilities: Wrench, packages: Package }
</script>

<template>
  <article class="tool-card">
    <div class="tool-heading">
      <div class="tool-icon" aria-hidden="true"><component :is="icons[tool.category] || Wrench" :size="23" :stroke-width="1.6" /></div>
      <div>
        <h3>{{ tool.displayName }}</h3>
        <p class="vendor">{{ tool.vendor || category.name }}</p>
      </div>
      <a v-if="tool.website" class="icon-button website-link" :href="tool.website" target="_blank" rel="noopener noreferrer" :aria-label="`Visit ${tool.displayName} website (opens in a new tab)`" title="Official website"><ArrowUpRight :size="19" /></a>
    </div>
    <p class="tool-description">{{ tool.description }}</p>
    <div class="tool-details">
      <button class="details-toggle" type="button" :aria-expanded="expanded" :aria-controls="`features-${tool.name}`" @click="expanded = !expanded">About this tool <ChevronDown :size="14" aria-hidden="true" /></button>
      <div :id="`features-${tool.name}`" class="details-content" :class="{ expanded }" :inert="!expanded" :aria-hidden="!expanded">
        <div class="details-inner">
        <ul><li v-for="feature in tool.features" :key="feature">{{ feature }}</li></ul>
        </div>
      </div>
    </div>
    <div class="tool-footer">
      <CommandCopy :text="commandFor(tool)" :accessible-label="`Copy command for ${tool.displayName}`">
        <template #actions>
          <CommandCopy :text="tool.name" label="Copy name" :accessible-label="`Copy ${tool.displayName} script name`" :show-code="false" icon-only>
            <template #icon><Tag :size="15" aria-hidden="true" /></template>
          </CommandCopy>
          <a class="copy-button action-icon" :href="`/${tool.name}.txt`" target="_blank" rel="noopener noreferrer" :aria-label="`View ${tool.displayName} script (opens in a new tab)`" data-tooltip="View script"><Code :size="16" aria-hidden="true" /></a>
        </template>
      </CommandCopy>
    </div>
  </article>
</template>
