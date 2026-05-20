<!--
  AsyncWaitModal · 共享组件
  出现帧: 0067 → 0068 → 0069 卖车 3 步
  step 'init'   = 启动 (title + illu + 绿"搜索")
  step 'loading'= ∞ loading 圆点 (日历推 1 天)
  step 'offer'  = 买家立绘 + 出价 + 红"再次搜索" / 绿"卖"
-->
<script setup lang="ts">
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Props {
  title: string
  itemName: string
  itemIllu?: string
  basePrice: number
  priceMultiplier?: number   // 出价倍率 (eg 1.47)
}
const props = withDefaults(defineProps<Props>(), { priceMultiplier: 1.47 })
const step = ref<'init'|'loading'|'offer'>('init')
const store = useModalStore()

const offer = () => Math.round(props.basePrice * props.priceMultiplier)

function search() {
  step.value = 'loading'
  // demo: 1s loading
  setTimeout(() => { step.value = 'offer' }, 1000)
}
</script>

<template>
  <div class="modal">
    <div class="modal-bar">
      <span>{{ title }}</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body">
      <!-- step 1: init -->
      <template v-if="step==='init'">
        <p class="lead">让我们为我的宝贝找一个买家</p>
        <div class="item-illu"><img v-if="itemIllu" :src="itemIllu"/></div>
        <button class="accept-cta" @click="search">搜索</button>
      </template>

      <!-- step 2: loading -->
      <template v-else-if="step==='loading'">
        <div class="spinner">○ ○ ○</div>
        <p class="lead muted">寻觅买家中…</p>
      </template>

      <!-- step 3: offer -->
      <template v-else>
        <div class="buyer-illu">买家 placeholder</div>
        <p class="lead">我想要你的车以这个价格:</p>
        <div class="offer-price">{{ offer() }}</div>
        <div class="actions">
          <button class="btn-reject" @click="step='loading'; search()">再次搜索</button>
          <button class="accept-cta inline" @click="store.close()">卖</button>
        </div>
      </template>
    </div>
  </div>
</template>
