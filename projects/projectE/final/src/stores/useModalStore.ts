/**
 * 全局 modal store (Pinia)
 * 一个 <ModalShell> 挂在根 layout 根据 currentModal 渲染对应 modal
 * router.afterEach 切屏自动 reset
 *
 * ───────────────────────────────────────────────────────────────
 * 命名约定：每条 ModalName 都标注 (a) 实现组件 (b) 出现帧
 * HTML 真值 30 项原始名 → Vue 工程层聚合为以下集合
 *   - 'character' 统吃 HTML 的 rename / income (头像 + 心 cell + 名条)
 *   - 'goals'     统吃 HTML 的 bonus / cur-pouch / work-detail / multi-task / date
 *   - 'shop'      接 props {tab:'money'|'jade'}   (覆 HTML shop:money / shop:jade)
 * 不再单独建 'rename' / 'bonus' / 'date' / 'random-event' 入口
 * (3 项已并入 character/goals; random-event 全局事件目前未触发,等 T-B7+)
 * ───────────────────────────────────────────────────────────────
 */
import { defineStore } from 'pinia'

export type ModalName =
  | null
  // ─── Phase A 全局 · HudBar + MainMenu 触发 ───
  | 'settings'           // SettingsModal      · ⚙ 齿轮
  | 'character'          // CharacterModal     · 头像 / 心 cell / 名条 (alias: rename / income)
  | 'shop'               // ShopModal          · 銅 cell / 玉 cell  (props: tab=money|jade)
  | 'goals'              // GoalsModal         · 红包 / cal / task-card / 三堆叠 / pouch (alias: bonus / multi-task / work-detail / cur-pouch / date)
  | 'happiness'          // ProgressListDialog · 星 cell · fps_0126
  | 'health'             // ProgressListDialog · 壽 cell · fps_0123
  // ─── Tab 1 技能 ───
  | 'skill-accelerate'   // SkillAccelerateModal · fps_0007 · 每技能各自一个实例
  // ─── Tab 2 关系 ───
  | 'gift-picker'        // OptionPickerModal  · fps_0020 礼物
  | 'date-picker'        // OptionPickerModal  · fps_0022 约会
  | 'upgrade-overlay'    // UpgradeOverlay     · fps_0014 亲疏度升级
  // ─── Tab 3 工作 · 0036 list → 点工作卡触发 ───
  // ⚠️ v2 canonical 校正：fps_0037 实为 JobDetail modal "焊工"(与 0040 汽车修理工 / 0041 promo 同 widget 不同工种)
  // 旧推测的「主菜单 NPC tap → 焊工要求 modal」边作废
  | 'job-detail'         // JobDetailModal     · fps_0037 + 0040 同 widget
  | 'job-promo'          // JobPromoSplash     · fps_0041 換職事
  // ─── Tab 4 业务 ───
  | 'biz-hire'           // BizHireModal       · fps_0050 雇掌櫃
  | 'biz-upgrade'        // BizUpgradeModal    · fps_0053 興擴
  // ─── Tab 5 投资 ───
  | 'bank-info'          // InvestInfoModal    · fps_0059 银行 ⓘ "信息" (props: msg=cashback|freebie|premium|broker)
  | 'stock-list'         // StockListModal     · fps_0062 票號 認購 → 9 商號 list
  // ─── Tab 6 物品 ───
  | 'purchase-confirm'   // PurchaseConfirmModal · fps_0075 / 0082 · 食 / 居 / 大件
  | 'sell-vehicle'       // AsyncWaitModal     · fps_0067-0069 · 卖车 3 步链
  | 'cinematic'          // CinematicScene     · fps_0077 · 大件购买过场

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
