<!--
  ProgressListDialog · 共享组件 (1/8)
  出现帧: 0123 心境 + 0126 體魄
  hero 图 + +50% 按钮 + 6 行 list(name / cost / +% / cd)
-->
<script setup lang="ts">
interface Row { icon: string; name: string; cost?: number|string; gain: string; cd?: string; locked?: boolean }
interface Props { kind: 'mood'|'health'; title: string; hero?: string; boost?: string; rows: Row[] }
defineProps<Props>()
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar"><span>{{ title }}</span><button class="close" @click="store.close()">✕</button></div>
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

<style>
.hero {
    height: 130px;
    background: var(--paper-2);
    border: 1px solid var(--paper-edge);
    border-radius: 6px;
    position: relative;
    margin-bottom: 12px;
    overflow: hidden;
  }

.hero .hero-illu {
    position: absolute; inset: 0;
    display: grid; place-items: center;
    color: var(--ink-3);
    font-family: ui-monospace, monospace;
    font-size: var(--fs-label);
    background:
      repeating-linear-gradient(45deg,
        transparent 0 10px,
        rgba(139,111,71,.1) 10px 12px);
  }

.hero .boost {
    position: absolute;
    right: 12px; bottom: 12px;
    background: var(--jade);
    color: var(--paper-1);
    font-family: var(--font-display);
    font-size: var(--fs-h2);
    padding: 6px 14px;
    border-radius: 999px;
    border: 1.5px solid var(--ink-1);
  }

.plist { display: flex; flex-direction: column; gap: 6px; }

.prow {
    display: grid;
    grid-template-columns: 32px 1fr auto auto;
    gap: 10px;
    align-items: center;
    padding: 8px;
    background: var(--paper-2);
    border: 1px solid var(--paper-edge);
    border-radius: 6px;
  }

.prow.locked { opacity: .55; }

.prow .pic {
    width: 28px; height: 28px;
    background: var(--celadon-2);
    border: 1px solid var(--celadon-3);
    border-radius: 4px;
    display: grid; place-items: center;
    font-family: var(--font-display);
    font-size: var(--fs-body);
    color: var(--ink-1);
  }

.prow .name { font-family: var(--font-display); font-size: var(--fs-label); color: var(--ink-1); }

.prow .cost { font-family: var(--font-num); font-size: var(--fs-label); color: var(--ink-3); }

.prow .gain {
    font-family: var(--font-num);
    font-size: var(--fs-label);
    color: var(--paper-1);
    background: var(--cur-mood);
    border: 1px solid var(--ink-1);
    padding: 3px 10px;
    border-radius: 4px;
    min-width: 60px;
    text-align: center;
  }

.prow.health .gain { background: var(--cur-heart); color: var(--paper-1); }

.prow .cd {
    background: var(--ink-4);
    color: var(--paper-1);
    padding: 3px 10px;
    border-radius: var(--r-pill);
    font-family: var(--font-num);
    font-size: var(--fs-label);
  }
</style>
