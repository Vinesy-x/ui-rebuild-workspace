# scaffold-contract · scaffold 暴露给 template 的所有 binding

> ⭐ design 沙箱开工前**先看这一份**,而不是凭空猜 binding 名。
> Claude 维护这份文档,确保跟 `final/src/views/*.vue` 和 `final/src/components/*.vue` 的 `<script setup>` 段 100% 一致。
> design 写 template 时**只用这里列的 binding**,不要假设 scaffold 有别的。

---

## `views/PomodoroTimer.vue`

### refs / computed(直接用 · 已 reactive)

| binding | 类型 | 含义 |
|---|---|---|
| `mode` | `Ref<'focus' \| 'break' \| 'longBreak'>` | 当前模式 |
| `isRunning` | `Ref<boolean>` | timer 是否运行中 |
| `timeLeft` | `Ref<number>` | 剩余秒数(裸数字 · 通常用 displayTime/displayMin/displaySec)|
| `displayTime` | `ComputedRef<string>` | 格式化全字符串 "25:00" |
| `displayMin` | `ComputedRef<string>` | "25"(从 displayTime 拆)|
| `displaySec` | `ComputedRef<string>` | "00"(从 displayTime 拆)|
| `progress` | `ComputedRef<number>` | 0-1 阶段进度(给 ring stroke-dashoffset)|
| `modeLabel` | `ComputedRef<string>` | 英文 · "ready when you are" / "in focus" / "paused · ready to resume" / "take a breather" / "long rest" 等(随 idle/running/paused × 3 mode 变)|
| `ringLabel` | `ComputedRef<string>` | "FOCUS" / "BREAK" / "LONG BREAK" |
| `ctaLabel` | `ComputedRef<string>` | "Start" / "Pause" |
| `completedToday` | `Ref<number>` | 今日完成 focus 数 |
| `minutesToday` | `ComputedRef<number>` | 今日完成的总分钟 |
| `currentInCycle` | `ComputedRef<number>` | 当前 cycle 第几个 focus(1 起 · 用于 pip)|
| `sessionsPerLongBreak` | `ComputedRef<number>` | 每 cycle 几个 focus(用于 pip 数量)|

### 常量(直接用)

| binding | 类型 | 值 / 含义 |
|---|---|---|
| `ringCircumference` | `number` | `892.21`(`2π·r(142)` · 给 SVG ring stroke-dasharray)|
| `todaySlots` | `number` | `8`(今日格子总数 · 给 .tomato v-for)|

### 方法(template `@click` 用)

| method | 行为 |
|---|---|
| `toggle()` | 开始 / 暂停 切换 |
| `reset()` | 当前阶段倒计时回满 · isRunning 归 false |
| `skip()` | 跳到下个阶段 + 弹完成 modal |
| `openSettings()` | 留 stub · 当前无 /settings 路由(可绑给 settings 图标)|

### helper(`@click` 或 `:class` 用)

| helper | 签名 | 行为 |
|---|---|---|
| `pipClass(i: number)` | `(i: number) => Record<string, boolean>` | 返回 `{ done: true }` / `{ current: true }` / `{}` · ⚠️ **`i` 是 1-based**(跟 Vue `v-for="i in N"` 一致 · 第 1 个 pip 传 1 · 不要传 `i - 1`)|

---

## `components/SessionDoneModal.vue`

### props(由 `modal.open('session-done', { ... })` 传 · template 直接读)

| binding | 类型 | 含义 |
|---|---|---|
| `justFinished` | `ComputedRef<'focus' \| 'break' \| 'longBreak'>` | 刚结束的 mode |
| `nextMode` | `ComputedRef<'focus' \| 'break' \| 'longBreak'>` | 下个 mode |
| `nextMinutes` | `ComputedRef<number>` | 下个 mode 时长(分)|
| `todayCount` | `ComputedRef<number>` | 今日完成 focus 数 |
| `streakDays` | `ComputedRef<number>` | 连续天数(目前 stub 为 0 · 后续 store 加 · ⚠️ 文案不要假设 > 0)|

### 文案 helper(`{{ }}` 用)

| binding | 类型 | 含义 |
|---|---|---|
| `eyebrowText` | `ComputedRef<string>` | "Focus complete" / "Break over" / "Long break over" |
| `titleText` | `ComputedRef<string>` | "Nice work!" / "Back to it" |
| `subText` | `ComputedRef<string>` | "Ready for a focused 25m session." 等 |
| `ctaText` | `ComputedRef<string>` | "Start focus" / "Start break" |

### click handler(template `@click` 用 · **不用 $emit**)

| method | 行为 |
|---|---|
| `onContinue()` | 关 modal + 自动开始下个阶段 |
| `onClose()` | 关 modal · 不开始下阶段 |

---

## 通用约定

1. **不用 $emit / defineEmits** · modal 通过 import store 直接调 action · 不用 emit 上抛
2. **不要在 template 里 import 任何文件** · scaffold 都 import 好了
3. **不要在 template 里 ref()** · 所有 reactive state 都在 script · template 只用
4. **数据 JSON 字段名固定** · `settings.json` = `{focusMin, breakMin, longBreakMin, sessionsPerLongBreak}` · `history.json` = 数组 of `{id, date, mode, durationMin, completedAt, label?}`
5. **缺什么不要私自加** · 在 `_design-notes.md` 风险段提"建议 scaffold 加 X" → Claude 看到后下一轮扩

---

## 命名约定

- 布尔 ref 用 `is*` prefix:`isRunning` / `isLoading` / `isOpen` 等
- 数值 ref 用具体名:`timeLeft` / `completedToday` / `nextMinutes`
- 字符串 computed 用 `*Label` 或 `*Text` suffix:`modeLabel` / `subText`
- helper 函数小驼峰:`pipClass(i)` / `formatDuration(s)`
- click handler 用 `on*` prefix(modal)或动词原型(view):`onContinue` / `toggle` / `reset`
