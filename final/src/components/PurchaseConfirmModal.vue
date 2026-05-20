<!--
  PurchaseConfirmModal · 共享组件
  出现帧: 0075 住房 + 0082 食物
  大图 + 价 + 加成 + 绿"购买/接受" CTA + ✕
-->
<script setup lang="ts">
interface Bonus { icon: string; text: string; positive?: boolean }
interface Props {
  title: string
  illu?: string
  price: number | string
  currency: 'coin' | 'jade' | 'brick'
  bonuses: Bonus[]
  cta?: string          // "购买" / "接受"
  triggersCinematic?: boolean   // 0075 → 0077
}
const props = withDefaults(defineProps<Props>(), { cta: '购买' })
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()
function confirm() {
  if (props.triggersCinematic) {
    store.open('cinematic', { item: props.title })
  } else {
    store.close()
  }
}
</script>

<template>
  <div class="modal">
    <div class="modal-bar">
      <span>{{ title }}</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body">
      <div class="purchase-illu">
        <img v-if="illu" :src="illu" alt=""/>
        <div v-else class="ph">立绘 placeholder · {{ title }}</div>
      </div>
      <div class="price-row">
        <span :class="`cseal cseal-${currency}`">{{ currency==='coin'?'銅': currency==='jade'?'玉':'磚' }}</span>
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
