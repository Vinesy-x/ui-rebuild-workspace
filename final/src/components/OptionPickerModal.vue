<!--
  OptionPickerModal · 共享组件
  出现帧: 0020 礼物 + 0022 约会
  list + 推荐 ✓ (可选) + "接受" CTA
-->
<script setup lang="ts">
interface Option {
  icon: string
  name: string
  price: string
  recommended?: boolean
}
interface Props {
  title: string
  options: Option[]
  showRecommend?: boolean
  acceptLabel?: string
}
const props = withDefaults(defineProps<Props>(), {
  showRecommend: true,
  acceptLabel: '接受'
})
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
const store = useModalStore()
const selected = ref<number>(
  props.showRecommend ? props.options.findIndex(o => o.recommended) : 0
)
</script>

<template>
  <div class="modal">
    <div class="modal-bar">
      <span>{{ title }}</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body">
      <div v-for="(o, i) in options" :key="i"
           class="opt" :class="{active: selected===i}"
           @click="selected = i">
        <span class="pic">{{ o.icon }}</span>
        <span class="name">{{ o.name }}</span>
        <span class="price">{{ o.price }}</span>
        <span v-if="showRecommend && o.recommended" class="rec">✓</span>
      </div>
      <button class="accept-cta" @click="$emit('accept', selected); store.close()">
        {{ acceptLabel }}
      </button>
    </div>
  </div>
</template>
