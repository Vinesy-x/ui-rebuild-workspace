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

<style scoped>
.tabbar {
    background: var(--paper-2);
    border-top: 1.5px solid var(--gold-1);
    box-shadow: inset 0 1px 0 var(--paper-1);
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    padding: 6px 2px 10px;
    gap: 2px;
    z-index: 30;
  }

.tab {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    padding: 4px 0 0;
    cursor: pointer;
    user-select: none;
  }

.tab .glyph {
    width: 38px; height: 38px;
    border-radius: 50%;
    background: var(--celadon-2);
    border: 1.5px solid var(--celadon-3);
    display: grid; place-items: center;
    font-family: var(--font-display);
    font-size: 22px;
    color: var(--ink-1);
    box-shadow: inset 0 -3px 0 rgba(0,0,0,.08);
  }

.tab .glyph.active {
    background: var(--cinnabar-1);
    color: var(--paper-1);
    border-color: var(--cinnabar-3);
    box-shadow:
      inset 0 -3px 0 rgba(0,0,0,.18),
      0 0 0 2px var(--gold-1);
  }

.tab .lab {
    font-family: var(--font-display);
    font-size: var(--fs-label);
    color: var(--ink-2);
    letter-spacing: .04em;
  }

.tab .bang {
    position: absolute;
    top: 0; right: 22%;
    width: 14px; height: 14px;
    background: var(--cinnabar-1);
    color: var(--paper-1);
    border: 1.5px solid var(--paper-1);
    border-radius: 50%;
    font-family: var(--font-display);
    font-size: var(--fs-meta);
    display: grid; place-items: center;
    line-height: 1;
    z-index: 5;
  }
</style>
