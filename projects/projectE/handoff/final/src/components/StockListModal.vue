<!--
  StockListModal · fps_0062 商號 list (Phase B T-B5)
  - 触发: InvestBank.vue 票號 sub-tab → 「認購」CTA → store.open('stock-list')
  - canonical: design-brief/flows/screen-details.md L500-510 (9 仿真商號)
  - 5 持有态(级/进度条/月收益) + 4 未持有态(灰)
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
import invData from '../data/investments.json'

const store = useModalStore()
</script>

<template>
  <div class="modal modal--lg">
    <div class="modal-bar">
      <span>商&nbsp;&nbsp;號</span>
      <button class="close" @click="store.close()">✕</button>
    </div>
    <div class="modal-body scroll stock-list-body">
      <div class="iv-stocks">
        <div
          v-for="s in invData.stocks"
          :key="s.key"
          class="iv-stock-card"
          :class="{ 'is-empty': s.owned === 0 }"
        >
          <div class="iv-stock-glyph" :class="'tone-' + s.color">{{ s.glyph }}</div>
          <div class="iv-stock-mid">
            <div class="iv-stock-name">{{ s.name }}</div>
            <div class="iv-stock-brand">{{ s.brand }}</div>
            <div v-if="s.owned > 0" class="iv-stock-meta">
              <span class="iv-stock-lv">級 {{ s.lv }}</span>
              <span class="iv-stock-bar"><i :style="{ width: s.ownedPct + '%' }"></i></span>
              <span class="iv-stock-own">{{ s.owned }}</span>
            </div>
            <div v-else class="iv-stock-meta is-mute">未　持　有</div>
          </div>
          <div class="iv-stock-income" :class="{ 'c-jade': s.owned > 0, 'c-muted': s.owned === 0 }">
            {{ s.income }}<span class="ic-seal ic-brick mini">磚</span>／月
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.stock-list-body { padding: 12px; }

.iv-stocks { display: flex; flex-direction: column; gap: 6px; }
.iv-stock-card {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  padding: 8px 10px;
  display: grid;
  grid-template-columns: 40px 1fr auto;
  gap: 10px;
  align-items: center;
  box-shadow: var(--sh-card);
  cursor: pointer;
  transition: transform var(--dur-fast) var(--ease-out);
}
.iv-stock-card:active { transform: scale(.99); }
.iv-stock-card.is-empty { opacity: .85; }

.iv-stock-glyph {
  width: 40px; height: 40px;
  border-radius: 4px;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  color: var(--paper-1);
}
.tone-jade       { background: var(--jade); }
.tone-cinnabar   { background: var(--cinnabar-1); }
.tone-cinnabar-2 { background: var(--cinnabar-2); }
.tone-gold       { background: var(--gold-2); color: var(--ink-1); }
.tone-azure      { background: var(--azure); }
.tone-amber      { background: var(--amber); color: var(--ink-1); }
.tone-celadon    { background: var(--celadon-3); }
.tone-ink        { background: var(--ink-1); }
.tone-wood       { background: var(--wood-1); }

.iv-stock-mid { min-width: 0; }
.iv-stock-name  { font-family: var(--font-display); font-size: var(--fs-label); color: var(--ink-1); }
.iv-stock-brand { font-family: ui-monospace, monospace; font-size: var(--fs-mono); color: var(--ink-3); letter-spacing: .08em; }
.iv-stock-meta {
  display: flex; align-items: center; gap: 6px; margin-top: 2px;
  font-family: var(--font-num); font-size: var(--fs-meta); color: var(--ink-2);
}
.iv-stock-meta.is-mute { color: var(--ink-4); letter-spacing: .15em; }
.iv-stock-lv  { white-space: nowrap; }
.iv-stock-bar { flex: 1; height: 5px; background: var(--paper-3); border: 1px solid var(--paper-edge); border-radius: 3px; overflow: hidden; max-width: 80px; }
.iv-stock-bar i { display: block; height: 100%; background: var(--jade); }
.iv-stock-own { color: var(--ink-1); font-weight: 700; }
.iv-stock-income {
  font-family: var(--font-num);
  font-size: var(--fs-meta);
  white-space: nowrap;
  display: inline-flex; align-items: center; gap: 3px;
}
.iv-stock-income.c-jade  { color: var(--jade); }
.iv-stock-income.c-muted { color: var(--ink-4); }
.iv-stock-income .ic-seal.mini { width: 14px; height: 14px; font-size: 10px; }
</style>
