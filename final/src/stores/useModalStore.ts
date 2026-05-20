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
  // Tab 1
  | 'skill-accelerate'
  // Tab 2
  | 'gift-picker'        // OptionPickerModal
  | 'date-picker'        // OptionPickerModal
  | 'upgrade-overlay'    // UpgradeOverlay
  // Tab 3 工作 · 0036 工作 list → 点工作卡触发
  // ⚠️ v2 canonical 校正：fps_0037 实为 JobDetail modal "焊工"（与 0040 汽车修理工 / 0041 promo 同 widget 不同工种）
  // 旧推测的「主菜单 NPC tap → 焊工要求 modal」边作废
  | 'job-detail'         // JobDetailModal · 0037 + 0040
  | 'job-promo'          // JobPromoSplash · 0041
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
