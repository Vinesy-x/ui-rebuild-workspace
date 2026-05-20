<!--
  BizHireModal · fps_0050 雇掌櫃 modal (Phase B T-B4)
  modal-pane 通用模板:立绘 + copy "掌櫃自代收銀,離身亦運" + 2 CTA (罷了 / 玉<cost>)
  触发自 BusinessList "+"灰虚框 click (no-mgr 业务: hua 花坊)
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
interface Props { bizKey: string; name: string; hireCost: string; illu?: string }
defineProps<Props>()
const store = useModalStore()
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar">
      <span>掌&nbsp;&nbsp;櫃</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body">
      <div class="modal-pane">
        <div class="mg-hero">立绘 placeholder<br/>{{ name }} 掌櫃</div>
        <p class="mg-copy">掌櫃自代收銀,離身亦運。</p>
        <div class="pane-cta-row">
          <button class="pane-cta ghost" @click="store.close()">罷&nbsp;了</button>
          <button class="pane-cta primary" @click="store.close()">
            <span class="seal-jade">玉</span>
            <span class="num">{{ hireCost }}</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* .modal-pane / .pane-cta / .pane-cta-row / .pane-cta.ghost / .pane-cta.primary 走全局 components.css */

.mg-hero {
  height: 300px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 8px;
  background-image: repeating-linear-gradient(45deg, transparent 0 10px, rgba(139,111,71,.1) 10px 12px);
  display: grid; place-items: center;
  color: var(--ink-3);
  font-family: ui-monospace, monospace;
  font-size: var(--fs-mono);
  text-align: center;
  padding: 8px;
}
.mg-copy {
  text-align: center;
  font-family: var(--font-display);
  font-size: var(--fs-body);
  color: var(--ink-1);
  margin: 0;
  letter-spacing: .04em;
}
.pane-cta.primary :deep(.seal-jade),
.pane-cta.primary .seal-jade {
  background: var(--cur-jade); color: var(--paper-1);
  width: 22px; height: 22px; font-size: var(--fs-mono);
  border-radius: 3px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}
.pane-cta.primary .num { font-family: var(--font-num); letter-spacing: 0; font-size: var(--fs-body); }
</style>
