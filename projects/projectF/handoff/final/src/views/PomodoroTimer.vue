<!--
  ===========================================================================
  PomodoroTimer.vue · 主屏
  ===========================================================================
  scaffold + fill 工作流:
   - Claude 写 <script setup>(import / state / handler / derived helper)
   - design 沙箱填 <template> + <style scoped>(本文件已 import design 产出)

  本次 import: wMQcTP-Gqd9bTDYtMs3-uw
  design 假设的 binding 都已在 script setup 暴露(下方 derived block)
  template + style 100% 来自 design · 未改
  -->

<script setup lang="ts">
import { computed } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import { usePomodoroStore } from '../stores/usePomodoroStore'
import { useModalStore } from '../stores/useModalStore'
import settings from '../data/settings.json'

const pomo = usePomodoroStore()
const modal = useModalStore()
const router = useRouter()

const { mode, timeLeft, running, todayFocusCount } = storeToRefs(pomo)

/* ─── design template 假设的 binding(全部暴露 · 跟 design 风险段 #1 命名一致)─── */

const isRunning      = running                      // alias: design 用 isRunning · scaffold 是 running
const displayTime    = computed(() => pomo.displayTime)
const displayMin     = computed(() => displayTime.value.split(':')[0])
const displaySec     = computed(() => displayTime.value.split(':')[1])
const progress       = computed(() => pomo.progress)
const modeLabel      = computed(() => pomo.modeLabel)
const completedToday = todayFocusCount               // alias
const minutesToday   = computed(() => todayFocusCount.value * settings.focusMin)

const sessionsPerLongBreak = computed(() => settings.sessionsPerLongBreak)
const currentInCycle       = computed(() => (todayFocusCount.value % settings.sessionsPerLongBreak) + 1)

const ringCircumference = 892.21                     // 2π · r(142)≈ design 风险段 #2 建议
const todaySlots        = 8                          // design 风险段 #3 · 视觉量

const ringLabel = computed(() => {
  if (mode.value === 'focus') return 'FOCUS'
  if (mode.value === 'break') return 'BREAK'
  return 'LONG BREAK'
})
const ctaLabel  = computed(() => isRunning.value ? 'Pause' : 'Start')

/* design 风险段 #4 · pipClass helper */
function pipClass (i: number) {
  if (i < currentInCycle.value) return { done: true }
  if (i === currentInCycle.value && mode.value === 'focus') return { current: true }
  return {}
}

/* ─── click handler ─── */
function toggle ()       { pomo.toggle() }
function reset ()        { pomo.reset() }
function skip ()         { pomo.finishSession(); openDoneModal() }   // alias: design 用 skip · scaffold 是 skipToNext
function openSettings () { /* 当前无 /settings 路由 · 留 stub · 后续可 router.push('/settings') */ }

/* timer 跑到 0 自动弹 modal */
import { watch } from 'vue'
watch(timeLeft, (now, prev) => {
  if (prev > 0 && now === pomo.currentDurationSec && !running.value) openDoneModal()
})

function openDoneModal () {
  modal.open('session-done', {
    justFinished: pomo.mode === 'focus' ? 'break' : 'focus',  // 反推:刚切了 mode · 上一阶段是反的
    nextMode:        pomo.mode,
    nextMinutes:     Math.floor(pomo.currentDurationSec / 60),
    todayCount:      pomo.todayFocusCount,
    streakDays:      0  // TODO: store 加 streak 计算 · 当前 stub
  })
}
</script>

<template>
  <!-- ⭐⭐⭐ TEMPLATE FILL · BEGIN -->
  <div
    class="stage"
    :data-mode="mode === 'focus' ? 'focus' : 'break'"
    :data-running="String(isRunning)"
  >
    <!-- app header -->
    <header class="app-header">
      <div class="wordmark">
        <span class="dot"></span>
        <span>Pomodoro · 番茄</span>
      </div>
      <button class="icon-btn" aria-label="Settings" @click="openSettings">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="3"/>
          <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51h0a1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
        </svg>
      </button>
    </header>

    <!-- mode pill + session pips -->
    <div class="mode-row">
      <div class="mode-pill">
        <span class="glyph"></span>
        <span>{{ modeLabel }}</span>
      </div>
      <div class="pip-row">
        <span
          v-for="i in sessionsPerLongBreak"
          :key="i"
          class="pip"
          :class="pipClass(i)"
        ></span>
      </div>
    </div>

    <!-- big ring + digits -->
    <main class="timer-hero">
      <div class="ring-wrap">
        <svg class="ring-svg" viewBox="0 0 320 320" aria-hidden="true">
          <circle class="ring-track" cx="160" cy="160" r="142"/>
          <circle
            class="ring-progress"
            cx="160" cy="160" r="142"
            :stroke-dasharray="ringCircumference"
            :stroke-dashoffset="ringCircumference * (1 - progress)"
          />
        </svg>
        <div class="ring-ticks">
          <span
            v-for="i in 60"
            :key="i"
            class="tick"
            :class="{ major: (i - 1) % 5 === 0 }"
            :style="{ transform: `translate(-50%, -50%) rotate(${(i - 1) * 6}deg) translateY(-142px)` }"
          ></span>
        </div>
        <div class="ring-center">
          <div class="digits">
            <span>{{ displayMin }}</span>
            <span class="sep">:</span>
            <span>{{ displaySec }}</span>
          </div>
          <div class="ring-label">{{ ringLabel }}</div>
        </div>
      </div>
    </main>

    <!-- actions -->
    <div class="action-row">
      <button class="btn-ghost" aria-label="Reset" @click="reset">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 12a9 9 0 1 0 3-6.7"/><path d="M3 4v5h5"/>
        </svg>
      </button>
      <button class="btn-primary" :data-running="String(isRunning)" @click="toggle">
        <svg v-if="!isRunning" viewBox="0 0 24 24" fill="currentColor">
          <path d="M8 5v14l11-7z"/>
        </svg>
        <svg v-else viewBox="0 0 24 24" fill="currentColor">
          <rect x="6" y="5" width="4" height="14" rx="1"/>
          <rect x="14" y="5" width="4" height="14" rx="1"/>
        </svg>
        <span>{{ ctaLabel }}</span>
      </button>
      <button class="btn-ghost" aria-label="Skip" @click="skip">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
          <path d="M5 4l10 8-10 8z"/><path d="M19 5v14"/>
        </svg>
      </button>
    </div>

    <!-- today harvest -->
    <div class="today">
      <div class="today-label">Today's harvest</div>
      <div class="tomato-row">
        <span
          v-for="i in todaySlots"
          :key="i"
          class="tomato"
          :class="{ empty: i > completedToday }"
        ></span>
      </div>
      <div class="today-count">
        <strong>{{ completedToday }}</strong> of {{ todaySlots }} focused sessions ·
        <strong>{{ minutesToday }}</strong>m
      </div>
    </div>
  </div>
  <!-- ⭐⭐⭐ TEMPLATE FILL · END -->
</template>

<style scoped>
/* ⭐⭐⭐ STYLE FILL · BEGIN */

/* ---------- design tokens (scoped to view) ---------- */
.stage{
  --cream:        oklch(0.985 0.008 80);
  --paper:        #ffffff;
  --ink:          oklch(0.22 0.018 60);
  --ink-soft:     oklch(0.45 0.015 60);
  --ink-mute:     oklch(0.62 0.012 60);
  --hair:         oklch(0.92 0.008 60);
  --hair-soft:    oklch(0.95 0.006 60);

  --tomato:       oklch(0.64 0.155 32);
  --tomato-deep:  oklch(0.55 0.16 32);
  --tomato-soft:  oklch(0.92 0.04 32);
  --sage:         oklch(0.62 0.075 155);
  --sage-deep:    oklch(0.53 0.08 155);
  --sage-soft:    oklch(0.93 0.025 155);

  --shadow-sm: 0 1px 2px rgba(40,30,20,.05), 0 1px 1px rgba(40,30,20,.04);
  --shadow-md: 0 6px 16px -8px rgba(40,30,20,.18), 0 2px 6px -2px rgba(40,30,20,.08);
  --shadow-lg: 0 24px 48px -16px rgba(40,30,20,.18), 0 8px 16px -8px rgba(40,30,20,.10);

  width: 100%;
  min-height: 100vh;
  background: var(--cream);
  color: var(--ink);
  font-family: 'Inter', system-ui, -apple-system, sans-serif;
  display: flex;
  flex-direction: column;
  transition: background .6s ease;
  -webkit-font-smoothing: antialiased;
}
.stage[data-mode="break"]{ background: oklch(0.985 0.012 155); }

/* ---------- header ---------- */
.app-header{
  padding: 16px 28px 0;
  display: flex; align-items: center; justify-content: space-between;
  flex-shrink: 0;
}
.wordmark{
  display: flex; align-items: center; gap: 8px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 12px; font-weight: 600;
  letter-spacing: 0.14em; text-transform: uppercase;
  color: var(--ink-soft);
  white-space: nowrap;
}
.wordmark .dot{
  width: 10px; height: 10px; border-radius: 50%;
  background: var(--tomato);
  box-shadow: 0 0 0 2px var(--tomato-soft);
  transition: background .4s ease, box-shadow .4s ease;
}
.stage[data-mode="break"] .wordmark .dot{
  background: var(--sage);
  box-shadow: 0 0 0 2px var(--sage-soft);
}
.icon-btn{
  width: 36px; height: 36px;
  display: inline-flex; align-items: center; justify-content: center;
  border: 0; background: transparent;
  color: var(--ink-soft);
  border-radius: 12px;
  cursor: pointer;
  transition: background .15s ease, color .15s ease;
}
.icon-btn:hover{ background: var(--hair-soft); color: var(--ink); }

/* ---------- mode pill + pips ---------- */
.mode-row{
  padding: 24px 28px 0;
  display: flex; flex-direction: column; align-items: center; gap: 16px;
  flex-shrink: 0;
}
.mode-pill{
  display: inline-flex; align-items: center; gap: 8px;
  padding: 8px 16px; border-radius: 999px;
  background: var(--tomato-soft); color: var(--tomato-deep);
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px; font-weight: 700;
  letter-spacing: 0.18em; text-transform: uppercase;
  transition: background .4s ease, color .4s ease;
}
.stage[data-mode="break"] .mode-pill{
  background: var(--sage-soft); color: var(--sage-deep);
}
.mode-pill .glyph{
  width: 6px; height: 6px; border-radius: 50%;
  background: currentColor;
}
.pip-row{ display: flex; gap: 10px; align-items: center; }
.pip{
  width: 8px; height: 8px; border-radius: 50%;
  background: var(--hair);
  transition: background .3s ease, transform .3s ease, box-shadow .3s ease;
}
.pip.done{ background: var(--tomato); }
.pip.current{
  background: var(--tomato);
  transform: scale(1.4);
  box-shadow: 0 0 0 3px var(--tomato-soft);
}
.stage[data-mode="break"] .pip.done{ background: var(--sage); }
.stage[data-mode="break"] .pip.current{
  background: var(--sage);
  box-shadow: 0 0 0 3px var(--sage-soft);
}

/* ---------- ring hero ---------- */
.timer-hero{
  flex: 1;
  display: flex; align-items: center; justify-content: center;
  position: relative;
}
.ring-wrap{ position: relative; width: 320px; height: 320px; }
.ring-svg{
  width: 100%; height: 100%;
  transform: rotate(-90deg);
}
.ring-track{ fill: none; stroke: var(--hair-soft); stroke-width: 6; }
.ring-progress{
  fill: none;
  stroke: var(--tomato);
  stroke-width: 8;
  stroke-linecap: round;
  transition: stroke-dashoffset .9s linear, stroke .4s ease;
}
.stage[data-mode="break"] .ring-progress{ stroke: var(--sage); }
.ring-ticks{ position: absolute; inset: 0; pointer-events: none; }
.tick{
  position: absolute;
  left: 50%; top: 50%;
  width: 2px; height: 6px;
  background: var(--hair);
  border-radius: 1px;
}
.tick.major{ height: 10px; background: var(--ink-mute); }

.ring-center{
  position: absolute; inset: 0;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 6px;
}
.digits{
  font-family: 'JetBrains Mono', monospace;
  font-size: 72px; font-weight: 500;
  letter-spacing: -0.02em; line-height: 1;
  color: var(--ink);
  font-variant-numeric: tabular-nums;
  display: flex; align-items: baseline;
}
.digits .sep{
  color: var(--ink-mute);
  margin: 0 -2px;
  animation: blink 1s steps(2, end) infinite;
}
.stage[data-running="false"] .digits .sep{ animation: none; opacity: 1; }
@keyframes blink{ 50% { opacity: 0.25; } }

.ring-label{
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px; font-weight: 600;
  letter-spacing: 0.22em; text-transform: uppercase;
  color: var(--ink-mute);
}

/* ---------- actions ---------- */
.action-row{
  padding: 24px 28px 0;
  display: flex; align-items: center; justify-content: center; gap: 14px;
  flex-shrink: 0;
}
.btn-primary{
  height: 64px; min-width: 192px; padding: 0 32px;
  background: var(--ink); color: var(--cream);
  border: 0; border-radius: 999px;
  font-family: 'Inter';
  font-size: 16px; font-weight: 600;
  letter-spacing: 0.06em; text-transform: uppercase;
  cursor: pointer;
  display: inline-flex; align-items: center; justify-content: center; gap: 12px;
  box-shadow: var(--shadow-md);
  transition: transform .12s ease, box-shadow .2s ease, background .2s ease, color .2s ease;
}
.btn-primary:hover{ transform: translateY(-1px); box-shadow: var(--shadow-lg); }
.btn-primary:active{ transform: translateY(0); }
.btn-primary[data-running="true"]{
  background: var(--paper); color: var(--ink);
  border: 1.5px solid var(--ink);
}
.btn-primary svg{ width: 16px; height: 16px; }

.btn-ghost{
  height: 48px; width: 48px; border-radius: 999px;
  background: transparent;
  border: 1.5px solid var(--hair);
  color: var(--ink-soft);
  cursor: pointer;
  display: inline-flex; align-items: center; justify-content: center;
  transition: background .15s ease, border-color .15s ease, color .15s ease;
}
.btn-ghost:hover{
  background: var(--paper); border-color: var(--ink-mute); color: var(--ink);
}
.btn-ghost svg{ width: 18px; height: 18px; }

/* ---------- today harvest ---------- */
.today{
  padding: 28px 28px 36px;
  display: flex; flex-direction: column; align-items: center; gap: 12px;
  flex-shrink: 0;
}
.today-label{
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px; font-weight: 600;
  letter-spacing: 0.22em; text-transform: uppercase;
  color: var(--ink-mute);
}
.tomato-row{
  display: flex; gap: 8px; flex-wrap: wrap;
  align-items: center; justify-content: center;
  max-width: 260px;
}
.tomato{
  width: 14px; height: 14px; border-radius: 50%;
  background: var(--tomato);
  box-shadow: inset 0 -2px 0 rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
  position: relative;
  transition: transform .2s ease, opacity .3s ease;
}
.tomato::before{
  content: "";
  position: absolute;
  top: -2px; left: 50%;
  transform: translateX(-50%) rotate(-12deg);
  width: 6px; height: 3px;
  background: var(--sage-deep);
  border-radius: 2px 2px 0 0;
}
.tomato.empty{
  background: transparent;
  border: 1.5px dashed var(--hair);
  box-shadow: none;
}
.tomato.empty::before{ display: none; }
.today-count{ font-family: 'Inter'; font-size: 13px; color: var(--ink-soft); }
.today-count strong{ color: var(--ink); font-weight: 600; }

/* ⭐⭐⭐ STYLE FILL · END */
</style>
