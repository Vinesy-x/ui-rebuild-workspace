<!--
  InvestBank · fps_0058 錢莊 + fps_0061 票號 + 🔒 (Phase B T-B5)
  3 sub-tab · 默认 錢莊
    錢莊: IAP banner (上戶銀牌) + 回返銀 chip + 3 寄銀卡 (timer / fixed / ad)
    票號: 庫本 portfolio + 自動經紀 IAP + 免費贈本 + 商號 list (9)
    🔒   : 未啟 第三道業 (★廿 解锁)
  ⓘ → store.open('bank-info', { msg: 'cashback'|'freebie'|'premium'|'broker' })
-->
<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import { useModalStore } from '../stores/useModalStore'
import mainMenu  from '../data/mainMenu.json'
import invData   from '../data/investments.json'

const router = useRouter()
const store  = useModalStore()

const active = ref<'bank' | 'stock' | 'lock'>('bank')

const hud = computed(() => ({
  ...mainMenu.hud,
  coin:       invData.screen.hudOverrides.coin       ?? mainMenu.hud.coin,
  mood:       invData.screen.hudOverrides.mood       ?? mainMenu.hud.mood,
  moodDelta:  invData.screen.hudOverrides.moodDelta  ?? mainMenu.hud.moodDelta,
  health:     invData.screen.hudOverrides.health     ?? mainMenu.hud.health,
  healthDelta:invData.screen.hudOverrides.healthDelta?? mainMenu.hud.healthDelta,
  coinDelta:  invData.screen.hudOverrides.coinDelta  ?? mainMenu.hud.coinDelta,
  date:       invData.screen.date
}))

function info(msg: 'cashback' | 'freebie' | 'premium' | 'broker', e?: Event) {
  e?.stopPropagation()
  store.open('bank-info', { msg })
}
function setTab(key: 'bank' | 'stock' | 'lock') {
  // lock 段不让切,但仍允许用户点 → 进 lock pane 看说明
  active.value = key
}
</script>

<template>
  <div class="screen" data-screen-label="投资 · fps_0058">
    <HudBar v-bind="hud" :charName="mainMenu.character.name" />

    <div class="screen-bar">
      <div></div>
      <div class="sb-title" v-html="invData.screen.title"></div>
      <button class="sb-close" @click="router.push('/main')">✕</button>
    </div>

    <div class="iv-page">
      <!-- ============= sub-tabs ============= -->
      <div class="sub-tabs">
        <div
          v-for="t in invData.subtabs"
          :key="t.key"
          class="sub-tab"
          :class="{ 'is-active': active === t.key, 'is-lock': t.locked }"
          @click="setTab(t.key as any)"
          v-html="t.label"
        ></div>
      </div>

      <!-- ============= 錢莊 sub-tab ============= -->
      <div v-if="active === 'bank'" class="iv-pane">
        <!-- IAP banner (上戶銀牌) -->
        <div class="iv-iap">
          <div class="iv-iap-ribbon">{{ invData.bank.iap.ribbon }}</div>
          <div class="iv-iap-head">
            {{ invData.bank.iap.name }}
            <span class="info" @click="info('premium', $event)">i</span>
          </div>
          <div class="iv-iap-body">
            <div class="iv-iap-illu" style="white-space:pre-line">{{ invData.bank.iap.illu }}</div>
            <ul class="iv-iap-buffs">
              <li v-for="b in invData.bank.iap.buffs" :key="b">{{ b }}</li>
            </ul>
          </div>
          <button class="iv-iap-cta">
            <span class="ic-seal ic-jade">{{ invData.bank.iap.currency }}</span>
            {{ invData.bank.iap.cost }}
          </button>
        </div>

        <!-- 回返銀 (cashback) -->
        <div class="iv-cashback">
          <div class="iv-cashback-head">
            {{ invData.bank.cashback.head }}
            <span class="rate-pill">{{ invData.bank.cashback.ratePct }}%</span>
            <span class="info" @click="info('cashback', $event)">i</span>
          </div>
          <div class="iv-cashback-line">
            <div class="iv-cashback-bar">
              <div class="bar-fg" :style="{ width: (invData.bank.cashback.progressCur / invData.bank.cashback.progressTotal * 100) + '%' }"></div>
              <span class="bar-label">{{ invData.bank.cashback.progressLabel }}</span>
            </div>
            <span class="iv-cashback-pop">
              <span class="ic-seal ic-brick">磚</span>
              {{ invData.bank.cashback.pop }}
            </span>
          </div>
          <div class="iv-cashback-tag">{{ invData.bank.cashback.tagline }}</div>
        </div>

        <!-- 3 寄銀 grid -->
        <div class="iv-deposits">
          <template v-for="d in invData.bank.deposits" :key="d.key">
            <!-- timer-lock -->
            <div v-if="d.kind === 'timer-lock'" class="iv-dep iv-dep-lock">
              <div class="iv-dep-icon">{{ d.icon }}</div>
              <div class="iv-dep-label">{{ d.label }}</div>
              <div class="iv-dep-timer">{{ d.timer }}</div>
            </div>
            <!-- fixed -->
            <div v-else-if="d.kind === 'fixed'" class="iv-dep iv-dep-fixed">
              <div class="iv-dep-tag">{{ d.tag }}</div>
              <div class="iv-dep-stack">
                <span class="ic-seal ic-coin">{{ d.iconChar }}</span>
                <span class="iv-dep-val">{{ d.value }}</span>
              </div>
              <div class="iv-dep-timer">⏰ {{ d.timer }}</div>
            </div>
            <!-- ad (+100%) -->
            <div v-else-if="d.kind === 'ad'" class="iv-dep iv-dep-ad">
              <div class="iv-dep-tag">{{ d.tag }}</div>
              <div class="iv-dep-stack">
                <span class="ic-seal" style="background:var(--wood-1)">{{ d.iconChar }}</span>
                <span class="iv-dep-bonus">{{ d.bonus }}</span>
              </div>
              <button class="iv-dep-cta">{{ d.cta }} <span class="ad-tri">▶</span></button>
            </div>
          </template>
        </div>
      </div>

      <!-- ============= 票號 sub-tab ============= -->
      <div v-if="active === 'stock'" class="iv-pane">
        <!-- 庫本 portfolio -->
        <div class="iv-port">
          <div class="iv-port-head">{{ invData.stock.portfolio.head }}</div>
          <div class="iv-port-row">
            <span class="iv-port-lab">{{ invData.stock.portfolio.hourlyGainLabel }}</span>
            <span class="iv-port-val c-jade">{{ invData.stock.portfolio.hourlyGain }}<span class="ic-seal ic-brick mini">磚</span></span>
          </div>
          <div class="iv-port-row">
            <span class="iv-port-lab">{{ invData.stock.portfolio.valueLabel }}</span>
            <span class="iv-port-val">
              {{ invData.stock.portfolio.value }}<span class="ic-seal ic-brick mini">磚</span>
              <span class="iv-port-pct" :class="'is-' + invData.stock.portfolio.valuePctDir">{{ invData.stock.portfolio.valuePct }}</span>
            </span>
          </div>
          <div class="iv-port-row dividend">
            <span class="iv-port-lab">{{ invData.stock.portfolio.dividendLabel }}</span>
            <span class="iv-port-pie" :style="{ '--pct': invData.stock.portfolio.dividendPct + '%' } as any"></span>
          </div>
          <button class="iv-port-cta" @click="store.open('stock-list')">{{ invData.stock.portfolio.cta }}</button>
        </div>

        <!-- 自動經紀 IAP -->
        <div class="iv-iap iv-iap-broker">
          <div class="iv-iap-head">
            {{ invData.stock.iap.name }}
            <span class="info" @click="info('broker', $event)">i</span>
          </div>
          <div class="iv-iap-body">
            <div class="iv-iap-illu" style="white-space:pre-line">{{ invData.stock.iap.illu }}</div>
            <ul class="iv-iap-buffs">
              <li v-for="b in invData.stock.iap.buffs" :key="b">{{ b }}</li>
            </ul>
          </div>
          <button class="iv-iap-cta">
            <span class="ic-seal ic-jade">{{ invData.stock.iap.currency }}</span>
            {{ invData.stock.iap.cost }}
          </button>
        </div>

        <!-- 免費贈本 -->
        <div class="iv-freebie">
          <div class="iv-freebie-l">
            <div class="iv-freebie-head">
              {{ invData.stock.freebie.head }}
              <span class="info" @click="info('freebie', $event)">i</span>
            </div>
            <div class="iv-freebie-text">{{ invData.stock.freebie.text }}</div>
          </div>
          <button class="iv-freebie-cta">{{ invData.stock.freebie.cta }} <span v-if="invData.stock.freebie.isAd" class="ad-tri">▶</span></button>
        </div>

        <!-- 商號 list 已抽到 StockListModal (共享组件) · 走 store.open('stock-list')
             见 final/src/components/StockListModal.vue + ModalShell.vue map -->
      </div>

      <!-- ============= 🔒 sub-tab ============= -->
      <div v-if="active === 'lock'" class="iv-pane iv-lock">
        <div class="iv-lock-icon">🔒</div>
        <div class="iv-lock-msg" style="white-space:pre-line">{{ invData.lockPane.msg }}</div>
        <div class="iv-lock-cond">{{ invData.lockPane.cond }}</div>
      </div>

      <div class="bottom-fade"></div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
/* .screen / .screen-bar / .sb-title / .sb-close / .sub-tabs / .ic-seal 走 components.css */

.iv-page {
  overflow-y: auto;
  padding: 12px 12px 24px;
  background: var(--paper-1);
}

.iv-pane { display: flex; flex-direction: column; gap: 14px; }

/* ============ IAP banner (共用 錢莊 + 票號) ============ */
.iv-iap {
  background: linear-gradient(180deg, #E6B677 0%, #C49255 100%);
  border: 1.5px solid var(--wood-2);
  border-radius: 10px;
  padding-bottom: 12px;
  position: relative;
  overflow: hidden;
}
.iv-iap-broker {
  background: linear-gradient(180deg, #C9B57E 0%, #A89055 100%);
}
.iv-iap-ribbon {
  position: absolute; top: 0; right: 0;
  background: var(--cinnabar-1);
  color: var(--paper-1);
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  letter-spacing: .18em;
  padding: 3px 12px;
  border-bottom-left-radius: 8px;
  z-index: 2;
}
.iv-iap-head {
  background: var(--cinnabar-1);
  color: var(--paper-1);
  font-family: var(--font-display);
  font-size: var(--fs-label);
  letter-spacing: .2em;
  padding: 6px 12px;
  text-align: center;
  position: relative;
}
.iv-iap-head .info {
  position: absolute; right: 8px; top: 50%;
  transform: translateY(-50%);
  width: 20px; height: 20px;
  background: rgba(255,255,255,.18);
  color: var(--paper-1);
  border: 1px solid var(--paper-1);
  border-radius: 50%;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: 13px;
  cursor: pointer;
}
.iv-iap-body {
  display: grid;
  grid-template-columns: 96px 1fr;
  gap: 12px;
  padding: 12px 12px 0;
  align-items: center;
}
.iv-iap-illu {
  width: 96px; height: 84px;
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  background-image: repeating-linear-gradient(45deg, transparent 0 8px, rgba(139,111,71,.18) 8px 10px);
  display: grid; place-items: center;
  color: var(--ink-3);
  font-family: ui-monospace, monospace;
  font-size: 11px;
  text-align: center;
  padding: 4px;
  line-height: 1.3;
}
.iv-iap-buffs { display: flex; flex-direction: column; gap: 4px; padding: 0; margin: 0; }
.iv-iap-buffs li {
  list-style: none;
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  color: var(--ink-1);
  display: inline-flex; align-items: center; gap: 6px;
  line-height: 1.3;
}
.iv-iap-buffs li::before {
  content: "✓";
  width: 16px; height: 16px;
  background: var(--jade); color: var(--paper-1);
  border-radius: 50%;
  display: inline-grid; place-items: center;
  font-size: 11px;
  flex: none;
}
.iv-iap-cta {
  display: flex; align-items: center; justify-content: center; gap: 6px;
  margin: 12px 14px 0;
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: var(--r-pill);
  padding: 8px;
  font-family: var(--font-display);
  font-size: var(--fs-label);
  letter-spacing: .12em;
  cursor: pointer;
  box-shadow: 0 3px 0 var(--ink-1);
  width: calc(100% - 28px);
}
.iv-iap-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }
.iv-iap-cta .ic-seal { width: 22px; height: 22px; font-size: 13px; }

/* ============ 回返銀 (cashback) ============ */
.iv-cashback {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 10px;
  padding: 10px 12px;
  box-shadow: var(--sh-card);
}
.iv-cashback-head {
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  color: var(--ink-1);
  letter-spacing: .15em;
  display: flex; align-items: center; gap: 10px;
  position: relative;
}
.rate-pill {
  background: var(--jade); color: var(--paper-1);
  font-family: var(--font-num);
  font-size: var(--fs-meta);
  padding: 1px 8px;
  border-radius: var(--r-pill);
  letter-spacing: 0;
}
.iv-cashback-head .info {
  position: absolute; right: 0;
  width: 20px; height: 20px;
  background: var(--paper-1);
  border: 1.5px solid var(--azure);
  color: var(--azure);
  border-radius: 50%;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: 13px;
  cursor: pointer;
}
.iv-cashback-line {
  margin: 10px 0 6px;
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 10px;
  align-items: center;
}
.iv-cashback-bar {
  position: relative;
  height: 16px;
  background: var(--paper-3);
  border: 1px solid var(--paper-edge);
  border-radius: var(--r-pill);
  overflow: hidden;
}
.iv-cashback-bar .bar-fg {
  position: absolute; inset: 0 auto 0 0;
  background: linear-gradient(180deg, var(--jade), #4a6d56);
  border-radius: var(--r-pill);
}
.iv-cashback-bar .bar-label {
  position: absolute; inset: 0;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  color: var(--ink-1);
  letter-spacing: .04em;
}
.iv-cashback-pop {
  display: inline-flex; align-items: center; gap: 4px;
  background: var(--cur-brick); color: var(--paper-1);
  font-family: var(--font-num); font-weight: 700;
  font-size: var(--fs-label);
  padding: 4px 10px;
  border-radius: var(--r-pill);
  border: 1px solid var(--ink-1);
}
.iv-cashback-pop .ic-seal { width: 16px; height: 16px; font-size: 11px; background: rgba(255,255,255,.22); }
.iv-cashback-tag {
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  color: var(--ink-3);
  letter-spacing: .08em;
  text-align: center;
}

/* ============ 3 寄銀 grid ============ */
.iv-deposits {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 8px;
}
.iv-dep {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 10px;
  padding: 12px 8px;
  display: flex; flex-direction: column; align-items: center; gap: 8px;
  text-align: center;
  min-height: 138px;
  box-shadow: var(--sh-card);
}
.iv-dep-tag {
  background: var(--ink-1); color: var(--paper-1);
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  padding: 1px 8px;
  border-radius: var(--r-pill);
  letter-spacing: .04em;
}
.iv-dep-stack { display: flex; flex-direction: column; align-items: center; gap: 4px; }
.iv-dep-stack .ic-seal { width: 28px; height: 28px; font-size: var(--fs-label); }
.iv-dep-val {
  font-family: var(--font-display);
  font-size: var(--fs-h1);
  color: var(--ink-1);
  font-weight: 700;
  letter-spacing: -.02em;
}
.iv-dep-bonus {
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  color: var(--cinnabar-1);
  font-weight: 700;
}
.iv-dep-timer {
  font-family: var(--font-num);
  font-size: var(--fs-meta);
  color: var(--ink-3);
  line-height: 1.3;
  white-space: nowrap;
}
.iv-dep-icon { font-size: 28px; color: var(--ink-3); }
.iv-dep-label {
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  color: var(--ink-2);
  line-height: 1.3;
  flex: 1;
}

.iv-dep-cta {
  background: var(--cinnabar-1);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 6px;
  padding: 5px 12px;
  font-family: var(--font-display);
  font-size: var(--fs-label);
  letter-spacing: .1em;
  cursor: pointer;
  box-shadow: 0 2px 0 var(--ink-1);
  display: inline-flex; align-items: center; gap: 6px;
}
.iv-dep-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }
.ad-tri { font-size: var(--fs-mono); }

/* ============ 票號 · portfolio ============ */
.iv-port {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 10px;
  padding: 12px;
  box-shadow: var(--sh-card);
}
.iv-port-head {
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  color: var(--ink-1);
  letter-spacing: .15em;
  text-align: center;
  margin-bottom: 10px;
}
.iv-port-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 4px 0;
  font-family: var(--font-display);
  font-size: var(--fs-label);
}
.iv-port-lab { color: var(--ink-3); letter-spacing: .08em; }
.iv-port-val {
  display: inline-flex; align-items: center; gap: 4px;
  font-family: var(--font-num);
  color: var(--ink-1);
}
.iv-port-val.c-jade { color: var(--jade); font-weight: 700; }
.iv-port-val .ic-seal.mini { width: 16px; height: 16px; font-size: 11px; }
.iv-port-pct {
  font-family: var(--font-num); font-size: var(--fs-meta);
  margin-left: 4px;
}
.iv-port-pct.is-down { color: var(--fail-red); }
.iv-port-pct.is-up   { color: var(--jade); }
.iv-port-row.dividend { margin-top: 4px; }
.iv-port-pie {
  width: 36px; height: 36px;
  border-radius: 50%;
  background: conic-gradient(var(--jade) 0 var(--pct), var(--paper-3) var(--pct) 100%);
  border: 1.5px solid var(--ink-1);
  position: relative;
}
.iv-port-pie::after {
  content: ""; position: absolute; inset: 7px;
  background: var(--paper-2);
  border-radius: 50%;
}
.iv-port-cta {
  display: block; width: 100%; margin-top: 10px;
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 8px;
  padding: 10px;
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  letter-spacing: .2em;
  cursor: pointer;
  box-shadow: 0 3px 0 var(--ink-1);
}
.iv-port-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }

/* ============ 票號 · 免費贈本 ============ */
.iv-freebie {
  background: var(--paper-2);
  border: 1.5px solid var(--jade);
  border-radius: 10px;
  padding: 10px 12px;
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 12px;
  align-items: center;
  box-shadow: var(--sh-card);
}
.iv-freebie-head {
  font-family: var(--font-display);
  font-size: var(--fs-label);
  color: var(--ink-1);
  letter-spacing: .15em;
  display: inline-flex; align-items: center; gap: 8px;
}
.iv-freebie-head .info {
  width: 18px; height: 18px;
  background: var(--paper-1);
  border: 1px solid var(--azure);
  color: var(--azure);
  border-radius: 50%;
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: 12px;
  cursor: pointer;
}
.iv-freebie-text {
  font-family: var(--font-display);
  font-size: var(--fs-meta);
  color: var(--ink-3);
  margin-top: 4px;
}
.iv-freebie-cta {
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 8px;
  padding: 10px 18px;
  font-family: var(--font-display);
  font-size: var(--fs-h2);
  letter-spacing: .15em;
  cursor: pointer;
  box-shadow: 0 3px 0 var(--ink-1);
  display: inline-flex; align-items: center; gap: 6px;
}
.iv-freebie-cta:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }

/* 商號 list 样式已迁移至 StockListModal.vue (fps_0062 共享 modal) */

/* ============ 🔒 sub-tab pane ============ */
.sub-tab.is-lock { color: var(--ink-4); }
.sub-tab.is-active.is-lock { color: var(--ink-2); }
.iv-lock {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 18px;
  padding: 60px 24px;
  color: var(--ink-3);
  text-align: center;
}
.iv-lock-icon { font-size: 64px; opacity: .6; }
.iv-lock-msg {
  font-family: var(--font-display);
  font-size: var(--fs-h1);
  color: var(--ink-2);
  letter-spacing: .25em;
  line-height: 1.6;
}
.iv-lock-cond {
  font-family: var(--font-num);
  font-size: var(--fs-label);
  color: var(--cinnabar-1);
  letter-spacing: .1em;
}

.bottom-fade { height: 24px; }
</style>
