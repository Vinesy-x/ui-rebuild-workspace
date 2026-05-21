<!--
  ===========================================================================
  PomodoroTimer.vue · 主屏
  ===========================================================================
  scaffold + fill 工作流(retry · contract 已就位):
   - Claude 已写完 <script setup> 段
   - design 沙箱负责:填 <template> + <style scoped> 两段 ⭐⭐⭐
   - ❌ 不要改 <script setup>(改了 = 退回)
   - ⭐ 不要猜 binding 名 · 看 handoff/spec/scaffold-contract.md(字典 · 必看)
   - 缺什么 → _design-notes.md 风险段提 · Claude 扩 scaffold + 更新 contract
  -->

<script setup lang="ts">
import { computed, watch } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import { usePomodoroStore } from '../stores/usePomodoroStore'
import { useModalStore } from '../stores/useModalStore'
import settings from '../data/settings.json'

const pomo = usePomodoroStore()
const modal = useModalStore()
const router = useRouter()

const { mode, timeLeft, running, todayFocusCount } = storeToRefs(pomo)

/* ─────────────────────────────────────────────────────────────────
   ⭐ design 可用的 binding · 全部已 reactive · template 直接用
   ⭐ 详细字典见 handoff/spec/scaffold-contract.md(命名+类型+含义)
   ───────────────────────────────────────────────────────────────── */

// refs / computed
const isRunning      = running
const displayTime    = computed(() => pomo.displayTime)
const displayMin     = computed(() => displayTime.value.split(':')[0])
const displaySec     = computed(() => displayTime.value.split(':')[1])
const progress       = computed(() => pomo.progress)
const modeLabel      = computed(() => pomo.modeLabel)
const completedToday = todayFocusCount
const minutesToday   = computed(() => todayFocusCount.value * settings.focusMin)
const sessionsPerLongBreak = computed(() => settings.sessionsPerLongBreak)
const currentInCycle = computed(() => (todayFocusCount.value % settings.sessionsPerLongBreak) + 1)
const ringLabel      = computed(() => {
  if (mode.value === 'focus') return 'FOCUS'
  if (mode.value === 'break') return 'BREAK'
  return 'LONG BREAK'
})
const ctaLabel       = computed(() => isRunning.value ? 'Pause' : 'Start')

// 常量
const ringCircumference = 892.21
const todaySlots        = 8

// helper
function pipClass (i: number) {
  if (i < currentInCycle.value) return { done: true }
  if (i === currentInCycle.value && mode.value === 'focus') return { current: true }
  return {}
}

// methods
function toggle ()       { pomo.toggle() }
function reset ()        { pomo.reset() }
function skip ()         { pomo.finishSession(); openDoneModal() }
function openSettings () { /* stub · 当前无 /settings 路由 */ }

// timer 跑到 0 自动弹 modal
watch(timeLeft, (now, prev) => {
  if (prev > 0 && now === pomo.currentDurationSec && !running.value) openDoneModal()
})
function openDoneModal () {
  modal.open('session-done', {
    justFinished: pomo.mode === 'focus' ? 'break' : 'focus',
    nextMode:     pomo.mode,
    nextMinutes:  Math.floor(pomo.currentDurationSec / 60),
    todayCount:   pomo.todayFocusCount,
    streakDays:   0
  })
}
</script>

<template>
  <div class="screen">
    <!-- ── header ─────────────────────────────────────────────── -->
    <div class="header">
      <div class="brand">
        <div class="brand-mark"></div>
        <div class="brand-text">
          <div class="brand-name">almanac</div>
          <div class="brand-sub">№ <span class="num">142</span> · vol.iii</div>
        </div>
      </div>
      <button class="icon-btn" @click="openSettings()" aria-label="settings">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="2.4"/>
          <path d="M19.4 14a1.7 1.7 0 0 0 .34 1.87l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.7 1.7 0 0 0-1.87-.34 1.7 1.7 0 0 0-1.03 1.56V20a2 2 0 0 1-4 0v-.09A1.7 1.7 0 0 0 9 18.35a1.7 1.7 0 0 0-1.87.34l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.7 1.7 0 0 0 4.65 14a1.7 1.7 0 0 0-1.56-1.03H3a2 2 0 0 1 0-4h.09A1.7 1.7 0 0 0 4.65 8 1.7 1.7 0 0 0 4.31 6.13l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.7 1.7 0 0 0 9 3.65 1.7 1.7 0 0 0 10.03 2.09V2a2 2 0 0 1 4 0v.09A1.7 1.7 0 0 0 15 3.65a1.7 1.7 0 0 0 1.87-.34l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.7 1.7 0 0 0 19.35 8 1.7 1.7 0 0 0 20.91 9.03H21a2 2 0 0 1 0 4h-.09A1.7 1.7 0 0 0 19.35 14z"/>
        </svg>
      </button>
    </div>

    <!-- ── mode row ───────────────────────────────────────────── -->
    <div class="mode-row">
      <span class="rule"></span>
      <span class="mode-label">{{ modeLabel }}</span>
      <span class="rule"></span>
    </div>

    <!-- ── ring ───────────────────────────────────────────────── -->
    <div class="ring-wrap">
      <div class="ring">
        <svg width="320" height="320" viewBox="0 0 320 320">
          <g stroke="var(--rule)" stroke-width="1">
            <line v-for="i in 60" :key="i"
                  :x1="160 + Math.cos((i-1)/60*Math.PI*2 - Math.PI/2) * ((i-1)%5===0 ? 154 : 158)"
                  :y1="160 + Math.sin((i-1)/60*Math.PI*2 - Math.PI/2) * ((i-1)%5===0 ? 154 : 158)"
                  :x2="160 + Math.cos((i-1)/60*Math.PI*2 - Math.PI/2) * 162"
                  :y2="160 + Math.sin((i-1)/60*Math.PI*2 - Math.PI/2) * 162"
                  :opacity="(i-1)%5===0 ? 0.55 : 0.25"/>
          </g>
          <circle cx="160" cy="160" r="142" fill="none" stroke="var(--rule)" stroke-width="2"/>
          <circle cx="160" cy="160" r="142" fill="none"
                  stroke="var(--accent)" stroke-width="3"
                  :stroke-dasharray="ringCircumference"
                  :stroke-dashoffset="ringCircumference * (1 - progress)"
                  transform="rotate(-90 160 160)"
                  class="ring-progress"/>
        </svg>
        <div class="ring-center">
          <div class="ring-label">{{ ringLabel }}</div>
          <div class="ring-digits">
            <span class="num">{{ displayMin }}</span><span class="colon">:</span><span class="num">{{ displaySec }}</span>
          </div>
          <div class="ring-foot">today's session</div>
        </div>
      </div>
    </div>

    <!-- ── pips (cycle progress) ──────────────────────────────── -->
    <!-- Claude 修:contract 是 1-based · design 假设 0-based · 改 i-1 → i -->
    <div class="pip-row">
      <div v-for="i in sessionsPerLongBreak" :key="i"
           class="pip" :class="pipClass(i)"></div>
    </div>

    <!-- ── CTA cluster ────────────────────────────────────────── -->
    <div class="cta-row">
      <button class="ghost-btn" @click="reset()" aria-label="reset">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 12a9 9 0 1 0 3-6.7"/><path d="M3 4v5h5"/>
        </svg>
      </button>
      <button class="primary-btn" :data-running="isRunning" @click="toggle()">
        <svg v-if="isRunning" width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
          <rect x="6.5" y="5" width="4" height="14" rx="1"/><rect x="13.5" y="5" width="4" height="14" rx="1"/>
        </svg>
        <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
          <path d="M7 4.5v15l13-7.5z"/>
        </svg>
        <span>{{ ctaLabel }}</span>
      </button>
      <button class="ghost-btn" @click="skip()" aria-label="skip">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <path d="M5 4l10 8-10 8z"/><line x1="19" y1="5" x2="19" y2="19"/>
        </svg>
      </button>
    </div>

    <!-- ── ledger / today ─────────────────────────────────────── -->
    <div class="ledger">
      <div class="ledger-row">
        <div class="ledger-cell">
          <div class="ledger-k">harvested today</div>
          <div class="ledger-v">
            <span class="big-num">{{ String(completedToday).padStart(2, '0') }}</span>
            <span class="unit">{{ completedToday === 1 ? 'tomato' : 'tomatoes' }}</span>
          </div>
        </div>
        <div class="ledger-cell ledger-cell-right">
          <div class="ledger-k">minutes in focus</div>
          <div class="ledger-v">
            <span class="big-num">{{ minutesToday }}</span>
            <span class="unit">min</span>
          </div>
        </div>
      </div>
      <div class="rule-h"></div>
      <div class="tomato-grid">
        <div v-for="i in todaySlots" :key="i" class="tomato" :class="{ done: i <= completedToday }">
          <svg v-if="i <= completedToday" width="18" height="22" viewBox="0 0 18 22" fill="none">
            <path d="M2 11c0-3.5 3-7 7-7s7 3.5 7 7-3 8-7 8-7-4.5-7-8z" fill="var(--accent)"/>
            <path d="M7.5 4.2c0-1 .8-2 1.5-2.2.7.2 1.5 1.2 1.5 2.2" stroke="var(--ink)" stroke-width="1.2" fill="none" stroke-linecap="round"/>
          </svg>
          <svg v-else width="18" height="22" viewBox="0 0 18 22" fill="none">
            <path d="M2 11c0-3.5 3-7 7-7s7 3.5 7 7-3 8-7 8-7-4.5-7-8z" stroke="var(--rule)" stroke-width="1" stroke-dasharray="2 2" fill="none"/>
          </svg>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Almanac aesthetic · design retry 2 (jF2YgFzKCNAywRuO_8dUTA) */
.screen {
  --bg: #f4efe6; --surface: #fbf6ec; --rule: #d9cfbf;
  --ink: #1f1915; --ink-2: #4a3f35; --ink-3: #877766;
  --accent: #c8412a; --accent-deep: #9c2c1a;
  width: 100%; min-height: 100%; background: var(--bg); color: var(--ink);
  font-family: 'Inter', system-ui, sans-serif;
  display: flex; flex-direction: column; position: relative;
}

.header { display: flex; align-items: center; justify-content: space-between; padding: 14px 22px 6px; }
.brand { display: flex; align-items: center; gap: 10px; }
.brand-mark { width: 22px; height: 22px; border-radius: 50%; background: var(--accent); position: relative; }
.brand-mark::after { content:''; position:absolute; top:-3px; left:50%; transform:translateX(-50%) rotate(-12deg); width:8px; height:6px; background:var(--ink); border-radius:50% 50% 30% 30%; }
.brand-name { font-family: 'Fraunces', serif; font-weight: 500; font-size: 17px; letter-spacing: -0.01em; line-height: 1; }
.brand-sub  { font-size: 9px; letter-spacing: 0.16em; text-transform: uppercase; color: var(--ink-3); margin-top: 4px; font-weight: 500; }
.icon-btn { width: 36px; height: 36px; border-radius: 50%; border: 1px solid var(--rule); background: transparent; color: var(--ink-2); display: grid; place-items: center; cursor: pointer; transition: all 140ms; }
.icon-btn:hover { background: var(--surface); color: var(--ink); }

.mode-row { display: flex; align-items: center; gap: 14px; padding: 18px 36px 0; }
.mode-row .rule { flex: 1; height: 1px; background: var(--rule); }
.mode-label { font-family: 'Fraunces', serif; font-style: italic; font-size: 13px; color: var(--ink-2); white-space: nowrap; }

.ring-wrap { display: flex; justify-content: center; padding: 16px 0 4px; }
.ring { position: relative; width: 320px; height: 320px; }
.ring-progress { transition: stroke-dashoffset 800ms cubic-bezier(0.4, 0, 0.2, 1); }
.ring-center { position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 6px; }
.ring-label { font-family: 'Fraunces', serif; font-style: italic; font-size: 11px; letter-spacing: 0.32em; text-transform: uppercase; color: var(--ink-3); font-weight: 500; }
.ring-digits { font-family: 'JetBrains Mono', monospace; font-size: 76px; font-weight: 400; letter-spacing: -0.04em; line-height: 1; display: flex; align-items: baseline; }
.ring-digits .num { font-variant-numeric: tabular-nums; }
.ring-digits .colon { opacity: 0.25; padding: 0 2px; }
.ring-foot { margin-top: 8px; font-size: 11px; color: var(--ink-3); letter-spacing: 0.18em; text-transform: uppercase; font-weight: 500; }

.pip-row { display: flex; gap: 10px; justify-content: center; margin-top: 4px; }
.pip { width: 8px; height: 8px; border-radius: 999px; border: 1px solid var(--rule); transition: all 220ms; }
.pip.done { background: var(--accent); border-color: transparent; }
.pip.current { width: 26px; background: var(--accent); border-color: transparent; }

.cta-row { display: flex; align-items: center; justify-content: center; gap: 16px; padding: 22px 32px 0; }
.primary-btn { flex: 1; max-width: 220px; height: 56px; border-radius: 999px; background: var(--ink); color: var(--bg); border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; font-size: 15px; font-weight: 500; letter-spacing: 0.04em; text-transform: uppercase; box-shadow: 0 1px 0 rgba(0,0,0,0.05), 0 6px 16px rgba(31,25,21,0.12); }
.primary-btn[data-running="true"] { background: var(--accent); }
.ghost-btn { width: 44px; height: 44px; border-radius: 50%; background: transparent; border: 1px solid var(--rule); color: var(--ink-2); display: grid; place-items: center; cursor: pointer; transition: all 140ms; }
.ghost-btn:hover { color: var(--accent); border-color: var(--accent); }

.ledger { margin: auto 22px 24px; padding: 18px 18px 16px; background: var(--surface); border: 1px solid var(--rule); border-radius: 4px; position: relative; }
.ledger::before, .ledger::after { content:''; position:absolute; width:1px; height:8px; background:var(--rule); top:-5px; }
.ledger::before { left: 24px; } .ledger::after { right: 24px; }
.ledger-row { display: flex; justify-content: space-between; align-items: flex-end; gap: 16px; }
.ledger-cell { display: flex; flex-direction: column; gap: 4px; }
.ledger-cell-right { text-align: right; align-items: flex-end; }
.ledger-k { font-family: 'Fraunces', serif; font-style: italic; font-size: 11px; color: var(--ink-3); }
.ledger-v { display: flex; align-items: baseline; gap: 6px; }
.big-num { font-family: 'JetBrains Mono', monospace; font-size: 32px; font-weight: 400; line-height: 1; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; }
.unit { font-family: 'Fraunces', serif; font-style: italic; font-size: 12px; color: var(--ink-3); }
.rule-h { height: 1px; margin: 14px 0 12px; background-image: linear-gradient(to right, var(--rule) 50%, transparent 50%); background-size: 6px 1px; background-repeat: repeat-x; }
.tomato-grid { display: flex; gap: 6px; align-items: center; }
</style>
