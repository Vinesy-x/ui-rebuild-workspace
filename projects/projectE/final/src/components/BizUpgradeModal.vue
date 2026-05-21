<!--
  BizUpgradeModal · fps_0053 興擴 modal (Phase B T-B4)
  标题 = "<name>（級 <lv>)" · 立绘 + ↑ 进度条 + ⭐ + 月入 chip
  2 CTA: 廣 免費升 (看广告) + 銅 <upgradeCost>
  触发自 BusinessList 业务卡 click 或 "興擴" 按钮 click
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Props {
  bizKey: string; name: string; lv: string;
  income: number; delta: number; gain: number;
  stars: number; upgradeCost: string
}
const props = defineProps<Props>()
const store = useModalStore()
const gainPct = computed(() => Math.min(100, Math.round(props.gain * 2)))
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar">
      <span>{{ name }}&nbsp;(級&nbsp;{{ lv }})</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body">
      <div class="modal-pane up-pane">
        <div class="up-illu">立绘 placeholder<br/>{{ name }}</div>

        <div class="up-progress-row">
          <div class="up-arrow">↑</div>
          <div class="up-progress">
            <i :style="{ width: gainPct + '%' }" />
            <span class="up-progress-tag"><span class="ic-seal">銅</span>{{ gain.toFixed(1) }}</span>
          </div>
        </div>

        <div class="star-row up-stars-row">
          <span v-for="i in 5" :key="i" class="star star--md" :class="{ 'is-on': i <= stars }"></span>
        </div>

        <div class="up-income">
          <div class="lbl">月&nbsp;入</div>
          <div class="val">{{ income }}／月<small>+{{ delta }}</small></div>
        </div>

        <div class="pane-cta-row">
          <button class="pane-cta primary ad-cta" @click="store.close()">
            <span class="ad-tag">廣</span><span class="ad-label">免&nbsp;費&nbsp;升</span>
          </button>
          <button class="pane-cta primary" @click="store.close()">
            <span class="seal-coin">銅</span>
            <span class="num">{{ upgradeCost }}</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* .modal-pane / .pane-cta / .star / .star-row 走全局 components.css */

.up-illu {
  width: 160px; height: 160px;
  margin: 0 auto;
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 10px;
  background-image: repeating-linear-gradient(45deg, transparent 0 8px, rgba(139,111,71,.15) 8px 10px);
  display: grid; place-items: center;
  color: var(--ink-3);
  font-family: ui-monospace, monospace;
  font-size: 12px;
  text-align: center;
  padding: 6px;
}

.up-progress-row {
  display: grid;
  grid-template-columns: 40px 1fr;
  gap: 8px;
  align-items: center;
  width: 100%;
}
.up-arrow {
  width: 40px; height: 38px;
  background: var(--jade);
  border: 1.5px solid var(--ink-1);
  border-radius: 6px;
  display: grid; place-items: center;
  color: var(--paper-1);
  font-family: var(--font-display); font-size: 22px;
  box-shadow: 0 2px 0 var(--ink-1);
}
.up-progress {
  height: 24px;
  background: var(--paper-3);
  border: 1.5px solid var(--paper-edge);
  border-radius: var(--r-pill);
  position: relative;
  overflow: hidden;
}
.up-progress > i {
  display: block; height: 100%;
  background: linear-gradient(90deg, var(--jade), #7CA887);
  box-shadow: inset 0 1px 0 rgba(255,255,255,.25);
}
.up-progress-tag {
  position: absolute;
  right: 8px; top: 50%; transform: translateY(-50%);
  color: var(--paper-1);
  font-family: var(--font-num);
  font-size: var(--fs-meta);
  display: inline-flex; align-items: center; gap: 4px;
  text-shadow: 0 1px 0 rgba(0,0,0,.3);
}
.up-progress-tag .ic-seal {
  background: var(--cur-coin); color: var(--paper-1);
  width: 16px; height: 16px; font-size: 11px;
  border-radius: 2px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}

/* ⭐ row 居中(.star-row / .star / .star--md 走全局) */
.up-stars-row { width: 100%; justify-content: center; }

.up-income {
  background: var(--paper-1);
  border: 1.5px solid var(--paper-edge);
  border-radius: 10px;
  padding: 12px 16px;
  display: flex; align-items: center; justify-content: space-between;
}
.up-income .lbl {
  font-family: var(--font-display); font-size: var(--fs-h2);
  color: var(--ink-1); letter-spacing: .04em;
}
.up-income .val {
  font-family: var(--font-num);
  font-size: var(--fs-h1);
  color: var(--cinnabar-1);
  font-weight: 700;
  text-align: right;
  line-height: 1.15;
}
.up-income .val small {
  display: block;
  font-size: var(--fs-meta);
  color: var(--jade);
  font-family: var(--font-num);
  font-weight: 700;
  margin-top: 1px;
}

/* .pane-cta-row / .pane-cta 基础走全局 · 这里只补本 modal 的 ad-cta 装饰 */

.ad-tag {
  background: var(--amber);
  color: var(--ink-1);
  border: 1px solid var(--ink-1);
  border-radius: 3px;
  padding: 1px 5px;
  font-family: var(--font-display);
  font-size: var(--fs-mono);
  letter-spacing: 0;
  display: inline-grid; place-items: center;
  line-height: 1.2;
}
.ad-label { letter-spacing: .08em; }

.pane-cta .seal-coin {
  background: var(--cur-coin); color: var(--paper-1);
  width: 22px; height: 22px; font-size: var(--fs-mono);
  border-radius: 3px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}
.pane-cta .num { font-family: var(--font-num); letter-spacing: 0; font-size: var(--fs-body); }
</style>
