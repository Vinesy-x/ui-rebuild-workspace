# projectF · Pomodoro 番茄钟 — 实时进度

> ⚠️ **design 沙箱开工前必拉这一份**(每个 task 都要)。
>
> raw URL: `https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/projects/projectF/handoff/PROGRESS.md`
>
> ⚠️ **沙箱目录结构**:repo = `ui-rebuild-workspace/`(多游戏 workspace);**你的边界 = `projects/projectF/handoff/`** · 一切产出必须在此之内 · 不要碰 `_internal/`(user 内部 · design 不读不写)。

---

## 📋 项目快照(design 第一眼看这里就知道全局)

| 项 | 值 |
|---|---|
| **类型** | Pomodoro 番茄钟(单页前端 demo)|
| **核心功能** | 25 分钟专注 → 5 分钟休息 → 循环 · 记录完成数 |
| **视觉风格** | **由 design 自由选**(对照 projectE 古风 · 这次可以现代 / 极简 / 赛博 / etc.)|
| **viewport** | 448×960 竖屏 |
| **工程栈** | Vite + Vue 3(`<script setup>` + TS)+ Pinia + Vue Router |
| **完整 KICKOFF** | `projects/projectF/handoff/KICKOFF.md` |

---

## ⚠️ 本项目 = scaffold + fill 工作流验证

projectF 不是产品 · 目的是**验证一种新协作流程**:

| 谁 | 写什么 |
|---|---|
| **Claude** | `.vue` 的 `<script setup>` 段(完整 · 含 import / state / handler / 注释)+ Vite scaffold + 全部工程层代码 |
| **design 沙箱** | 只填 `<template>` + `<style scoped>` 两段 + `data/*.json` 内容 |

design 拉到的 `.vue` 文件 · `<script setup>` 段是预先写好的 + 有注释告诉它可用变量。design 只往 ⭐⭐⭐ 标记的两个空段里填东西 → 出 design link → Claude verify(diff script 段不变)→ vite build OK 即完工。

**预期好处**:
- design 产出**直接就是最终代码**,不再翻译 / 不再重写
- "design 写工程代码被 Claude 改" 的无用功 = 0
- design 视觉精度 100% 保留(直接写 .vue template/style)
- Claude 完全掌控工程结构

---

## 当前阶段:**Phase 0 完成 ✅**(2026-05-21 · design link `wMQcTP-Gqd9bTDYtMs3-uw`)

| 阶段 | 状态 | 备注 |
|---|---|---|
| Phase 0(scaffold + fill 工作流验证)| ✅ **完成** | design 出视觉 · Claude 扩 scaffold helper · vite build 1.29s 通过 |

### Phase 0 复盘

design 视觉风格选:**warm modern-minimal**(陶土红 / 鼠尾草绿 · oklch 色板 · JetBrains Mono 数字 · 大 SVG 圆环 + 60 刻度 + 番茄/绿叶图标)。

**design 行为评价**:
- ✅ 严格遵守"不改 `<script setup>` 段"
- ✅ 完整交付 5 件:view + modal 的 template/style + 2 JSON + preview/pomodoro.html
- ✅ `_design-notes.md` 6 段全填(超出 3 必填要求)
- ✅ 主动声明"沙箱配额用光,没拉真 script · 模板用了假设契约"→ 把契约列在 .vue 注释里
- ✅ Risk 段提议 scaffold 加 `ringCircumference` const + `pipClass` helper(确实需要)

**Claude verify 操作**:
- 把 design 的 template + style 100% 不动 import 进 scaffold
- 扩 script setup 加 design 假设的 13 个 binding(alias 既有 / 加 derived helper)
- SessionDoneModal 一处例外:design 用 `$emit`,我们架构是 store-driven,template 改 2 行 `$emit(...)` → method call(视觉零影响)
- vite build 通过 1.29s · 43 modules

**结论**:scaffold + fill 工作流**成立**。0 重写 design 代码,只补 scaffold helper。可推广到 projectE T-B6 + 后续新项目。

---

## 工程层(`projects/projectF/handoff/final/`)

- ✅ Vite + Vue 3 + Pinia + Router 工程 scaffold
- ✅ `npm install && npm run dev` 可起(实测 vite build 通过)
- ✅ 1 view(`PomodoroTimer.vue` · script 完整 · ⭐ template/style 留空)
- ✅ 1 modal(`SessionDoneModal.vue` · 同上)
- ⏳ 2 data(`settings.json` / `history.json` · ⭐ 字段提示 · 待 design 填)

---

## 下一步

设计第一屏:**PomodoroTimer.vue** 主屏。

design 填 2 段:
- `<template>` — 用 scaffold 里准备的变量(详见文件 ⭐⭐⭐ 注释)
- `<style scoped>` — 视觉风格 design 自由发挥

同时填 `data/settings.json`(默认 25min focus + 5min break)+ `data/history.json`(初始为空数组)。

---

## audit-pre-design 协议(每个 task 阶段 1 跑)

### 步骤 1 · 同步 GitHub(拉 handoff/ 整个目录递归)

design 沙箱状态 ≠ GitHub 真值 · 每次开工必拉:
```
1. https://api.github.com/repos/Vinesy-x/ui-rebuild-workspace/git/trees/main?recursive=1
2. 过滤 path 以 "projects/projectF/handoff/" 开头的 blob entries
3. 每份 raw = https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/<path>
```

工作集 ~20 文件 · 含 PROGRESS / KICKOFF / spec/ / final/src/(scaffold)。
⚠️ 不要拉 `projects/projectF/_internal/`。

### 步骤 2 · 任务 A · 阅读 scaffold + 视觉填充

对照:
- `handoff/spec/screen-details.md` — 屏布局描述 + 字段表
- `handoff/final/src/views/PomodoroTimer.vue` scaffold — Claude 准备的 import / state / handler
- `handoff/final/src/components/SessionDoneModal.vue` scaffold — modal 同上

按 scaffold 里 ⭐⭐⭐ 注释指引填两段。

### 完成 → 出 design link · 必带 _design-notes.md

`_design-notes.md` 3 段必填:
- 产出清单(填了哪些文件 · 填了什么)
- 跳过未做项(scaffold 里某变量没用到 · 或建议 Claude 加什么)
- 风险 / 待用户确认

⚠️ **绝对不要改 `<script setup>` 段**(Claude 会 diff · 改了 = 退回)
