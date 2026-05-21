# screen-details · 屏字段 + 视觉元素 spec

## PomodoroTimer.vue(主屏)

布局(从上到下,viewport 448×960):

```
┌────────────────────────────┐
│  顶部条(可选 · 简单文字 / icon)│
│  Pomodoro 番茄钟           │  ← 可放 app 名 / mode tag / 设置入口
├────────────────────────────┤
│                            │
│      ⏱  当前模式           │  ← "专注中" / "休息中" / "暂停"
│                            │
│      ╭────────╮            │
│     ╱   25:00  ╲           │  ← 大圆环 · 中央显示 mm:ss
│    │   progress │          │      圆环外圈 = 倒计时进度
│     ╲          ╱           │      stroke-dasharray 计算
│      ╰────────╯            │
│                            │
│   [▶ 开始]  [⟲ 重置]        │  ← 2 按钮(开始/暂停 toggle · 重置)
│                            │
│   今日 ▢▢▢▢ 3 番           │  ← 完成数 · 可用 4 个小方块或者 chip
│                            │
└────────────────────────────┘
```

## scaffold script 提供的 props/state(template 里直接用)

| 变量 | type | 含义 |
|---|---|---|
| `mode` | `Ref<'focus' \| 'break' \| 'longBreak'>` | 当前模式 |
| `timeLeft` | `Ref<number>` | 剩余秒数 |
| `displayTime` | `ComputedRef<string>` | 格式化的 "mm:ss" |
| `progress` | `ComputedRef<number>` | 0-1 · 当前阶段已完成比例(给圆环用)|
| `running` | `Ref<boolean>` | 是否运行中 |
| `todayCount` | `ComputedRef<number>` | 今日完成的 focus session 数 |
| `modeLabel` | `ComputedRef<string>` | "专注中" / "休息中" / "暂停"(根据 mode + running)|

## scaffold script 提供的 handler

| 函数 | 行为 |
|---|---|
| `toggle()` | 开始 / 暂停 切换 |
| `reset()` | 当前阶段倒计时回到满 · running = false |
| `skipToNext()` | (可选)直接跳到下个阶段 |

## SessionDoneModal.vue

布局:

```
┌────────────────────────────┐
│  ✨ 完成一番 ✨            │
│                            │
│  休息一下吧 · 5 分钟         │
│                            │
│  今日已完成 4 番            │
│  连续 12 天                │
│                            │
│  [   继续(自动开始休息)   ] │
└────────────────────────────┘
```

scaffold script 提供:
| 变量 | 含义 |
|---|---|
| `nextMode` | `Ref<'focus' \| 'break'>` 下个阶段 |
| `nextDurationMin` | `Ref<number>` 下阶段时长(分钟)|
| `todayCount` | 同上(从 PomodoroTimer 传 prop · scaffold 已 wire)|

handler:
| 函数 | 行为 |
|---|---|
| `continue()` | 关 modal · 切换到下个阶段 · 自动开始 |

## settings.json 默认值(design 填)

```json
{
  "focusMin": 25,
  "breakMin": 5,
  "longBreakMin": 15,
  "sessionsPerLongBreak": 4
}
```

## history.json 初始(design 填)

```json
{
  "sessions": [
    { "date": "2026-05-21", "type": "focus", "completedAt": "10:25" }
  ]
}
```

可放 0-3 条示范数据 · 也可以空数组。

## 视觉风格(design 自由)

可参考方向(任选 / 自创):
- **赛博朋克霓虹**:深底 + 紫粉绿光晕 + 等宽数字字体
- **极简白底**:纯白 + 黑 / 深灰文字 + 1 主色(蓝 / 红 / 绿)
- **复古像素**:8-bit 字体 + 像素圆环 + 黄绿主色
- **杂志感**:大量留白 + 衬线字体 + 几何装饰
- **iOS 系统风**:SF Pro + 圆角卡片 + 半透磨砂

不用复刻 projectE 古风 · 这次任意。

## 强约束

1. viewport 448×960(手机竖屏)· 所有视觉适配
2. 字号至少 14px(可读性)
3. 大圆环计时器是视觉焦点(占主屏 50% 以上面积)
4. 按钮 tap target ≥ 44px(手指点得到)
5. modal scrim 锁定 `rgba(0,0,0,.5)` + `backdrop-filter: blur(8px)`(跟 projectE 一致)
