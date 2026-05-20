<!--
  BottomTabBar · 6 Tab 底栏
  技能 / 遇见 / 工作 / 业务 / 投资 / 物品
  Tab 3 + Tab 6 默认带红 ! 角标
-->
<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router'
const router = useRouter()
const route = useRoute()
const tabs = [
  { key: 'skill',    glyph: '技', label: '技能',     to: '/skill' },
  { key: 'meet',     glyph: '緣', label: '遇见',     to: '/meet' },
  { key: 'work',     glyph: '工', label: '工作',     to: '/work',     bang: true },
  { key: 'business', glyph: '商', label: '业务',     to: '/business' },
  { key: 'invest',   glyph: '票', label: '投资',     to: '/invest' },
  { key: 'items',    glyph: '物', label: '物品',     to: '/items',    bang: true }
]
</script>

<template>
  <nav class="tabbar">
    <div v-for="t in tabs" :key="t.key" class="tab" @click="router.push(t.to)">
      <span v-if="t.bang" class="bang">!</span>
      <div class="glyph" :class="{active: route.path === t.to}">{{ t.glyph }}</div>
      <div class="lab">{{ t.label }}</div>
    </div>
  </nav>
</template>
