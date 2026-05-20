<!--
  ModalShell · 全屋 modal 根容器
  挂在根 layout，根据 useModalStore.currentModal 渲染对应 modal
  scrim rgba(0,0,0,.65) + backdrop-filter blur(8px)
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'

// 7 共享组件 + 屏特有 modal
import ProgressListDialog from './ProgressListDialog.vue'
import OptionPickerModal  from './OptionPickerModal.vue'
import PurchaseConfirmModal from './PurchaseConfirmModal.vue'
import AsyncWaitModal     from './AsyncWaitModal.vue'
import CinematicScene     from './CinematicScene.vue'
import UpgradeOverlay     from './UpgradeOverlay.vue'
import JobPromoSplash     from './JobPromoSplash.vue'

const store = useModalStore()
const open = computed(() => store.currentModal !== null)

const map: Record<string, any> = {
  'happiness':        ProgressListDialog,
  'health':           ProgressListDialog,
  'gift-picker':      OptionPickerModal,
  'date-picker':      OptionPickerModal,
  'purchase-confirm': PurchaseConfirmModal,
  'sell-vehicle':     AsyncWaitModal,
  'cinematic':        CinematicScene,
  'upgrade-overlay':  UpgradeOverlay,
  'job-promo':        JobPromoSplash
}
const current = computed(() => store.currentModal ? map[store.currentModal] : null)
</script>

<template>
  <Teleport to="body">
    <div v-if="open" class="modal-root">
      <div class="scrim" @click="store.close()"></div>
      <component v-if="current" :is="current" v-bind="store.props" />
    </div>
  </Teleport>
</template>

<style scoped>
.modal-root { position: fixed; inset: 0; z-index: 60; }
.scrim {
  position: absolute; inset: 0;
  background: var(--scrim);
  backdrop-filter: var(--scrim-blur);
}
</style>
