<!--
  ===========================================================================
  PomodoroTimer.vue · 主屏(唯一一屏)
  ===========================================================================

  ⚠️ scaffold + fill 工作流:
   - Claude 已写完 <script setup> 段(import / state / handler / 注释)
   - design 沙箱负责:填 <template> + <style scoped> 两段 ⭐⭐⭐
   - ❌ 不要改 <script setup> 段(改了 = 退回 · Claude 会 git diff 检查)
   - ✅ 反馈/缺什么:写在 _design-notes.md 风险段 · 不要私自加 import / state

  布局参考:见 handoff/spec/screen-details.md 的 PomodoroTimer 段
  -->

<script setup lang="ts">
import { computed } from 'vue'
import { usePomodoroStore } from '../stores/usePomodoroStore'
import { useModalStore } from '../stores/useModalStore'
import { storeToRefs } from 'pinia'

const pomo = usePomodoroStore()
const modal = useModalStore()

/* ─────────────────────────────────────────────────────────
   ⭐ design template 里可用的变量(全部已 reactive · 直接用)
   ─────────────────────────────────────────────────────────
   mode              当前模式 ref · 值:'focus' | 'break' | 'longBreak'
   timeLeft          剩余秒数 ref · 数字
   displayTime       格式化时间 computed · "mm:ss" 字符串
   progress          阶段进度 computed · 0-1 · 给圆环用(stroke-dashoffset / conic-gradient 都行)
   running           是否运行中 ref · boolean
   todayFocusCount   今日完成 focus 数 ref · 数字
   modeLabel         显示文本 computed · "专注中" / "休息中" / "暂停" / etc
   ───────────────────────────────────────────────────────── */
const { mode, timeLeft, running, todayFocusCount } = storeToRefs(pomo)
const displayTime = computed(() => pomo.displayTime)
const progress    = computed(() => pomo.progress)
const modeLabel   = computed(() => pomo.modeLabel)

/* ─────────────────────────────────────────────────────────
   ⭐ design template 里可用的 click handler
   ─────────────────────────────────────────────────────────
   toggle()          点开始 / 暂停 按钮 · pomo.toggle() 切换 running
   reset()           点重置按钮 · 当前阶段倒计时回满 · running = false
   skipToNext()      (可选)直接跳下个阶段(开发期方便测试 · 正式上线可隐藏)
   ───────────────────────────────────────────────────────── */
function toggle ()      { pomo.toggle() }
function reset ()       { pomo.reset() }
function skipToNext ()  { pomo.finishSession(); openDoneModal() }

/* session 完成时自动弹 modal · 监听 timeLeft 到 0 那一刻
   (pomo.finishSession 内部已切 mode + 重置 timeLeft · 这里只负责开 modal)*/
import { watch } from 'vue'
watch(timeLeft, (now, prev) => {
  if (prev > 0 && now === pomo.currentDurationSec && !running.value) {
    // timeLeft 从倒计中 → 跳到下阶段满值 = session 完成的信号
    openDoneModal()
  }
})

function openDoneModal () {
  modal.open('session-done', {
    todayFocusCount: pomo.todayFocusCount,
    nextMode: pomo.mode,
    nextDurationMin: pomo.nextDurationMin
  })
}
</script>

<template>
  <!-- ⭐⭐⭐ DESIGN: 在这里填 template ⭐⭐⭐ -->
  <!--
    建议结构(可自由调):
      <div class="screen pomo-screen">
        <header class="top-bar"> ... mode 标签 / app 名 ... </header>

        <main class="timer-main">
          <div class="ring" :style="{ '--progress': progress }">
            <span class="time">{{ displayTime }}</span>
            <span class="label">{{ modeLabel }}</span>
          </div>
        </main>

        <section class="actions">
          <button class="btn primary" @click="toggle">
            {{ running ? '暂停' : '开始' }}
          </button>
          <button class="btn ghost" @click="reset">重置</button>
        </section>

        <footer class="today">
          今日 · {{ todayFocusCount }} 番
        </footer>
      </div>

    设计风格自由(见 handoff/spec/screen-details.md 风格建议)。
  -->
</template>

<style scoped>
/* ⭐⭐⭐ DESIGN: 在这里填本屏专有 style ⭐⭐⭐ */
/*
  约束:
    - viewport 448×960 竖屏
    - 大圆环占视觉中心(50%+ 面积)
    - 字号 ≥ 14px(timer 中央时间字大点更帅 · 比如 64-96px)
    - 按钮 tap target ≥ 44px
    - 配色 / 字体 / 动效自由发挥

  常用模式(任选):
    - 大圆环 conic-gradient: background: conic-gradient(var(--accent) calc(var(--progress) * 360deg), var(--track) 0deg);
    - 大圆环 SVG: <svg viewBox="0 0 100 100"><circle r="45" stroke-dasharray="282" :stroke-dashoffset="(1-progress)*282"/></svg>
    - 中心时间用等宽数字字体(font-variant-numeric: tabular-nums)
*/
</style>
