/**
 * Pomodoro 核心状态(Pinia)
 * - 模式切换(focus / break / longBreak)
 * - 倒计时(setInterval 驱动)
 * - 历史 session 累计
 */
import { defineStore } from 'pinia'
import settings from '../data/settings.json'

export type Mode = 'focus' | 'break' | 'longBreak'

interface PomodoroState {
  mode: Mode
  timeLeft: number          // 剩余秒数
  running: boolean
  todayFocusCount: number   // 今日完成的 focus session 数
  totalFocusCount: number   // 历史累计
  intervalId: number | null
}

const today = () => new Date().toISOString().slice(0, 10)

export const usePomodoroStore = defineStore('pomodoro', {
  state: (): PomodoroState => ({
    mode: 'focus',
    timeLeft: settings.focusMin * 60,
    running: false,
    todayFocusCount: 0,
    totalFocusCount: 0,
    intervalId: null
  }),

  getters: {
    /** "mm:ss" 格式 */
    displayTime (state): string {
      const m = Math.floor(state.timeLeft / 60)
      const s = state.timeLeft % 60
      return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
    },

    /** 0-1 · 当前阶段已完成比例(给圆环用)*/
    progress (state): number {
      const total = this.currentDurationSec
      return total > 0 ? 1 - state.timeLeft / total : 0
    },

    /** 当前阶段总秒数 */
    currentDurationSec (state): number {
      if (state.mode === 'focus')      return settings.focusMin * 60
      if (state.mode === 'break')      return settings.breakMin * 60
      if (state.mode === 'longBreak')  return settings.longBreakMin * 60
      return settings.focusMin * 60
    },

    /** 显示文本:"专注中" / "休息中" / "长休息" / "暂停" */
    modeLabel (state): string {
      if (!state.running && state.timeLeft < this.currentDurationSec) return '暂停'
      if (state.mode === 'focus')     return '专注中'
      if (state.mode === 'break')     return '休息中'
      if (state.mode === 'longBreak') return '长休息'
      return ''
    },

    /** 下个模式 */
    nextMode (state): Mode {
      if (state.mode === 'focus') {
        const nextFocusCount = state.todayFocusCount + 1
        if (nextFocusCount % settings.sessionsPerLongBreak === 0) return 'longBreak'
        return 'break'
      }
      return 'focus'
    },

    /** 下个模式时长(分钟) */
    nextDurationMin (): number {
      if (this.nextMode === 'focus')     return settings.focusMin
      if (this.nextMode === 'break')     return settings.breakMin
      if (this.nextMode === 'longBreak') return settings.longBreakMin
      return settings.focusMin
    }
  },

  actions: {
    /** 开始 / 暂停 切换 */
    toggle () {
      if (this.running) return this.pause()
      return this.start()
    },

    start () {
      if (this.running) return
      this.running = true
      this.intervalId = window.setInterval(() => this.tick(), 1000)
    },

    pause () {
      this.running = false
      if (this.intervalId !== null) {
        window.clearInterval(this.intervalId)
        this.intervalId = null
      }
    },

    /** 重置当前阶段 · 不影响 today/totalCount */
    reset () {
      this.pause()
      this.timeLeft = this.currentDurationSec
    },

    /** 每秒 tick · 倒计时 + 完成时弹 modal */
    tick () {
      if (!this.running) return
      this.timeLeft--
      if (this.timeLeft <= 0) this.finishSession()
    },

    /** 当前 session 完成 */
    finishSession () {
      this.pause()
      if (this.mode === 'focus') {
        this.todayFocusCount++
        this.totalFocusCount++
      }
      // 切到下个模式 · 但不自动开始(等用户点 modal 的"继续")
      const next = this.nextMode
      this.mode = next
      this.timeLeft = this.currentDurationSec
    },

    /** modal "继续"按钮 · 切换到下个阶段并自动开始(已在 finishSession 切了模式,这里只 start)*/
    continueSession () {
      this.start()
    }
  }
})
