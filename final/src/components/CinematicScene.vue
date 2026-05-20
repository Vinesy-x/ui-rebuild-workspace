<!--
  CinematicScene · 共享组件
  出现帧: 0077 购房成功过场
  无 UI chrome、全屏插画、自动播放后返回 (default 2500ms)
-->
<script setup lang="ts">
import { onMounted } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Props {
  illu?: string
  actors?: string[]
  item?: string
  setting?: string
  duration?: number
}
const props = withDefaults(defineProps<Props>(), { duration: 2500 })
const store = useModalStore()

onMounted(() => {
  setTimeout(() => store.close(), props.duration)
})
</script>

<template>
  <div class="cinematic-full">
    <img v-if="illu" :src="illu" class="bg"/>
    <div v-else class="placeholder">
      <p>购买成功 · {{ item }}</p>
      <p class="ph">cinematic placeholder · Phase B 替换全屏插画</p>
    </div>
  </div>
</template>

<style scoped>
.cinematic-full {
  position: fixed; inset: 0;
  background: var(--ink-1);
  z-index: 70;
  display: grid; place-items: center;
  color: var(--paper-1);
}
.bg { width: 100%; height: 100%; object-fit: cover; }
.placeholder { text-align: center; font-family: var(--font-display); font-size: 24px; }
.placeholder .ph { font-size: 11px; opacity: .5; font-family: monospace; margin-top: 8px; }
</style>
