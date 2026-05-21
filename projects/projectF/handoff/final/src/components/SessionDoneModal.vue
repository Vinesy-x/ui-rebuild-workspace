<!--
  ===========================================================================
  SessionDoneModal.vue · session 完成弹层
  ===========================================================================

  ⚠️ scaffold + fill 工作流:
   - Claude 已写完 <script setup> 段
   - design 沙箱:填 <template> + <style scoped> 两段 ⭐⭐⭐
   - ❌ 不要改 <script setup> 段
  -->

<script setup lang="ts">
import { usePomodoroStore } from '../stores/usePomodoroStore'
import { useModalStore } from '../stores/useModalStore'

const pomo = usePomodoroStore()
const modal = useModalStore()

/* ⭐ design template 可用的 props(由 modal.open 传入):
   modal.props.todayFocusCount   今日完成数(数字)
   modal.props.nextMode          下个模式('focus' / 'break' / 'longBreak')
   modal.props.nextDurationMin   下个阶段时长(分钟数字)
*/

/* ⭐ click handler:
   continueSession()  关 modal 并自动开始下个阶段 · 这是 modal 主 CTA
   dismiss()          只关 modal 不开始 · 让用户手动控制
*/
function continueSession () {
  modal.close()
  pomo.continueSession()
}
function dismiss () {
  modal.close()
}

/* 显示用文字(template 可用)*/
const nextModeLabel = () => {
  const m = modal.props.nextMode
  if (m === 'focus')     return '专注'
  if (m === 'break')     return '休息'
  if (m === 'longBreak') return '长休息'
  return ''
}
</script>

<template>
  <!-- ⭐⭐⭐ DESIGN: 在这里填 modal 内容 ⭐⭐⭐ -->
  <!--
    可用插值:
      modal.props.todayFocusCount    今日番数(数字)
      modal.props.nextDurationMin    下阶段分钟数
      nextModeLabel()                "专注" / "休息" / "长休息" 字符串

    建议结构:
      <div class="modal session-done">
        <div class="celebrate">✨ 完成一番 ✨</div>
        <div class="hint">休息一下吧 · {{ modal.props.nextDurationMin }} 分钟</div>
        <div class="stats">
          今日已完成 {{ modal.props.todayFocusCount }} 番
        </div>
        <button class="continue-btn" @click="continueSession">
          继续({{ nextModeLabel() }})
        </button>
      </div>

    modal 整体由 ModalShell 提供 scrim + blur · 这里只画 modal 内容。
  -->
</template>

<style scoped>
/* ⭐⭐⭐ DESIGN: 在这里填本 modal 专有 style ⭐⭐⭐ */
/*
  约束:
    - 居中(ModalShell 已 flex center)
    - 宽度建议 320-360px · 高度建议 280-360px
    - 跟 PomodoroTimer 视觉风格一致
*/
</style>
