<!--
  SessionDoneModal · session 完成弹层
  本次 import: wMQcTP-Gqd9bTDYtMs3-uw

  注意:design 用了 $emit('continue') / $emit('close') · 我们的架构是 store-driven modal ·
  ModalShell 不接 emit。所以 template 里 2 处 $emit() 改成 method 调用(onContinue / onClose)。
  视觉零变化。
  -->

<script setup lang="ts">
import { computed } from 'vue'
import { usePomodoroStore } from '../stores/usePomodoroStore'
import { useModalStore } from '../stores/useModalStore'

const pomo = usePomodoroStore()
const modal = useModalStore()

/* ─── design template 假设的 props · 直接从 modal.props 读 ─── */
const justFinished  = computed<'focus' | 'break' | 'longBreak'>(() => modal.props.justFinished ?? 'focus')
const nextMode      = computed<'focus' | 'break' | 'longBreak'>(() => modal.props.nextMode ?? 'break')
const nextMinutes   = computed<number>(() => modal.props.nextMinutes ?? 5)
const todayCount    = computed<number>(() => modal.props.todayCount ?? 0)
const streakDays    = computed<number>(() => modal.props.streakDays ?? 0)

/* ─── design template 用的文案 helper(design 假设在 script · 这里实现)─── */
const eyebrowText = computed(() => {
  if (justFinished.value === 'focus') return 'Focus complete'
  if (justFinished.value === 'break') return 'Break over'
  return 'Long break over'
})

const titleText = computed(() => {
  if (justFinished.value === 'focus') return 'Nice work!'
  return 'Back to it'
})

const subText = computed(() => {
  if (nextMode.value === 'focus')    return `Ready for a focused ${nextMinutes.value}m session.`
  if (nextMode.value === 'break')    return `Take a ${nextMinutes.value}m breather.`
  return `Earned a longer ${nextMinutes.value}m break.`
})

const ctaText = computed(() => {
  if (nextMode.value === 'focus') return 'Start focus'
  return 'Start break'
})

/* ─── click handler · template 里 @click="onContinue" / @click="onClose" ─── */
function onContinue () {
  modal.close()
  pomo.continueSession()
}
function onClose () {
  modal.close()
}
</script>

<template>
  <!-- ⭐⭐⭐ TEMPLATE FILL · BEGIN -->
  <div
    class="modal-card"
    :data-next="nextMode === 'focus' ? 'focus' : 'break'"
  >
    <div class="modal-icon">
      <!-- focus complete → checkmark · break over → arrow -->
      <svg v-if="justFinished === 'focus'" viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
      <svg v-else viewBox="0 0 24 24" fill="none" stroke="currentColor"
           stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
        <path d="M5 12h14"/><path d="m13 6 6 6-6 6"/>
      </svg>
    </div>

    <div class="modal-eyebrow">{{ eyebrowText }}</div>
    <h2 class="modal-title">{{ titleText }}</h2>
    <p class="modal-sub">{{ subText }}</p>

    <div class="modal-stats">
      <div class="stat">
        <span class="stat-num">{{ todayCount }}</span>
        <span class="stat-label">Today</span>
      </div>
      <div class="stat">
        <span class="stat-num">{{ streakDays }}</span>
        <span class="stat-label">Streak</span>
      </div>
      <div class="stat">
        <span class="stat-num">{{ nextMinutes }}m</span>
        <span class="stat-label">Next</span>
      </div>
    </div>

    <div class="modal-actions">
      <button class="btn-primary" @click="onContinue">
        <svg viewBox="0 0 24 24" fill="currentColor">
          <path d="M8 5v14l11-7z"/>
        </svg>
        <span>{{ ctaText }}</span>
      </button>
      <button class="btn-text" @click="onClose">Maybe later</button>
    </div>
  </div>
  <!-- ⭐⭐⭐ TEMPLATE FILL · END -->
</template>

<style scoped>
/* ⭐⭐⭐ STYLE FILL · BEGIN */

.modal-card{
  --cream:        oklch(0.985 0.008 80);
  --paper:        #ffffff;
  --ink:          oklch(0.22 0.018 60);
  --ink-soft:     oklch(0.45 0.015 60);
  --ink-mute:     oklch(0.62 0.012 60);
  --hair-soft:    oklch(0.95 0.006 60);
  --tomato:       oklch(0.64 0.155 32);
  --tomato-soft:  oklch(0.92 0.04 32);
  --sage:         oklch(0.62 0.075 155);
  --sage-deep:    oklch(0.53 0.08 155);
  --sage-soft:    oklch(0.93 0.025 155);
  --shadow-md: 0 6px 16px -8px rgba(40,30,20,.18), 0 2px 6px -2px rgba(40,30,20,.08);
  --shadow-lg: 0 24px 48px -16px rgba(40,30,20,.18), 0 8px 16px -8px rgba(40,30,20,.10);

  width: 100%;
  max-width: 340px;
  background: var(--paper);
  border-radius: 28px;
  padding: 32px 28px 24px;
  box-shadow: var(--shadow-lg);
  text-align: center;
  font-family: 'Inter', system-ui, -apple-system, sans-serif;
  color: var(--ink);
}

.modal-icon{
  width: 64px; height: 64px;
  margin: 0 auto 16px;
  border-radius: 50%;
  background: var(--tomato);
  display: inline-flex;
  align-items: center; justify-content: center;
  box-shadow: 0 0 0 8px var(--tomato-soft);
  position: relative;
}
.modal-icon::before{
  content: "";
  position: absolute;
  top: -6px; left: 50%;
  transform: translateX(-50%) rotate(-14deg);
  width: 22px; height: 10px;
  background: var(--sage-deep);
  border-radius: 6px 6px 2px 2px;
}
.modal-icon svg{
  width: 28px; height: 28px;
  color: var(--paper);
  position: relative; z-index: 1;
}
.modal-card[data-next="break"] .modal-icon{
  background: var(--sage);
  box-shadow: 0 0 0 8px var(--sage-soft);
}

.modal-eyebrow{
  font-family: 'JetBrains Mono', monospace;
  font-size: 10px; font-weight: 700;
  letter-spacing: 0.24em; text-transform: uppercase;
  color: var(--ink-mute);
  margin-bottom: 8px;
}
.modal-title{
  font-size: 24px; font-weight: 600;
  letter-spacing: -0.01em;
  color: var(--ink);
  margin: 0 0 8px;
}
.modal-sub{
  font-size: 14px; line-height: 1.5;
  color: var(--ink-soft);
  margin: 0 0 24px;
}

.modal-stats{
  display: flex; justify-content: center; gap: 24px;
  padding: 16px 0;
  margin-bottom: 20px;
  border-top: 1px solid var(--hair-soft);
  border-bottom: 1px solid var(--hair-soft);
}
.stat{ display: flex; flex-direction: column; gap: 2px; align-items: center; }
.stat-num{
  font-family: 'JetBrains Mono', monospace;
  font-size: 22px; font-weight: 600;
  color: var(--ink); line-height: 1;
}
.stat-label{
  font-family: 'JetBrains Mono', monospace;
  font-size: 9px; font-weight: 600;
  letter-spacing: 0.2em; text-transform: uppercase;
  color: var(--ink-mute);
}

.modal-actions{ display: flex; flex-direction: column; gap: 8px; }
.btn-primary{
  width: 100%;
  height: 52px;
  background: var(--ink);
  color: var(--cream);
  border: 0; border-radius: 999px;
  font-family: 'Inter';
  font-size: 14px; font-weight: 600;
  letter-spacing: 0.06em; text-transform: uppercase;
  cursor: pointer;
  display: inline-flex; align-items: center; justify-content: center; gap: 10px;
  box-shadow: var(--shadow-md);
  transition: transform .12s ease, box-shadow .2s ease;
}
.btn-primary:hover{ transform: translateY(-1px); box-shadow: var(--shadow-lg); }
.btn-primary:active{ transform: translateY(0); }
.btn-primary svg{ width: 14px; height: 14px; }

.btn-text{
  background: transparent;
  border: 0;
  color: var(--ink-soft);
  font-family: 'Inter';
  font-size: 13px; font-weight: 500;
  padding: 10px;
  cursor: pointer;
  border-radius: 8px;
}
.btn-text:hover{ color: var(--ink); background: var(--hair-soft); }

/* ⭐⭐⭐ STYLE FILL · END */
</style>
