<!--
  HudBar · 主菜单顶部双行 HUD
  9 类资源 + 角色名条 + Bonus 4x 红包气泡
  对应 fps_0035 顶部
-->
<script setup lang="ts">
import { useModalStore } from '../stores/useModalStore'
interface Props {
  level: number
  coin: number
  coinDelta: string
  mood: number
  moodDelta: string
  jade: number
  health: number
  healthDelta: string
  star: number
  date: { era: string; day: string; m: string }
  charName?: string
}
defineProps<Props>()
const store = useModalStore()
</script>

<template>
  <header class="hud">
    <div class="avatar-wrap" @click="store.open('character')">
      <div class="avatar-frame">王</div>
      <div class="avatar-dot"></div>
      <div class="avatar-lv">Lv {{ level }}</div>
    </div>

    <div class="hud-cell" @click="store.open('shop', {tab:'money'})">
      <span class="ic-seal ic-coin">銅</span>
      <span class="num">{{ coin.toLocaleString() }}</span>
    </div>
    <div class="hud-cell" @click="store.open('character')">
      <span class="ic-seal ic-mood">心</span>
      <span class="num">{{ mood }}</span>
      <span class="pill pill--loss">{{ moodDelta }}</span>
    </div>
    <div class="hud-cell" @click="store.open('shop', {tab:'jade'})">
      <span class="ic-seal ic-jade">玉</span>
      <span class="num">{{ jade }}</span>
    </div>
    <button class="gear-btn" @click="store.open('settings')"></button>

    <div class="hud-cell">
      <span class="ic-seal ic-coin2">寳</span>
      <span class="pill pill--income">{{ coinDelta }}</span>
    </div>
    <div class="hud-cell" @click="store.open('health')">
      <span class="ic-seal ic-heart">壽</span>
      <span class="num">{{ health }}</span>
      <span class="pill pill--income">{{ healthDelta }}</span>
    </div>
    <div class="hud-cell" @click="store.open('happiness')">
      <span class="ic-seal ic-star">星</span>
      <span class="num">{{ star }}</span>
    </div>
    <div class="cal" @click="store.open('date')">
      <div class="y">{{ date.era }}</div>
      <div class="d">{{ date.day }}</div>
      <div class="m">{{ date.m }}</div>
    </div>
  </header>
</template>

<style scoped>
.hud {
    position: relative;
    z-index: 30;
    background: var(--paper-2);
    border-bottom: 1px solid var(--paper-edge);
    box-shadow: 0 1px 0 rgba(0,0,0,.04), inset 0 -2px 0 var(--gold-1);
    padding: 8px 10px 8px;
    display: grid;
    grid-template-columns: 54px 1.15fr 1.05fr .95fr 38px;
    grid-template-rows: 1fr 1fr;
    column-gap: 6px;
    row-gap: 4px;
    align-items: center;
  }

.avatar-wrap {
    grid-row: 1 / span 2;
    width: 52px; height: 52px;
    position: relative;
    margin-top: 2px;
    cursor: pointer;
  }

.avatar-frame {
    width: 52px; height: 52px;
    border-radius: 50%;
    background:
      radial-gradient(circle at 30% 30%, var(--paper-1) 0%, var(--paper-3) 80%);
    border: 2px solid var(--gold-1);
    box-shadow: inset 0 0 0 1px var(--paper-1);
    overflow: hidden;
    display: grid; place-items: center;
    font-family: var(--font-display);
    color: var(--ink-2);
    font-size: 30px;
  }

.avatar-lv {
    position: absolute;
    bottom: -3px; left: 50%; transform: translateX(-50%);
    background: var(--ink-1); color: var(--paper-1);
    font-family: var(--font-num);
    font-size: 15px;
    padding: 1px 6px;
    border-radius: var(--r-pill);
    border: 1px solid var(--gold-1);
    white-space: nowrap;
    letter-spacing: .02em;
    line-height: 1.2;
  }

.avatar-dot {
    position: absolute; top: -2px; right: -2px;
    width: 10px; height: 10px;
    background: var(--cinnabar-2);
    border: 1.5px solid var(--paper-1);
    border-radius: 50%;
  }

.hud-cell {
    display: flex;
    align-items: center;
    gap: 4px;
    font-family: var(--font-num);
    font-size: 18px;
    color: var(--ink-1);
    line-height: 1;
    cursor: pointer;
    padding: 2px 0;
    white-space: nowrap;
    overflow: hidden;
  }

.hud-cell .num { font-weight: var(--fw-medium); letter-spacing: -.02em; }

.hud-cell .sub {
    font-size: 15px;
    color: var(--ink-3);
    font-family: var(--font-num);
  }

.ic { width: 22px; height: 22px; display: inline-grid; place-items: center; flex: none; }

.ic-seal {
    width: 22px; height: 22px;
    border-radius: 3px;
    display: grid; place-items: center;
    font-family: var(--font-display);
    color: var(--paper-1);
    font-size: 17px;
    line-height: 1;
    position: relative;
    flex: none;
  }

.ic-seal::after {
    content: "";
    position: absolute; inset: 1px;
    border: 1px solid rgba(245,235,214,.3);
    border-radius: 2px;
    pointer-events: none;
  }

.ic-coin   { background: var(--cur-coin); }

.ic-jade   { background: var(--cur-jade); }

.ic-heart  { background: var(--cur-heart); }

.ic-mood   { background: var(--cur-mood);  color: var(--ink-1); }

.ic-star   { background: var(--cur-star);  color: var(--ink-1); }

.ic-coin2  { background: var(--cur-coin2); color: var(--ink-1); }

.ic-brick  { background: var(--cur-brick); }

.gear-btn {
    grid-row: 1 / 2;
    grid-column: 5;
    width: 30px; height: 30px;
    border: 1.5px solid var(--ink-2);
    background: var(--paper-1);
    border-radius: 6px;
    display: grid; place-items: center;
    cursor: pointer;
    margin-left: auto;
    position: relative;
  }

.gear-btn::before {
    content: "";
    width: 14px; height: 14px;
    background:
      conic-gradient(var(--ink-2) 0 12.5%, transparent 0 25%,
                     var(--ink-2) 0 37.5%, transparent 0 50%,
                     var(--ink-2) 0 62.5%, transparent 0 75%,
                     var(--ink-2) 0 87.5%, transparent 0 100%);
    border-radius: 50%;
    -webkit-mask: radial-gradient(circle, transparent 3px, #000 4px);
            mask: radial-gradient(circle, transparent 3px, #000 4px);
  }

.cal {
    grid-row: 2;
    grid-column: 5;
    width: 38px; height: 38px;
    border: 1.5px solid var(--ink-2);
    background: var(--paper-1);
    border-radius: 4px;
    text-align: center;
    font-family: var(--font-num);
    line-height: 1;
    padding: 2px 0;
    margin-left: auto;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

.cal .y { font-size: 14px; color: var(--ink-3); letter-spacing:.05em; line-height:1; }

.cal .d { font-size: 20px; font-weight: var(--fw-bold); color: var(--ink-1); line-height:1; margin: 2px 0; white-space: nowrap; letter-spacing: -.05em; }

.cal .m { font-size: 14px; color: var(--cinnabar-1); font-weight: var(--fw-bold); letter-spacing:.05em; line-height:1; }
</style>
