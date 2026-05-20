<!--
  OptionPickerModal · 共享组件 (2/8)
  出现帧: 0020 礼物 + 0022 约会
  list + 推荐 ✓ (可选) + "接受" CTA
-->
<script setup lang="ts">
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
interface Option { icon: string; name: string; price: string; recommended?: boolean }
interface Props { title: string; options: Option[]; showRecommend?: boolean; acceptLabel?: string }
const props = withDefaults(defineProps<Props>(), { showRecommend: true, acceptLabel: '接受' })
const store = useModalStore()
const selected = ref<number>(
  props.showRecommend ? Math.max(0, props.options.findIndex(o => o.recommended)) : 0
)
const emit = defineEmits<{ (e: 'accept', idx: number): void }>()
function accept() { emit('accept', selected.value); store.close() }
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar"><span>{{ title }}</span><button class="close" @click="store.close()">✕</button></div>
    <div class="modal-body">
      <div v-for="(o, i) in options" :key="i" class="opt" :class="{active: selected===i}" @click="selected = i">
        <span class="pic">{{ o.icon }}</span>
        <span class="name">{{ o.name }}</span>
        <span class="price">{{ o.price }}</span>
        <span v-if="showRecommend && o.recommended" class="rec">✓</span>
      </div>
      <button class="accept-cta" @click="accept">{{ acceptLabel }}</button>
    </div>
  </div>
</template>

<style scoped>
.opt {
  display: grid;
  grid-template-columns: 32px 1fr auto 28px;
  gap: 12px;
  align-items: center;
  padding: 10px 12px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  margin-bottom: 8px;
  cursor: pointer;
}
.opt.active { border-color: var(--cinnabar-1); box-shadow: 0 0 0 1px var(--cinnabar-1); }
.opt .pic { font-family: var(--font-display); font-size: 20px; }
.opt .name { font-family: var(--font-display); font-size: 18px; color: var(--ink-1); }
.opt .price { font-family: var(--font-num); font-size: 16px; color: var(--cur-coin); }
.opt .rec {
  width: 22px; height: 22px;
  background: var(--jade); color: var(--paper-1);
  border-radius: 50%; display: grid; place-items: center;
  font-size: 14px;
}
</style>
