<!--
  PurchaseConfirmModal · 共享组件 (3/8)
  出现帧: 0075 住房 + 0082 食物 + 大件 (购买后触发 cinematic)
-->
<script setup lang="ts">
interface Bonus { icon: string; text: string; positive?: boolean }
interface Props {
  title: string
  illu?: string
  price: number|string
  currency: 'coin'|'jade'|'brick'
  bonuses: Bonus[]
  cta?: string
  triggersCinematic?: boolean
}
const props = withDefaults(defineProps<Props>(), { cta: '购买' })
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()
function confirm() {
  if (props.triggersCinematic) store.open('cinematic', { item: props.title })
  else store.close()
}
const sealGlyph = { coin: '銅', jade: '玉', brick: '磚' }[props.currency]
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar"><span>{{ title }}</span><button class="close" @click="store.close()">✕</button></div>
    <div class="modal-body">
      <div class="purchase-illu">
        <img v-if="illu" :src="illu" alt=""/>
        <div v-else class="ph">立绘 placeholder · {{ title }}</div>
      </div>
      <div class="price-row">
        <span class="ic-seal" :class="`ic-${currency==='coin'?'coin':currency==='jade'?'jade':'brick'}`">{{ sealGlyph }}</span>
        <span class="num">{{ price }}</span>
      </div>
      <ul class="bonuses">
        <li v-for="(b, i) in bonuses" :key="i" :class="{negative: b.positive===false}">
          <span class="pic">{{ b.icon }}</span>{{ b.text }}
        </li>
      </ul>
      <button class="accept-cta" @click="confirm">{{ cta }}</button>
    </div>
  </div>
</template>

<style scoped>
.purchase-illu {
  height: 200px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  margin-bottom: 14px;
  display: grid; place-items: center;
  background-image: repeating-linear-gradient(45deg, transparent 0 10px, rgba(139,111,71,.1) 10px 12px);
}
.purchase-illu .ph { font-family: ui-monospace, monospace; font-size: var(--fs-mono); color: var(--ink-3); }
.price-row {
  display: flex; align-items: center; gap: 10px;
  margin: 0 0 12px;
}
.price-row .num { font-family: var(--font-display); font-size: var(--fs-h1); color: var(--ink-1); font-weight: 700; }
.bonuses {
  list-style: none; padding: 0; margin: 0 0 14px;
  display: flex; flex-direction: column; gap: 6px;
}
.bonuses li {
  display: flex; align-items: center; gap: 8px;
  font-family: var(--font-display); font-size: var(--fs-label); color: var(--jade);
}
.bonuses li.negative { color: var(--fail-red); }
.bonuses .pic { font-family: var(--font-display); font-size: var(--fs-body); }
</style>
