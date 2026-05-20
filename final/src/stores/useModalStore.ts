/**
 * 全局 modal store (Pinia)
 * 一个 <ModalShell> 挂在根 layout 根据 currentModal 渲染对应 modal
 * router.afterEach 切屏自动 reset
 */
import { defineStore } from 'pinia'

export type ModalName =
  | null
  // 主菜单触发
  | 'settings'
  | 'character'
  | 'shop'
  | 'goals'
  | 'happiness'
  | 'health'
  | 'rename'
  | 'bonus'
  | 'date'
  | 'random-event'
  // NPC tap
  | 'npc-req'
  // Tab 1
  | 'skill-accelerate'
  // Tab 2
  | 'gift-picker'        // OptionPickerModal
  | 'date-picker'        // OptionPickerModal
  | 'upgrade-overlay'    // UpgradeOverlay
  // Tab 3
  | 'job-detail'
  | 'job-promo'          // JobPromoSplash
  // Tab 4
  | 'biz-hire'
  | 'biz-upgrade'
  // Tab 5
  | 'bank-info'
  // Tab 6
  | 'purchase-confirm'   // PurchaseConfirmModal
  | 'sell-vehicle'       // AsyncWaitModal
  | 'cinematic'          // CinematicScene

interface ModalState {
  currentModal: ModalName
  props: Record<string, any>
}

export const useModalStore = defineStore('modal', {
  state: (): ModalState => ({
    currentModal: null,
    props: {}
  }),
  actions: {
    open(name: Exclude<ModalName, null>, props: Record<string, any> = {}) {
      this.currentModal = name
      this.props = props
    },
    close() {
      this.currentModal = null
      this.props = {}
    }
  }
})
