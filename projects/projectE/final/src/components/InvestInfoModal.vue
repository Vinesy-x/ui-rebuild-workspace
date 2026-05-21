<!--
  InvestInfoModal · 共享组件 (T-B5 · 2026-05-21)
  出现帧: fps_0059 银行 ⓘ → "信息" popup
  - 标题"信息"
  - 古风化文案 · cashback / freebie / premium / broker 4 种
  - 绿 "接受" CTA → 关闭

  ⚠️ canonical 来自 design-brief/flows/screen-details.md fps_0059:
     "所有支出均可获得返现。花得越多,返现越多"
     "cashback 全屏花费触发,不限投资本身"
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'

interface Props {
  msg?: 'cashback' | 'freebie' | 'premium' | 'broker' | string
  customMsg?: string
}
const props = withDefaults(defineProps<Props>(), { msg: 'cashback' })
const store = useModalStore()

const MSG_LIB: Record<string, string> = {
  cashback: '所有支出皆得回返。<br/>花得越多，返得越多。',
  freebie:  '每番贈本，皆隨機商號股本一组。',
  premium:  '上戶銀牌一旦持有，X2 諸般收益。',
  broker:   '自動經紀代你買賣，安坐喫茶而望市。'
}

const body = computed(() => props.customMsg || MSG_LIB[props.msg] || MSG_LIB.cashback)
</script>

<template>
  <div class="modal modal--sm">
    <div class="modal-bar">
      <span>信&nbsp;息</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body inv-info-body">
      <p v-html="body"></p>
      <button class="inv-info-accept" @click="store.close()">接&nbsp;受</button>
    </div>
  </div>
</template>

<style scoped>
.inv-info-body {
  text-align: center;
  padding: 24px 12px;
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 24px;
}
.inv-info-body p {
  font-family: var(--font-display);
  font-size: var(--fs-body);
  color: var(--ink-1);
  line-height: 1.8;
  margin: 0;
  letter-spacing: .04em;
}
.inv-info-accept {
  background: var(--jade); color: var(--paper-1);
  border: 1.5px solid var(--ink-1); border-radius: 8px;
  padding: 10px 36px;
  font-family: var(--font-display); font-size: var(--fs-h2);
  letter-spacing: .2em; cursor: pointer;
  box-shadow: 0 3px 0 var(--ink-1);
  transition: transform var(--dur-fast) var(--ease-out);
}
.inv-info-accept:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }
</style>
