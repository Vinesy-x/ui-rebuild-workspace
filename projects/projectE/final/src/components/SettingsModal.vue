<!--
  SettingsModal · 全局设定 modal (Phase A globals)
  触发自 HudBar 齿轮 ⚙ button
  1:1 复刻 HTML 真值 L4094-4112 · 用 JobDetailModal.vue 的全局 .set-row / .toggle / .ver classes
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()

const rows = [
  { ic: '通', name: '通知',           tone: 'on' },
  { ic: '聲', name: '声音',           tone: 'on' },
  { ic: '樂', name: '音乐',           tone: 'on' },
  { ic: '震', name: '触觉',           tone: 'on' }
]
</script>

<template>
  <div class="modal modal--lg">
    <div class="modal-bar">
      <span>設定</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body scroll">
      <div v-for="r in rows" :key="r.name" class="set-row">
        <span class="lab"><span class="ico">{{ r.ic }}</span>{{ r.name }}</span>
        <span class="toggle"></span>
      </div>
      <div class="set-row">
        <span class="lab"><span class="ico">語</span>语言</span>
        <span class="lang-val">中文 ✏</span>
      </div>
      <div class="set-row">
        <span class="lab"><span class="ico">D</span>江湖（Discord）</span>
        <span class="discord-cta">加入</span>
      </div>

      <div class="btn-col">
        <button class="ghost-btn">私隐文契</button>
        <button class="ghost-btn">使用条款</button>
        <button class="ghost-btn">取消订阅</button>
        <button class="reset-btn">新开一局（重置）</button>
      </div>

      <div class="ver">大掌柜 · v1.9.540 11.2_STAGE<br/>UUID CC9A37BB-97DA-45D0-B322-FBC97F3FDB48</div>
    </div>
  </div>
</template>

<style scoped>
.set-row .lab { display: flex; align-items: center; }
.set-row .lang-val { font-family: var(--font-display); color: var(--ink-3); }
.set-row .discord-cta {
  background: var(--cur-jade); color: var(--paper-1);
  padding: 4px 12px; border-radius: var(--r-pill); font-size: 18px;
  font-family: var(--font-display);
}
.btn-col {
  display: flex; flex-direction: column;
  gap: 8px; padding: 10px 0;
}
.ghost-btn {
  padding: 8px;
  background: var(--paper-1);
  border: 1px solid var(--azure);
  color: var(--azure);
  font-family: var(--font-display);
  font-size: 15px;
  border-radius: 6px;
  cursor: pointer;
}
.reset-btn {
  padding: 10px;
  background: var(--azure);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  font-family: var(--font-display);
  font-size: 17px;
  border-radius: 8px;
  cursor: pointer;
  margin-top: 6px;
}
</style>
