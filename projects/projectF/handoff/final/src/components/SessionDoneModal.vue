<!--
  ===========================================================================
  SessionDoneModal.vue · session 完成弹层
  ===========================================================================
  scaffold + fill(retry · contract 已就位):
   - Claude 已写完 <script setup>
   - design 沙箱:填 <template> + <style scoped> 两段 ⭐⭐⭐
   - ❌ 不要改 <script setup>
   - ⭐ binding 字典见 handoff/spec/scaffold-contract.md
   - ⚠️ 我们 store-driven · 不用 $emit · 用 onContinue / onClose 函数
  -->

<script setup lang="ts">
import { computed } from 'vue'
import { usePomodoroStore } from '../stores/usePomodoroStore'
import { useModalStore } from '../stores/useModalStore'

const pomo = usePomodoroStore()
const modal = useModalStore()

/* ⭐ design 可用的 binding(全部 reactive · template 直接 {{}}):
   字典见 handoff/spec/scaffold-contract.md */

// props · 由 modal.open('session-done', { ... }) 传入
const justFinished = computed<'focus' | 'break' | 'longBreak'>(() => modal.props.justFinished ?? 'focus')
const nextMode     = computed<'focus' | 'break' | 'longBreak'>(() => modal.props.nextMode ?? 'break')
const nextMinutes  = computed<number>(() => modal.props.nextMinutes ?? 5)
const todayCount   = computed<number>(() => modal.props.todayCount ?? 0)
const streakDays   = computed<number>(() => modal.props.streakDays ?? 0)

// 文案 helper
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
  if (nextMode.value === 'focus') return `Ready for a focused ${nextMinutes.value}m session.`
  if (nextMode.value === 'break') return `Take a ${nextMinutes.value}m breather.`
  return `Earned a longer ${nextMinutes.value}m break.`
})
const ctaText = computed(() => nextMode.value === 'focus' ? 'Start focus' : 'Start break')

// click handler · ⚠️ template @click 用这俩,不用 $emit
function onContinue () { modal.close(); pomo.continueSession() }
function onClose ()    { modal.close() }
</script>

<template>
  <div class="modal-backdrop">
    <div class="modal-card">
      <button class="modal-close" @click="onClose()" aria-label="close">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
             stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
          <line x1="6" y1="6" x2="18" y2="18"/><line x1="18" y1="6" x2="6" y2="18"/>
        </svg>
      </button>

      <div class="stamp">
        <div class="stamp-ring"></div>
        <div class="stamp-inner">
          <svg width="42" height="52" viewBox="0 0 18 22" fill="none">
            <path d="M2 11c0-3.5 3-7 7-7s7 3.5 7 7-3 8-7 8-7-4.5-7-8z" fill="var(--accent)"/>
            <path d="M7.5 4.2c0-1 .8-2 1.5-2.2.7.2 1.5 1.2 1.5 2.2"
                  stroke="var(--ink)" stroke-width="1.2" fill="none" stroke-linecap="round"/>
          </svg>
        </div>
      </div>

      <div class="eyebrow">{{ eyebrowText }}</div>
      <h2 class="modal-title">{{ titleText }}</h2>
      <p class="modal-sub">{{ subText }}</p>

      <div class="modal-ledger">
        <div class="ml-cell">
          <div class="ml-k">today</div>
          <div class="ml-v">
            <span class="big-num">{{ String(todayCount).padStart(2, '0') }}</span>
            <span class="unit">tomatoes</span>
          </div>
        </div>
        <div class="ml-divider"></div>
        <div class="ml-cell">
          <div class="ml-k">streak</div>
          <div class="ml-v">
            <template v-if="streakDays > 0">
              <span class="big-num">{{ streakDays }}</span>
              <span class="unit">{{ streakDays === 1 ? 'day' : 'days' }}</span>
            </template>
            <span v-else class="unit dash">—</span>
          </div>
        </div>
        <div class="ml-divider"></div>
        <div class="ml-cell">
          <div class="ml-k">up next</div>
          <div class="ml-v">
            <span class="big-num">{{ nextMinutes }}</span>
            <span class="unit">{{ nextMode === 'focus' ? 'focus' : nextMode === 'longBreak' ? 'long rest' : 'rest' }}</span>
          </div>
        </div>
      </div>

      <button class="primary-btn modal-cta" @click="onContinue()">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M7 4.5v15l13-7.5z"/></svg>
        <span>{{ ctaText }}</span>
      </button>
      <button class="text-btn" @click="onClose()">Not now</button>
    </div>
  </div>
</template>

<style scoped>
/* Almanac modal · design retry 2 */
.modal-backdrop {
  --bg: #f4efe6; --surface: #fbf6ec; --rule: #d9cfbf;
  --ink: #1f1915; --ink-2: #4a3f35; --ink-3: #877766;
  --accent: #c8412a;
  position: fixed; inset: 0; z-index: 50;
  background: rgba(31, 25, 21, 0.36);
  backdrop-filter: blur(3px);
  display: flex; align-items: center; justify-content: center;
  padding: 24px;
  animation: bd-fade 260ms ease-out;
}
@keyframes bd-fade { from { opacity: 0; } to { opacity: 1; } }

.modal-card {
  width: 100%; max-width: 340px;
  background: var(--surface);
  border: 1px solid var(--ink);
  border-radius: 6px;
  padding: 32px 26px 22px;
  position: relative;
  box-shadow: 8px 8px 0 var(--ink), 0 24px 60px rgba(0,0,0,0.25);
  animation: card-rise 320ms cubic-bezier(0.2, 0.8, 0.2, 1);
  font-family: 'Inter', system-ui, sans-serif;
  color: var(--ink);
}
@keyframes card-rise {
  from { transform: translateY(20px) rotate(-0.4deg); opacity: 0; }
  to   { transform: translateY(0) rotate(0); opacity: 1; }
}
.modal-close { position: absolute; top: 12px; right: 12px; width: 28px; height: 28px; border-radius: 50%; background: transparent; border: none; cursor: pointer; color: var(--ink-3); display: grid; place-items: center; }
.modal-close:hover { color: var(--ink); background: rgba(0,0,0,0.05); }

.stamp { position: relative; width: 100px; height: 100px; margin: 0 auto 14px; }
.stamp-inner { position: absolute; inset: 14px; display: grid; place-items: center; border: 1.2px solid var(--ink); border-radius: 50%; background: var(--surface); }
.stamp-ring { position: absolute; inset: 0; border: 1px dashed var(--ink-3); border-radius: 50%; opacity: 0.45; }

.eyebrow { text-align: center; font-size: 10px; letter-spacing: 0.32em; text-transform: uppercase; color: var(--accent); font-weight: 600; margin-bottom: 8px; }
.modal-title { text-align: center; font-family: 'Fraunces', serif; font-weight: 500; font-size: 32px; line-height: 1.08; margin: 0 0 8px; letter-spacing: -0.02em; }
.modal-sub { text-align: center; font-size: 13px; color: var(--ink-2); line-height: 1.5; margin: 0 0 22px; font-family: 'Fraunces', serif; font-style: italic; }

.modal-ledger { display: flex; align-items: stretch; justify-content: space-between; background: var(--bg); border: 1px solid var(--rule); border-radius: 4px; padding: 14px 14px; margin: 0 0 20px; }
.ml-cell { flex: 1; display: flex; flex-direction: column; gap: 4px; align-items: center; }
.ml-divider { width: 1px; background: var(--rule); margin: 0 4px; }
.ml-k { font-family: 'Fraunces', serif; font-style: italic; font-size: 10px; color: var(--ink-3); }
.ml-v { display: flex; align-items: baseline; gap: 4px; }
.big-num { font-family: 'JetBrains Mono', monospace; font-size: 22px; font-weight: 400; letter-spacing: -0.03em; font-variant-numeric: tabular-nums; line-height: 1; }
.unit { font-family: 'Fraunces', serif; font-style: italic; font-size: 10px; color: var(--ink-3); }
.dash { font-size: 16px; padding-top: 6px; }

.primary-btn { width: 100%; height: 52px; border-radius: 999px; background: var(--ink); color: var(--bg); border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; font-size: 14px; font-weight: 500; letter-spacing: 0.04em; text-transform: uppercase; margin-bottom: 4px; box-shadow: 0 1px 0 rgba(0,0,0,0.05), 0 6px 16px rgba(31,25,21,0.12); transition: background 140ms; }
.primary-btn:hover { background: var(--accent); }

.text-btn { width: 100%; padding: 10px; background: transparent; border: none; cursor: pointer; font-family: 'Fraunces', serif; font-style: italic; font-size: 13px; color: var(--ink-3); }
.text-btn:hover { color: var(--ink); }
</style>
