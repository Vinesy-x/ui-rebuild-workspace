# projectF · Pomodoro 番茄钟 · KICKOFF

整段复制粘贴下面 ``` 包起来的内容,发给 design 沙箱。

---

```
projectF · Pomodoro 番茄钟 · 设计任务

【这是 scaffold + fill 工作流验证项目 · 不是真要交付的产品】

工作流(全新模式 · 跟之前 projectE 不同):
- Claude 已 scaffold 完整 Vue 工程层 (script setup 已写好)
- 你只填 <template> 和 <style scoped> 两段(每个 .vue 文件里有 ⭐⭐⭐ 注释标位置)
- 还要填 data/*.json 内容(字段提示在文件里)
- ⚠️ 绝对不要改 <script setup> 段(Claude 会 diff 检查 · 改了 = 退回)

⚠️ 沙箱目录结构:
- repo 根 = ui-rebuild-workspace/
- 你的边界 = projects/projectF/handoff/
- 一切产出在 handoff/ 内 · 不要碰 _internal/ (user 内部)


【步骤 1 · 拉 handoff/ 整个目录递归】

策略:
1. fetch https://api.github.com/repos/Vinesy-x/ui-rebuild-workspace/git/trees/main?recursive=1
2. 过滤 path 以 "projects/projectF/handoff/" 开头的 blob entries
3. 每份 raw = https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/<path>

工作集 ~15 文件 · ~50KB · 含 PROGRESS / spec/ / final/src/(scaffold) / etc.
不要拉 _internal/。


【步骤 2 · 项目简介】

Pomodoro 番茄钟:
- 25 分钟专注 + 5 分钟休息 · 循环
- 大圆环计时器(SVG 进度环 / CSS conic-gradient 都可)
- 开始 / 暂停 / 重置按钮
- 今日完成数显示
- 完成一个 session 后弹 modal 庆祝 + +1 计数 + 继续按钮

视觉风格 = 你自由选(现代极简 / 赛博朋克霓虹 / 复古像素 / 杂志感 / 等都行)
注意:这是手机 viewport (448×960)· 整体往移动端 UI 走

参考输入:
- handoff/spec/screen-details.md — 屏布局 + 字段定义
- handoff/spec/info-architecture.md — 1 屏 1 modal 拓扑
- handoff/final/src/views/PomodoroTimer.vue — Claude 已 scaffold · 看里面 ⭐⭐⭐ 注释
- handoff/final/src/components/SessionDoneModal.vue — 同上


【步骤 3 · 你的产出(只 4 类)】

1. 填 final/src/views/PomodoroTimer.vue 的:
   <template> ⭐⭐⭐ 段(用 scaffold 提供的变量)
   <style scoped> ⭐⭐⭐ 段(视觉自由)

2. 填 final/src/components/SessionDoneModal.vue 的:
   <template> ⭐⭐⭐ 段
   <style scoped> ⭐⭐⭐ 段

3. 填 final/src/data/settings.json 的:
   { focusMin, breakMin, longBreakMin, sessionsPerLongBreak } 默认值

4. 填 final/src/data/history.json 的:
   初始空数组 [] (有数据 demo 也可,带 1-2 个示范 session record)

5. 可选:出 handoff/preview/pomodoro.html (HTML 真值 · 视觉原型预演 · 跟最终 Vue 视觉等价)
   ⭐ 推荐做这一份,用户可以浏览器直接看视觉效果


【步骤 4 · 必出 _design-notes.md · 沙箱根】

3 段必填:

# projectF Phase 0 _design-notes

## ⭐ 产出清单
| 文件 | 新增/修改 | 一句话变更说明 |

## ⭐ 跳过未做的项
| 项 | 原因 |
(scaffold 里某变量没用到 · 或建议 Claude 加什么)

## ⭐ 风险 / 待用户确认
| # | 项 | 建议 |


【约束】

- ❌ 不要改 <script setup> 段
- ❌ 不要新增 .vue 文件(除非 _design-notes.md 提议,等 Claude 扩 scaffold)
- ❌ 不要 import 任何文件(import 都已写好)
- ❌ 不要碰 ModalShell.vue / useModalStore.ts / router.ts / main.ts
- ❌ 不要碰 _internal/

- ✅ 可以建议 Claude 改 scaffold(在 _design-notes.md 风险段提)
- ✅ 视觉风格自由选 · color / font / animation 由你决定
- ✅ 可选填 handoff/preview/pomodoro.html (HTML 真值原型 · 给用户看视觉)


【完成】

出 design link · 必带 _design-notes.md 在沙箱根 · 然后停。
不要主动做下一屏(就这 1 屏)。
```

---

## 给用户的使用方法

1. design 沙箱新会话(防漂移)
2. 整段复制粘贴上面 ``` 块
3. design 沙箱出 link 后 · 用户跑 `./scripts/import-design.sh <link> projectF`
4. Claude verify:`git diff` 检查 `<script setup>` 段没被改 · `cd handoff/final && npx vite build` 通过 · 浏览器实测
