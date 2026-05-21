<!--
  JobPromoSplash · 共享组件 (7/8)
  出现帧: 0041 工作促销
  黑徽 '促销' + 黄字标题 + 立绘 + 月薪高亮 · 无 CTA
  tap 触发跳 JobDetailModal (0037/0040 同 widget)
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
interface Props {
  jobName: string
  illu?: string
  monthlyWage: number
  nextModalName?: string
  // 二次 tap 后转 detail 用的完整 props (自 WorkDAG promo 路径传入)
  nextProps?: Record<string, any>
}
const props = withDefaults(defineProps<Props>(), { nextModalName: 'job-detail' })
const store = useModalStore()
function tap() {
  // 优先用 nextProps · 否则回落到 jobName 单字段
  const fwd = props.nextProps || { jobName: props.jobName, monthlyWage: props.monthlyWage }
  store.open(props.nextModalName as any, fwd)
}
</script>

<template>
  <div class="promo" @click="tap">
    <div class="badge">促 销</div>
    <h1>{{ jobName }}</h1>
    <div class="illu">
      <img v-if="illu" :src="illu" alt=""/>
      <span v-else class="ph">立绘 placeholder</span>
    </div>
    <div class="wage">
      <span class="seal">銅</span>
      <span class="num">{{ monthlyWage.toLocaleString() }}</span>
      <span class="unit">/月</span>
    </div>
  </div>
</template>

<style scoped>
.promo {
  position: fixed; inset: 16px;
  z-index: 65;
  background: var(--paper-1);
  border: 2px solid var(--amber);
  border-radius: 10px;
  padding: 28px;
  display: flex; flex-direction: column;
  align-items: center; gap: 18px;
  cursor: pointer;
}
.badge {
  background: var(--ink-1); color: var(--amber);
  padding: 6px 18px; border-radius: 4px;
  font-family: var(--font-display); letter-spacing: .3em; font-size: var(--fs-label);
}
h1 {
  font-family: var(--font-display);
  color: var(--amber);
  font-size: var(--fs-overlay); margin: 0;
  text-shadow: 0 2px 0 var(--ink-1);
}
.illu {
  width: 220px; height: 220px;
  background: var(--paper-2); border: 1px solid var(--paper-edge);
  border-radius: 6px;
  display: grid; place-items: center;
  background-image: repeating-linear-gradient(45deg, transparent 0 10px, rgba(139,111,71,.1) 10px 12px);
}
.illu .ph { font-family: monospace; font-size: var(--fs-mono); color: var(--ink-3); }
.wage { display: flex; align-items: baseline; gap: 8px; }
.wage .seal {
  background: var(--cur-coin); color: var(--paper-1);
  padding: 4px 10px; border-radius: 3px;
  font-family: var(--font-display); font-size: var(--fs-h2);
}
.wage .num { font-family: var(--font-display); font-size: 44px; color: var(--ink-1); font-weight: 700; }
.wage .unit { color: var(--ink-3); font-size: var(--fs-label); }
</style>
