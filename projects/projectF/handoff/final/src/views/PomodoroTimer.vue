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
  <!-- ⭐⭐⭐ DESIGN: 在这里填 template ⭐⭐⭐
       参考:handoff/spec/scaffold-contract.md 列了所有可用 binding
       参考:handoff/spec/screen-details.md 描述了视觉建议  -->
</template>

<style scoped>
  /* ⭐⭐⭐ DESIGN: 在这里填本屏专有 style ⭐⭐⭐ */
</style>
