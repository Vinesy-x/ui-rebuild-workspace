# info-architecture · 屏映射 + 拓扑

projectF 极简(就 1 屏 + 1 modal · 验证 scaffold+fill 工作流为主):

```
[启动]
   ↓
PomodoroTimer 主屏(/timer 或 /)
   ├── 大圆环计时器(显示 mm:ss + 圆形进度条)
   ├── 开始 / 暂停 / 重置 三按钮
   ├── 今日完成数(显示 "今日 X 番")
   ├── 当前模式标签(专注 / 休息)
   │
   ↓ 完成一个 session
SessionDoneModal(弹层 · scrim + blur)
   ├── 庆祝信息(+1 番 · 当前连续 X 天 / X session · 等)
   ├── 切换提示(已切到下一阶段:休息 / 专注)
   └── 继续按钮(关 modal · 自动开始下一阶段)
```

## 1 屏 · 1 modal · 1 路由

| 路由 | view | modal 触发 |
|---|---|---|
| `/`(默认)| `PomodoroTimer.vue` | `session-done` 自动弹(timer 跑到 0)|

## 状态机

```
idle → running(focus 25:00 倒计时)→ done(modal 弹)→ running(break 5:00)→ done → running(focus)→ ...

reset → 回到 idle · 当前阶段清零(不影响 todayCount)
```

## modal 联动

| modal | 触发 | 关闭后 |
|---|---|---|
| `session-done` | timer 自动到 0 | 自动开始下一阶段 |

## 长休息(可选 · 不强求实现)

每完成 4 个 focus session → 弹长休息 modal(15min 而非 5min)。`scaffold script` 里已留 `longBreakMin` / `sessionsPerLongBreak` 字段供扩展。
