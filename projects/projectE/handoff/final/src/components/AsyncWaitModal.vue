<!--
  AsyncWaitModal · 共享组件 (4/8)
  出现帧: 0067 → 0068 → 0069 卖车 3 步
-->
<script setup lang="ts">
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Props {
  title: string
  itemName: string
  itemIllu?: string
  basePrice: number
  priceMultiplier?: number
}
const props = withDefaults(defineProps<Props>(), { priceMultiplier: 1.47 })
const step = ref<'init'|'loading'|'offer'>('init')
const store = useModalStore()
const offer = () => Math.round(props.basePrice * props.priceMultiplier)
function search() { step.value = 'loading'; setTimeout(() => step.value = 'offer', 1000) }
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar"><span>{{ title }}</span><button class="close" @click="store.close()">✕</button></div>
    <div class="modal-body">
      <template v-if="step==='init'">
        <p class="lead">让我们为我的宝贝找一个买家</p>
        <div class="item-illu"><img v-if="itemIllu" :src="itemIllu"/></div>
        <button class="accept-cta" @click="search">搜索</button>
      </template>
      <template v-else-if="step==='loading'">
        <div class="spinner">○ ○ ○</div>
        <p class="lead muted">寻觅买家中…</p>
      </template>
      <template v-else>
        <div class="buyer-illu">买家 placeholder</div>
        <p class="lead">我想要你的车以这个价格:</p>
        <div class="offer-price">{{ offer() }}</div>
        <div class="actions">
          <button class="btn-reject" @click="search">再次搜索</button>
          <button class="accept-cta inline" @click="store.close()">卖</button>
        </div>
      </template>
    </div>
  </div>
</template>

<style scoped>
.lead { font-family: var(--font-display); font-size: var(--fs-body); color: var(--ink-1); text-align: center; margin: 12px 0; }
.lead.muted { color: var(--ink-3); }
.item-illu, .buyer-illu {
  height: 200px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  margin: 12px 0;
  display: grid; place-items: center;
  font-family: ui-monospace, monospace;
  font-size: var(--fs-mono);
  color: var(--ink-3);
  background-image: repeating-linear-gradient(45deg, transparent 0 10px, rgba(139,111,71,.1) 10px 12px);
}
.spinner {
  text-align: center; font-size: 36px; color: var(--ink-3);
  letter-spacing: .4em; margin: 60px 0;
  animation: spin 1.2s ease-in-out infinite;
}
@keyframes spin { 50% { opacity: .3 } }
.offer-price {
  text-align: center;
  font-family: var(--font-display); font-size: 36px;
  color: var(--cinnabar-1); font-weight: 700;
  margin: 16px 0;
}
.actions { display: flex; gap: 10px; }
.btn-reject {
  flex: 1;
  background: var(--paper-1); color: var(--fail-red);
  border: 1.5px solid var(--fail-red);
  padding: 10px; border-radius: 8px;
  font-family: var(--font-display); font-size: var(--fs-body);
  cursor: pointer;
}
.accept-cta.inline { flex: 1; }
</style>
