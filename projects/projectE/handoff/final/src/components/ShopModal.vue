<!--
  ShopModal · 银号 modal (Phase A globals)
  HTML 真值 L4343-4361 (shop:money) · jade tab 沿用同一模板
  触发自 HudBar 銅 cell / 玉 cell · store.open('shop', {tab:'money'|'jade'})
  Phase A demo · Phase B 补完整 4 分区(金钱 / 门票 / 水 / 芯片)
-->
<script setup lang="ts">
import { ref } from 'vue'
import { useModalStore } from '../stores/useModalStore'
import type { ShopTab } from '../types/modalPayloads'
const store = useModalStore()
interface Props { tab?: ShopTab }
const props = withDefaults(defineProps<Props>(), { tab: 'money' })

const tab = ref<ShopTab>(props.tab)

const moneyOptions = [
  { n: '四千五',    p: '看广告' },
  { n: '三万五',    p: '¥2.99'  },
  { n: '九万',      p: '¥6.99'  },
  { n: '廿二万',    p: '¥13.99' },
  { n: '一百廿万',  p: '¥59.99' },
  { n: '三百万',    p: '¥49.99' }
]
const jadeOptions = [
  { n: '玉 一',     p: '看广告' },
  { n: '玉 廿',     p: '¥2.99'  },
  { n: '玉 五十',   p: '¥6.99'  },
  { n: '玉 一百八', p: '¥13.99' },
  { n: '玉 千',     p: '¥59.99' },
  { n: '玉 三千',   p: '¥49.99' }
]
</script>

<template>
  <div class="modal modal--md">
    <div class="modal-bar">
      <span>银号 · {{ tab === 'money' ? '銅錢' : '紫玉' }}</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body scroll">
      <div class="phase-notice">
        Phase A demo: 商店 modal 占位<br/>
        <span class="phase-notice-sub">完整 4 分区(金钱 / 门票 / 水 / 芯片)由 Phase B 补</span>
      </div>

      <div class="sub-tabs">
        <div class="sub-tab" :class="{ 'is-active': tab === 'money' }" @click="tab = 'money'">銅&nbsp;錢</div>
        <div class="sub-tab" :class="{ 'is-active': tab === 'jade' }"  @click="tab = 'jade'">紫&nbsp;玉</div>
      </div>

      <div class="shop-grid">
        <div v-for="o in (tab === 'money' ? moneyOptions : jadeOptions)" :key="o.n + o.p" class="shop-cell">
          <div class="shop-amt" :class="tab === 'money' ? 'amt-coin' : 'amt-jade'">{{ o.n }}</div>
          <div class="shop-price">{{ o.p }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.phase-notice {
  padding: 12px;
  background: var(--paper-2);
  border: 1px solid var(--paper-edge);
  border-radius: 6px;
  margin-bottom: 12px;
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  color: var(--ink-2);
}
.phase-notice-sub {
  font-family: var(--font-num);
  font-size: var(--fs-meta);
  color: var(--ink-3);
}

/* .sub-tabs / .sub-tab 走全局 components.css */

.shop-grid {
  display: grid; grid-template-columns: repeat(2, 1fr);
  gap: 8px;
}
.shop-cell {
  padding: 10px;
  background: var(--paper-1);
  border: 1px solid var(--gold-1);
  border-radius: 6px;
  text-align: center;
  font-family: var(--font-display);
}
.shop-amt { font-size: var(--fs-h2); }
.amt-coin { color: var(--cur-coin); }
.amt-jade { color: var(--cur-jade); }
.shop-price { font-size: var(--fs-meta); color: var(--ink-3); margin-top: 4px; }
</style>
