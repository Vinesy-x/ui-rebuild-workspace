<!--
  BusinessList · fps_0046 商號 list (Phase B T-B4)
  6 业务卡(4 owned · 1 酒坊 unowned · 1 locked 未啟 倒计时)
  + 总收益 chip + 大掌櫃 IAP banner (12.99 USD)
  + 掌櫃环形进度 widget(has-mgr 3s 自动 / no-mgr 60s 红 + 手动'領取' + '+'雇)
  click → store.open('biz-upgrade', { biz }) · '+' → store.open('biz-hire', { biz })
-->
<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import HudBar       from '../components/HudBar.vue'
import BottomTabBar from '../components/BottomTabBar.vue'
import { useModalStore } from '../stores/useModalStore'
import mainMenu from '../data/mainMenu.json'
import bizData from '../data/businessList.json'

const router = useRouter()
const store  = useModalStore()

const hud = computed(() => ({
  ...mainMenu.hud,
  coin:       bizData.screen.hudOverrides.coin       ?? mainMenu.hud.coin,
  mood:       bizData.screen.hudOverrides.mood       ?? mainMenu.hud.mood,
  moodDelta:  bizData.screen.hudOverrides.moodDelta  ?? mainMenu.hud.moodDelta,
  health:     bizData.screen.hudOverrides.health     ?? mainMenu.hud.health,
  healthDelta:bizData.screen.hudOverrides.healthDelta?? mainMenu.hud.healthDelta,
  coinDelta:  bizData.screen.hudOverrides.coinDelta  ?? mainMenu.hud.coinDelta,
  date:       bizData.screen.date
}))

function openUpgrade (biz: any) {
  if (!biz.owned || biz.locked) return
  store.open('biz-upgrade', { bizKey: biz.key, ...biz })
}
function openHire (biz: any, e: Event) {
  e.stopPropagation()
  store.open('biz-hire', { bizKey: biz.key, ...biz })
}
function collect (e: Event) {
  e.stopPropagation()
  // 演示: 手动领取 → 关闭 / 飘字 / 数额累加 (Phase B 仅占位)
}
function purchase (biz: any, e: Event) {
  e.stopPropagation()
  // 演示: 购入态 → 走 purchase-confirm 通用 modal
  store.open('purchase-confirm', { name: biz.name, price: biz.purchaseCost, currency: biz.purchaseCur })
}
</script>

<template>
  <div class="biz" data-screen-label="业务 list · fps_0046">
    <HudBar v-bind="hud" :charName="mainMenu.character.name" />

    <div class="screen-bar">
      <div></div>
      <div class="sb-title" v-html="bizData.screen.title"></div>
      <button class="sb-close" @click="router.push('/main')">✕</button>
    </div>

    <div class="bz-page">
      <!-- 总收益 chip -->
      <div class="bz-total">
        <span class="num">+</span>
        <span class="ic-seal">{{ bizData.totalIncome.seal }}</span>
        <span class="num">{{ bizData.totalIncome.value }}</span>{{ bizData.totalIncome.unit }}
      </div>

      <!-- 大掌櫃 IAP banner -->
      <div class="bz-iap">
        <div class="bz-iap-head">{{ bizData.iap.name }}<span class="info">i</span></div>
        <div class="bz-iap-body">
          <div class="bz-iap-illu" style="white-space:pre-line">{{ bizData.iap.illu }}</div>
          <ul class="bz-iap-buffs">
            <li v-for="b in bizData.iap.buffs" :key="b">{{ b }}</li>
          </ul>
        </div>
        <button class="bz-iap-cta">{{ bizData.iap.price }}</button>
      </div>

      <div class="bz-section-head">{{ bizData.sectionHead }}</div>

      <!-- 业务卡 list -->
      <template v-for="biz in bizData.businesses" :key="biz.key">
        <!-- locked 占位 (未啟) -->
        <div v-if="biz.locked" class="bz-card bz-locked">
          <div class="bz-card-left">
            <div class="bz-card-illu">{{ biz.illu }}</div>
          </div>
          <div class="bz-card-mid">
            <div class="bz-card-name lock-name">{{ biz.name }}</div>
            <div class="bz-card-lv">{{ biz.lv }}</div>
          </div>
          <div class="mgr-widget">
            <div class="mgr-face is-empty lock-face">鎖</div>
          </div>
        </div>

        <!-- 未购入 (酒坊) -->
        <div v-else-if="!biz.owned" class="bz-card is-unowned" @click="purchase(biz, $event)">
          <div class="bz-card-illu">{{ biz.illu }}</div>
          <div class="bz-card-mid">
            <div class="bz-card-name">{{ biz.name }}</div>
            <div class="bz-card-lv">{{ biz.lv }}</div>
            <button class="bz-card-purchase" @click="purchase(biz, $event)">
              <span class="ic-seal seal-jade">{{ biz.purchaseCur }}</span>購&nbsp;入&nbsp;{{ biz.purchaseCost }}
            </button>
          </div>
        </div>

        <!-- owned · 4 商號标准卡 -->
        <div v-else class="bz-card" @click="openUpgrade(biz)">
          <div class="bz-card-left">
            <div class="bz-card-illu">
              {{ biz.illu }}<span v-if="biz.redBang" class="red-bang">{{ biz.redBang }}</span>
            </div>
            <button class="bz-card-upgrade" @click.stop="openUpgrade(biz)">興&nbsp;擴</button>
          </div>
          <div class="bz-card-mid">
            <div class="bz-card-name">{{ biz.name }}</div>
            <div class="bz-card-income"><span class="ic-seal">銅</span>{{ biz.income }}／月</div>
            <div class="bz-card-lv">級 {{ biz.lv }}</div>
            <div class="star-row">
              <span v-for="i in 5" :key="i" class="star" :class="{ 'is-on': i <= biz.stars }"></span>
            </div>
          </div>
          <div class="mgr-widget">
            <div class="mgr-ring" :class="biz.hasMgr ? 'is-has-mgr' : 'is-no-mgr'">
              <span v-if="biz.hasMgr" class="mgr-coin-pop"><span class="ic-seal">銅</span>{{ biz.mgrTick }}</span>
              <svg viewBox="0 0 36 36">
                <circle class="ring-bg" cx="18" cy="18" r="15.92"></circle>
                <circle class="ring-fg" cx="18" cy="18" r="15.92"></circle>
              </svg>
              <div v-if="biz.hasMgr" class="mgr-face">櫃</div>
              <div v-else class="mgr-face is-empty" @click="openHire(biz, $event)">+</div>
            </div>
            <button v-if="!biz.hasMgr" class="mgr-collect" @click="collect">
              <span class="ic-seal">銅</span>領&nbsp;取
            </button>
          </div>
        </div>
      </template>

      <div class="bottom-fade"></div>
    </div>

    <BottomTabBar />
  </div>
</template>

<style scoped>
.biz {
  position: absolute; inset: 0;
  display: grid;
  grid-template-rows: 80px 44px 1fr 90px;
  background: var(--paper-1);
}

.screen-bar {
  background: var(--celadon-3);
  color: var(--paper-1);
  display: grid; grid-template-columns: 44px 1fr 44px;
  align-items: center;
  position: relative;
  border-bottom: 1px solid var(--wood-2);
  box-shadow: 0 1px 0 var(--gold-1);
}
.screen-bar::after {
  content: ""; position: absolute; bottom: -6px; left: 50%; transform: translateX(-50%);
  width: 60%; height: 6px; background: var(--wood-1);
  clip-path: polygon(0 0, 10% 100%, 90% 100%, 100% 0);
}
.sb-title { font-family: var(--font-display); font-size: 22px; letter-spacing: .35em; text-align: center; padding-left: .35em; }
.sb-close {
  width: 28px; height: 28px;
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  background: transparent; color: var(--paper-1);
  font-size: 16px; cursor: pointer; justify-self: center;
}

.bz-page { overflow-y: auto; padding: 12px 12px 24px; background: var(--paper-1); }

.bz-total {
  display: flex; align-items: center; justify-content: center; gap: 8px;
  background: var(--celadon-3);
  color: var(--paper-1);
  border-radius: var(--r-pill);
  padding: 8px 16px;
  font-family: var(--font-display);
  font-size: 20px;
  margin: 4px auto 14px;
  width: fit-content;
  border: 1.5px solid var(--gold-1);
  box-shadow: inset 0 1px 0 rgba(255,255,255,.12);
}
.bz-total .ic-seal {
  background: var(--jade); color: var(--paper-1);
  width: 22px; height: 22px; font-size: 14px;
  border-radius: 3px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}
.bz-total .num { font-family: var(--font-num); letter-spacing: -.02em; }

/* IAP banner */
.bz-iap {
  background: linear-gradient(180deg, #E6B677 0%, #C49255 100%);
  border: 1.5px solid var(--wood-2);
  border-radius: 10px;
  padding: 0 0 12px;
  margin-bottom: 16px;
  position: relative;
  overflow: hidden;
}
.bz-iap-head {
  background: var(--cinnabar-1);
  color: var(--paper-1);
  font-family: var(--font-display);
  font-size: 17px;
  letter-spacing: .2em;
  padding: 6px 12px;
  text-align: center;
  position: relative;
}
.bz-iap-head .info {
  position: absolute; right: 8px; top: 50%; transform: translateY(-50%);
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
.bz-iap-body {
  display: grid;
  grid-template-columns: 90px 1fr;
  gap: 12px;
  padding: 12px 12px 0;
  align-items: center;
}
.bz-iap-illu {
  width: 90px; height: 90px;
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
}
.bz-iap-buffs { display: flex; flex-direction: column; gap: 4px; padding: 0; margin: 0; }
.bz-iap-buffs li {
  list-style: none;
  font-family: var(--font-display);
  font-size: 15px;
  color: var(--ink-1);
  display: inline-flex; align-items: center; gap: 6px;
  line-height: 1.3;
}
.bz-iap-buffs li::before {
  content: "✓";
  width: 18px; height: 18px;
  background: var(--jade); color: var(--paper-1);
  border-radius: 50%;
  display: inline-grid; place-items: center;
  font-size: 11px;
  flex: none;
}
.bz-iap-cta {
  display: block;
  margin: 12px 14px 0;
  background: var(--gold-2);
  color: var(--ink-1);
  border: 1.5px solid var(--ink-1);
  border-radius: var(--r-pill);
  padding: 8px;
  font-family: var(--font-display);
  font-size: 17px;
  letter-spacing: .1em;
  cursor: pointer;
  box-shadow: 0 3px 0 var(--ink-1);
  text-align: center;
  width: calc(100% - 28px);
}

.bz-section-head {
  font-family: var(--font-display);
  font-size: var(--fs-label);
  color: var(--ink-3);
  letter-spacing: .25em;
  text-align: center;
  margin: 8px 0 10px;
  position: relative;
}
.bz-section-head::before, .bz-section-head::after {
  content: ""; position: absolute; top: 50%;
  width: 80px; height: 1px;
  background: var(--paper-edge);
}
.bz-section-head::before { left: calc(50% - 110px); }
.bz-section-head::after  { right: calc(50% - 110px); }

/* canonical 5⭐ */
.star-row { display: inline-flex; gap: 3px; }
.star { width: 18px; height: 18px; display: inline-grid; place-items: center; font-family: var(--font-display); line-height: 1; }
.star::before { content: "★"; font-size: 18px; color: var(--ink-4); text-shadow: 0 1px 0 rgba(0,0,0,.1); }
.star.is-on::before { color: var(--gold-2); text-shadow: 0 1px 0 rgba(0,0,0,.15); }

/* 业务卡 · 3-col */
.bz-card {
  background: var(--paper-2);
  border: 1.5px solid var(--paper-edge);
  border-radius: 10px;
  padding: 10px;
  margin-bottom: 10px;
  position: relative;
  box-shadow: var(--sh-card);
  display: grid;
  grid-template-columns: 84px 1fr 92px;
  gap: 10px;
  align-items: center;
  cursor: pointer;
  transition: transform var(--dur-fast) var(--ease-out);
}
.bz-card:active { transform: scale(.99); }
.bz-card.bz-locked { opacity: .6; cursor: default; }
.bz-card.bz-locked:active { transform: none; }
.bz-card-left { display: flex; flex-direction: column; align-items: stretch; gap: 6px; }
.bz-card-illu {
  width: 84px; height: 80px;
  background: var(--paper-1);
  border: 1.5px solid var(--paper-edge);
  border-radius: 8px;
  background-image: repeating-linear-gradient(45deg, transparent 0 8px, rgba(139,111,71,.14) 8px 10px);
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: 28px;
  color: var(--ink-2);
  position: relative;
}
.bz-card-illu .red-bang {
  position: absolute; top: -6px; left: -6px;
  width: 22px; height: 22px;
  background: var(--cinnabar-1); color: var(--paper-1);
  border: 1.5px solid var(--paper-1); border-radius: 50%;
  font-family: var(--font-num); font-size: 12px;
  display: grid; place-items: center; line-height: 1;
  z-index: 3;
}
.bz-card-mid { min-width: 0; display: flex; flex-direction: column; gap: 4px; align-items: center; justify-content: center; }
.bz-card-name { font-family: var(--font-display); font-size: var(--fs-h2); color: var(--ink-1); }
.bz-card-name.lock-name { color: var(--ink-3); }
.bz-card-income {
  font-family: var(--font-num);
  font-size: 15px;
  color: var(--ink-1);
  display: inline-flex; align-items: center; gap: 4px;
  background: var(--paper-1);
  border: 1px solid var(--paper-edge);
  border-radius: 4px;
  padding: 2px 8px;
}
.bz-card-income .ic-seal {
  background: var(--jade); color: var(--paper-1);
  width: 16px; height: 16px; font-size: 11px;
  border-radius: 2px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}
.bz-card-lv { font-family: var(--font-num); font-size: 13px; color: var(--ink-3); }
.bz-card-upgrade {
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 6px;
  padding: 5px;
  font-family: var(--font-display);
  font-size: 14px;
  letter-spacing: .08em;
  box-shadow: 0 2px 0 var(--ink-1);
  text-align: center;
  cursor: pointer;
}
.bz-card-upgrade:active { transform: translateY(2px); box-shadow: 0 1px 0 var(--ink-1); }

/* mgr 环形 widget */
.mgr-widget { display: flex; flex-direction: column; align-items: center; gap: 4px; text-align: center; }
.mgr-ring { position: relative; width: 60px; height: 60px; }
.mgr-ring svg { position: absolute; inset: 0; width: 100%; height: 100%; transform: rotate(-90deg); }
.mgr-ring .ring-bg { fill: none; stroke: var(--paper-edge); stroke-width: 3; }
.mgr-ring .ring-fg { fill: none; stroke: var(--jade); stroke-width: 3; stroke-linecap: round; stroke-dasharray: 100; stroke-dashoffset: 100; }
.mgr-ring.is-has-mgr .ring-fg { animation: ringSweep 3s linear infinite; }
.mgr-ring.is-no-mgr  .ring-fg { animation: ringSweep 60s linear infinite; stroke: var(--cinnabar-1); }
@keyframes ringSweep { from { stroke-dashoffset: 100; } to { stroke-dashoffset: 0; } }

.mgr-face {
  position: absolute; inset: 6px;
  background: var(--paper-1);
  border-radius: 50%;
  border: 1.5px solid var(--paper-edge);
  display: grid; place-items: center;
  font-family: var(--font-display);
  font-size: 18px;
  color: var(--ink-2);
  background-image: repeating-linear-gradient(45deg, transparent 0 5px, rgba(139,111,71,.16) 5px 7px);
}
.mgr-face.is-empty {
  background: transparent;
  background-image: none;
  border-style: dashed;
  color: var(--ink-3);
  font-size: 26px;
  cursor: pointer;
}
.mgr-face.lock-face {
  background: var(--ink-4); color: var(--paper-1);
  border-style: solid;
  width: 60px; height: 60px;
  position: relative; inset: auto;
}

.mgr-coin-pop {
  position: absolute;
  top: -22px; left: 50%;
  transform: translateX(-50%);
  font-family: var(--font-num);
  font-size: 13px;
  color: var(--jade);
  font-weight: 700;
  display: inline-flex; align-items: center; gap: 3px;
  white-space: nowrap;
  pointer-events: none;
  opacity: 0;
}
.mgr-coin-pop .ic-seal {
  background: var(--cur-coin); color: var(--paper-1);
  width: 13px; height: 13px; font-size: 10px;
  border-radius: 2px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}
.mgr-ring.is-has-mgr .mgr-coin-pop { animation: mgrCoinTick 3s linear infinite; }
@keyframes mgrCoinTick {
  0%, 88% { opacity: 0; transform: translate(-50%, 4px); }
  92%     { opacity: 1; transform: translate(-50%, -6px); }
  100%    { opacity: 0; transform: translate(-50%, -28px); }
}

.mgr-collect {
  background: var(--jade);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: 8px;
  padding: 6px 14px;
  font-family: var(--font-display);
  font-size: 15px;
  cursor: pointer;
  box-shadow: 0 2px 0 var(--ink-1);
  display: inline-flex; align-items: center; gap: 4px;
  letter-spacing: .04em;
}
.mgr-collect .ic-seal {
  background: var(--cur-coin); color: var(--paper-1);
  width: 16px; height: 16px; font-size: 11px;
  border-radius: 2px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}

/* unowned */
.bz-card.is-unowned { grid-template-columns: 84px 1fr; }
.bz-card.is-unowned .bz-card-mid { align-items: center; }
.bz-card-purchase {
  margin-top: 4px;
  background: var(--cinnabar-1);
  color: var(--paper-1);
  border: 1.5px solid var(--ink-1);
  border-radius: var(--r-pill);
  padding: 7px 16px;
  font-family: var(--font-display);
  font-size: 17px;
  letter-spacing: .12em;
  cursor: pointer;
  box-shadow: 0 3px 0 var(--ink-1);
  display: inline-flex; align-items: center; gap: 6px;
  justify-content: center;
}
.bz-card-purchase .seal-jade {
  background: var(--cur-jade); color: var(--paper-1);
  width: 18px; height: 18px; font-size: 12px;
  border-radius: 3px;
  display: grid; place-items: center;
  font-family: var(--font-display);
}

.bottom-fade { height: 24px; }
</style>
