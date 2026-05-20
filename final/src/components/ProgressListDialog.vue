<!--
  ProgressListDialog · 共享组件
  出现帧: 0123 心境 + 0126 體魄
  hero 图 + +N% 按钮 + 6 行 list(name/cost/+%/cd)
  动态 NPC 气泡（满值庆祝时显示）
-->
<script setup lang="ts">
interface Row {
  icon: string         // 印章 glyph 字符
  name: string
  cost?: number | string
  gain: string
  cd?: string          // cooldown "00:02"
  locked?: boolean
}
interface Props {
  kind: 'mood' | 'health'
  title: string
  hero?: string        // 立绘 src
  boost?: string       // "+50%"
  rows: Row[]
}
const props = defineProps<Props>()
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()
</script>

<template>
  <div class="modal">
    <div class="modal-bar">
      <span>{{ title }}</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body">
      <div class="hero">
        <img v-if="hero" :src="hero" alt=""/>
        <div v-else class="hero-illu">hero 立绘 placeholder</div>
        <div v-if="boost" class="boost">{{ boost }}</div>
      </div>
      <div class="plist">
        <div v-for="(r, i) in rows" :key="i" class="prow" :class="{ locked: r.locked, health: kind==='health' }">
          <span class="pic">{{ r.icon }}</span>
          <div>
            <div class="name">{{ r.name }}</div>
            <div class="cost">{{ r.cost ?? '免费' }}</div>
          </div>
          <div class="gain">{{ r.gain }}</div>
          <div v-if="r.cd" class="cd">{{ r.cd }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 引 tokens.css 全局 + .modal .modal-bar .modal-body .hero .plist .prow */
</style>
