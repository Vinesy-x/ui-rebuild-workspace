<!--
  JobPromoSplash · 共享组件
  出现帧: 0041 工作促销
  黄字标题 + 立绘 + 月薪高亮，无 CTA
  tap 黄 ⚠ 工作卡触发，splash 后跳 0040 工作详情 modal
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
interface Props {
  jobName: string
  illu?: string
  monthlyWage: number
  nextModalName?: string   // 默认: job-detail
}
const props = withDefaults(defineProps<Props>(), { nextModalName: 'job-detail' })
const store = useModalStore()
function tap() {
  store.open(props.nextModalName as any, { jobName: props.jobName })
}
</script>

<template>
  <div class="promo" @click="tap">
    <div class="badge">促销</div>
    <h1>{{ jobName }}</h1>
    <div class="illu"><img v-if="illu" :src="illu"/></div>
    <div class="wage">
      <span class="seal">銅</span>
      <span class="num">{{ monthlyWage }}</span>
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
  padding: 24px;
  display: flex; flex-direction: column;
  align-items: center; gap: 16px;
}
.badge {
  background: var(--ink-1); color: var(--amber);
  padding: 4px 14px; border-radius: 4px;
  font-family: var(--font-display); letter-spacing: .2em;
}
h1 {
  font-family: var(--font-display);
  color: var(--amber);
  font-size: 32px; margin: 0;
  text-shadow: 0 2px 0 var(--ink-1);
}
.illu { width: 200px; height: 200px; background: var(--paper-2); border: 1px solid var(--paper-edge); border-radius: 6px; }
.wage { display: flex; align-items: baseline; gap: 6px; }
.wage .seal { background: var(--cur-coin); color: var(--paper-1); padding: 2px 8px; border-radius: 3px; font-family: var(--font-display); }
.wage .num { font-family: var(--font-display); font-size: 36px; color: var(--ink-1); }
.wage .unit { color: var(--ink-3); font-size: 14px; }
</style>
