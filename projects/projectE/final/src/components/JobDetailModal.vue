<!--
  JobDetailModal · 共享组件 (8/8 · v2 canonical 新增)
  出现帧: 0037 焊工 + 0040 汽车修理工 + 后续所有工种
  立绘 (工坊/建筑图标) + 5-6 项 requirements + 绿 '接受' CTA
  ⚠️ v2 canonical 校正：0037 不是主菜单 NPC tap 触发，是工作 Tab → 工作 list → 点工作卡触发的标准工作详情 modal。
-->
<script setup lang="ts">
interface Requirement { icon: string; label: string; value?: string | number; satisfied: boolean }
interface Props {
  jobKey: string
  jobName: string
  monthlyWage?: number
  illu?: string
  requirements: Requirement[]
}
defineProps<Props>()
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()
</script>

<template>
  <div class="modal modal--lg">
    <div class="modal-bar">
      <span>{{ jobName }}</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body scroll">
      <div class="req-illu">
        <img v-if="illu" :src="illu" alt=""/>
        <template v-else>立绘 placeholder · 工坊+红柄工具 (Phase B 替换)</template>
      </div>
      <div v-if="monthlyWage" class="req-title">{{ jobName }} · 月入 {{ monthlyWage.toLocaleString() }}</div>
      <div v-else class="req-title">{{ jobName }}</div>
      <div class="req-sub">齊備諸條，可入此行</div>
      <div class="reqs">
        <div v-for="(r, i) in requirements" :key="i" class="req">
          <span class="picon">{{ r.icon }}</span>
          <span class="name">{{ r.label }}<span v-if="r.value" class="num">{{ r.value }}</span></span>
          <span v-if="r.satisfied" class="state-ok">✓</span>
          <span v-else class="state-go">前往</span>
        </div>
      </div>
      <button class="accept-cta" @click="store.close()">受 · 立此为约</button>
    </div>
  </div>
</template>

<style>
.req-illu {
    height: 110px;
    background: var(--paper-2);
    border: 1px solid var(--paper-edge);
    border-radius: 6px;
    margin-bottom: 12px;
    position: relative;
    display: grid; place-items: center;
    font-family: ui-monospace, monospace;
    font-size: var(--fs-label);
    color: var(--ink-3);
    background-image: repeating-linear-gradient(45deg, transparent 0 10px, rgba(139,111,71,.1) 10px 12px);
  }

.req-title {
    font-family: var(--font-display);
    font-size: var(--fs-h2);
    color: var(--ink-1);
    text-align: center;
    margin-bottom: 6px;
  }

.req-sub { text-align: center; font-size: var(--fs-label); color: var(--ink-3); margin-bottom: 10px; }

.reqs { display: flex; flex-direction: column; gap: 6px; }

.req {
    display: grid;
    grid-template-columns: 28px 1fr auto;
    gap: 8px;
    padding: 8px 10px;
    background: var(--paper-2);
    border: 1px solid var(--paper-edge);
    border-radius: 6px;
    align-items: center;
  }

.req .picon {
    width: 24px; height: 24px;
    background: var(--celadon-3);
    color: var(--paper-1);
    border-radius: 4px;
    display: grid; place-items: center;
    font-family: var(--font-display);
    font-size: var(--fs-label);
  }

.req .name { font-family: var(--font-display); font-size: var(--fs-label); color: var(--ink-1); }

.req .name .num { font-family: var(--font-num); color: var(--ink-3); margin-left: 6px; font-size: var(--fs-label); }

.req .state-ok {
    width: 22px; height: 22px;
    background: var(--jade);
    color: var(--paper-1);
    border-radius: 50%;
    display: grid; place-items: center;
    font-size: var(--fs-label); line-height: 1;
  }

.req .state-go {
    background: var(--azure);
    color: var(--paper-1);
    font-family: var(--font-display);
    padding: 3px 12px;
    border-radius: var(--r-pill);
    font-size: var(--fs-label);
  }
.accept-cta {
    margin-top: 12px;
    width: 100%;
    background: var(--jade);
    color: var(--paper-1);
    border: 1.5px solid var(--ink-1);
    padding: 10px;
    border-radius: 8px;
    font-family: var(--font-display);
    font-size: var(--fs-h2);
    cursor: pointer;
    box-shadow: 0 3px 0 var(--ink-1);
  }

.accept-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }

/* .reputation / .goal-row / .gicon / .gbang / .gact / .gdone / .set-row / .toggle / .ver 等
   全部走全局 styles/components.css(原 JobDetailModal 的全局泄漏已收紧) */
</style>
