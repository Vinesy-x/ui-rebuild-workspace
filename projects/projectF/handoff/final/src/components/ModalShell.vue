<!--
  ModalShell · 全局 modal 根容器
  跟 projectE 一致:scrim + backdrop-blur + Teleport
  根据 useModalStore.currentModal 动态渲染对应 modal
  -->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'
import SessionDoneModal from './SessionDoneModal.vue'

const store = useModalStore()
const open = computed(() => store.currentModal !== null)

const map: Record<string, any> = {
  'session-done': SessionDoneModal
}
const current = computed(() => store.currentModal ? map[store.currentModal] : null)
</script>

<template>
  <Teleport to="body">
    <div v-if="open" class="modal-root open">
      <div class="scrim" @click="store.close()"></div>
      <component v-if="current" :is="current" v-bind="store.props" />
    </div>
  </Teleport>
</template>

<style>
.modal-root {
  position: absolute; inset: 0;
  z-index: 60;
  display: none;
}
.modal-root.open {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
}
.scrim {
  position: absolute; inset: 0;
  background: rgba(0,0,0,.5);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}
.modal-root > :not(.scrim) {
  position: relative;
  z-index: 1;
}
</style>
