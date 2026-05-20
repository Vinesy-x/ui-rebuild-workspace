<!--
  CinematicScene · 共享组件 (5/8)
  出现帧: 0077 购房成功过场
  全屏插画 · 无 UI chrome · 自动播放后返回
-->
<script setup lang="ts">
import { onMounted } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Props { illu?: string; actors?: string[]; item?: string; setting?: string; duration?: number }
const props = withDefaults(defineProps<Props>(), { duration: 2500 })
const store = useModalStore()
onMounted(() => { setTimeout(() => store.close(), props.duration) })
</script>

<template>
  <div class="cinematic-full">
    <img v-if="illu" :src="illu" class="bg" alt=""/>
    <div v-else class="placeholder">
      <p class="title">购买成功 · {{ item }}</p>
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
.placeholder { text-align: center; }
.title { font-family: var(--font-display); font-size: 36px; color: var(--gold-2); margin: 0; }
.ph { font-family: monospace; font-size: 14px; color: var(--ink-4); margin-top: 12px; }
</style>
