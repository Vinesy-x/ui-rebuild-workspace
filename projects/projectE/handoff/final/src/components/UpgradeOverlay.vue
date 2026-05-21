<!--
  UpgradeOverlay · 共享组件 (6/8)
  出现帧: 0014 亲疏度升级
  全屏粉心 ✨ + 段位大字 + 1-2 秒自动消失
-->
<script setup lang="ts">
import { onMounted } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Props { motif?: 'heart'|'crown'|'star'; label: string; autoMs?: number }
const props = withDefaults(defineProps<Props>(), { motif: 'heart', autoMs: 1500 })
const store = useModalStore()
onMounted(() => { setTimeout(() => store.close(), props.autoMs) })
</script>

<template>
  <div class="upgrade-overlay" :data-motif="motif">
    <div class="motif">
      <span v-if="motif==='heart'" class="heart"></span>
      <span v-else-if="motif==='crown'" class="crown">皇</span>
      <span v-else class="star">★</span>
    </div>
    <div class="label">{{ label }}</div>
  </div>
</template>

<style scoped>
.upgrade-overlay {
  position: fixed; inset: 0;
  background: rgba(31,27,20,.55);
  backdrop-filter: blur(6px);
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  z-index: 70;
}
.motif { animation: pop .5s cubic-bezier(.34,1.56,.64,1); }
.heart {
  display: block; width: 140px; height: 140px;
  background: #FF7B96;
  clip-path: polygon(50% 100%, 0 38%, 25% 0, 50% 25%, 75% 0, 100% 38%);
  filter: drop-shadow(0 0 28px #FF7B96);
}
.label {
  font-family: var(--font-display);
  font-size: var(--fs-overlay);
  color: var(--paper-1);
  letter-spacing: .2em;
  margin-top: 28px;
  text-shadow: 0 4px 12px rgba(0,0,0,.5);
}
@keyframes pop { 0%{transform:scale(.3);opacity:0} 60%{transform:scale(1.1);opacity:1} 100%{transform:scale(1)} }
</style>
