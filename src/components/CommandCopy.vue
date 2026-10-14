<script setup>
import { onBeforeUnmount, ref } from 'vue'
import { Check, Copy } from '@lucide/vue'

const props = defineProps({
  text: { type: String, required: true },
  label: { type: String, default: 'Copy command' },
  accessibleLabel: { type: String, default: '' },
  showCode: { type: Boolean, default: true },
  iconOnly: Boolean,
})
const state = ref('idle')
const code = ref(null)
let timer

async function copy() {
  clearTimeout(timer)
  try {
    await navigator.clipboard.writeText(props.text)
    state.value = 'copied'
    timer = setTimeout(() => { state.value = 'idle' }, 2500)
  } catch {
    state.value = 'failed'
    if (code.value) {
      const range = document.createRange()
      range.selectNodeContents(code.value)
      const selection = window.getSelection()
      selection.removeAllRanges()
      selection.addRange(range)
      code.value.focus()
    }
  }
}

onBeforeUnmount(() => clearTimeout(timer))
</script>

<template>
  <div class="command-copy" :class="{ 'button-only': !showCode }">
    <code v-if="showCode" ref="code" tabindex="0">{{ text }}</code>
    <div class="command-actions">
    <button class="copy-button" :class="{ 'action-icon': iconOnly }" :data-tooltip="iconOnly ? (state === 'copied' ? 'Copied!' : label) : undefined" type="button" :aria-label="accessibleLabel || label" @click="copy">
      <Check v-if="state === 'copied'" :size="15" aria-hidden="true" />
      <slot v-else name="icon"><Copy :size="15" aria-hidden="true" /></slot>
      <span :class="{ 'sr-only': iconOnly }">{{ state === 'copied' ? 'Copied!' : label }}</span>
    </button>
    <slot name="actions" />
    </div>
    <span class="copy-status" :class="{ 'copy-error': state === 'failed' }" role="status">
      <template v-if="state === 'failed'">Clipboard unavailable. Select {{ showCode ? 'the command' : text }} and copy it manually.</template>
      <span v-else class="sr-only">{{ state === 'copied' ? 'Copied to clipboard.' : '' }}</span>
    </span>
  </div>
</template>
