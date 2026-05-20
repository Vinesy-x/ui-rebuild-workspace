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
.modal-pane { display: flex; flex-direction: column; height: 100%; gap: 12px; }
.mg-hero {
  height: 300px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 8px;
  background-image: repeating-linear-gradient(45deg, transparent 0 10px, rgba(139,111,71,.1) 10px 12px);
  display: grid; place-items: center;
  color: var(--ink-3);
  font-family: ui-monospace, monospace;
  font-size: 13px;
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
.pane-cta-row {
  margin-top: auto;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}
.pane-cta {
  padding: 13px;
  border-radius: 10px;
  font-family: var(--font-display);
  font-size: 22px;
  letter-spacing: .12em;
  cursor: pointer;
  border: 1.5px solid var(--ink-1);
  box-shadow: 0 3px 0 var(--ink-1);
  transition: transform var(--dur-fast) var(--ease-out), box-shadow var(--dur-fast) var(--ease-out);
  display: inline-flex; align-items: center; justify-content: center; gap: 8px;
}
.pane-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }
.pane-cta.ghost   { background: var(--paper-1); color: var(--azure); }
.pane-cta.primary { background: var(--jade);    color: var(--paper-1); }
.pane-cta.primary .seal-jade {
  background: var(--cur-jade); color: var(--paper-1);
  width: 22px; height: 22px; font-size: 14px;
  border-radius: 3px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}
.pane-cta.primary .num { font-family: var(--font-num); letter-spacing: 0; font-size: 18px; }
</style>
