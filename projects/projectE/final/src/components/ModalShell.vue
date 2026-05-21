<!--
  ModalShell · 全局 modal 根容器
  挂在根 layout，根据 useModalStore.currentModal 渲染对应 modal
  scrim rgba(0,0,0,.65) + backdrop-filter blur(8px)

  Modal 尺寸 3 档锁定：
    .modal--sm  420px  · 短列表 / 信息 modal
    .modal--md  560px  · hero+6 行 / req 列表 (default)
    .modal--lg  740px  · 长列表 / 商店 / 设置 / 人物卷
  锚点：top 64px (HUD 下) · left/right 16px · 居中偏上
  默认 overflow:hidden，仅列表型 modal 加 .modal-body.scroll
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useModalStore } from '../stores/useModalStore'
import ProgressListDialog   from './ProgressListDialog.vue'
import OptionPickerModal    from './OptionPickerModal.vue'
import PurchaseConfirmModal from './PurchaseConfirmModal.vue'
import AsyncWaitModal       from './AsyncWaitModal.vue'
import CinematicScene       from './CinematicScene.vue'
import UpgradeOverlay       from './UpgradeOverlay.vue'
import JobPromoSplash       from './JobPromoSplash.vue'
import JobDetailModal       from './JobDetailModal.vue'
import SkillAccelerateModal from './SkillAccelerateModal.vue'
import BizHireModal         from './BizHireModal.vue'
import BizUpgradeModal      from './BizUpgradeModal.vue'
import SettingsModal        from './SettingsModal.vue'
import CharacterModal       from './CharacterModal.vue'
import GoalsModal           from './GoalsModal.vue'
import ShopModal            from './ShopModal.vue'
import InvestInfoModal      from './InvestInfoModal.vue'
import StockListModal       from './StockListModal.vue'

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
  'job-promo':        JobPromoSplash,
  'job-detail':       JobDetailModal,      // 校正后: 0037 + 0040 同 widget
  'skill-accelerate': SkillAccelerateModal,// T-B1 fps_0007 · 每技能各自一个实例
  'biz-hire':         BizHireModal,        // T-B4 fps_0050 · 雇掌櫃
  'biz-upgrade':      BizUpgradeModal,     // T-B4 fps_0053 · 興擴
  'bank-info':        InvestInfoModal,     // T-B5 fps_0059 · 银行 ⓘ 信息
  'stock-list':       StockListModal,      // T-B5 fps_0062 · 票號 認購 → 9 商號 list
  // Phase A globals · HudBar + MainMenu 触发
  'settings':         SettingsModal,       // ⚙ 齿轮
  'character':        CharacterModal,      // 王掌柜头像 · 心 / 玉 cell · 名条 (alias: rename / income)
  'goals':            GoalsModal,          // cal · 红包 / task-card / 堆叠 / pouch (alias: bonus / multi-task / work-detail / cur-pouch / date)
  'shop':             ShopModal            // 銅 / 玉 cell (props: tab=money/jade)
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
/* 非 scoped: modal 系列样式跨组件共享 */
.modal-root {
    position: absolute; inset: 0;
    z-index: 60;
    display: none;
  }

.modal-root.open {
    /* 三档尺寸统一垂直居中 + 上偏 5% (~ 视觉中心 47%·canonical「居中偏上」)
       padding 60/16/120 = 上 60 留 HUD,下 120 留底栏 + 上偏配重 */
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 60px 16px 120px;
  }

.scrim {
    position: absolute; inset: 0;
    background: var(--scrim);
    backdrop-filter: var(--scrim-blur);
    -webkit-backdrop-filter: var(--scrim-blur);
  }

.modal {
    position: relative;
    width: 100%;
    max-width: 416px;
    background: var(--paper-1);
    border: 1.5px solid var(--paper-edge);
    border-radius: 10px;
    box-shadow: var(--sh-modal);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    isolation: isolate;
    height: 560px;                   /* default = md */
  }

.modal--sm { height: 420px; }

.modal--md { height: 560px; }

.modal--lg { height: 740px; }

.modal-bar {
    background: var(--celadon-3);
    color: var(--paper-1);
    padding: 10px 14px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-family: var(--font-display);
    font-size: var(--fs-h2);
    border-bottom: 1px solid var(--wood-2);
    position: relative;
  }

.modal-bar::after {  /* 飞檐 */
    content: "";
    position: absolute;
    bottom: -6px; left: 50%; transform: translateX(-50%);
    width: 70%; height: 6px;
    background: var(--wood-1);
    clip-path: polygon(0 0, 10% 100%, 90% 100%, 100% 0);
  }

.modal-bar .close {
    width: 24px; height: 24px;
    border: 1px solid var(--paper-1);
    border-radius: 50%;
    display: grid; place-items: center;
    cursor: pointer;
    font-size: var(--fs-body);
    background: transparent;
    color: var(--paper-1);
  }

.modal-body {
    flex: 1 1 auto;
    overflow: hidden;            /* 默认不滚动 · 内容超出裁切 */
    padding: 16px;
  }

.modal-body.scroll {           /* 仅列表类 modal 加 .scroll */
    overflow-y: auto;
  }

.modal-body h3 { margin: 12px 0 8px; font-family: var(--font-display); font-size: var(--fs-h2); color: var(--ink-1); letter-spacing: .02em; }

.modal-body p  { margin: 4px 0; font-size: var(--fs-body); color: var(--ink-2); line-height: 1.6; }
</style>
