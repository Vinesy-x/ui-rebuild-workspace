<!--
  ModalShell · 全局 modal 根容器
  - Teleport to body + 根据 useModalStore.currentModal 动态 mount 对应 modal
  - backdrop 由 modal 内部自己画(不在 shell 层画 scrim,避免跟 design 的 backdrop 叠加)
  -->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'
import SessionDoneModal from './SessionDoneModal.vue'

const store = useModalStore()

const map: Record<string, any> = {
  'session-done': SessionDoneModal
}
const current = computed(() => store.currentModal ? map[store.currentModal] : null)
</script>

<template>
  <Teleport to="body">
    <component v-if="current" :is="current" v-bind="store.props" />
  </Teleport>
</template>

<!--
  ⚠️ ModalShell 不再画 scrim · backdrop 由 modal 内部负责
  原因:design 沙箱的 modal 通常自带 backdrop · 双层叠加暗 + 模糊太重 ·
  把视觉权威完全交给 modal · ModalShell 只 mount + teleport
  modal 必须自带:position:fixed inset:0 · backdrop 颜色 · click outside 关闭(可选)
  -->

