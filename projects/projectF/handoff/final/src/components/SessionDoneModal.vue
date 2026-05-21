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
  <!-- ⭐⭐⭐ DESIGN: 在这里填 modal 内容 ⭐⭐⭐
       参考:handoff/spec/scaffold-contract.md 列了所有可用 binding
       ⚠️ click 用 @click="onContinue" / @click="onClose" · 不用 $emit  -->
</template>

<style scoped>
  /* ⭐⭐⭐ DESIGN: 在这里填本 modal 专有 style ⭐⭐⭐
     约束:居中 · 宽 320-360px · 跟主屏视觉一致 */
</style>
