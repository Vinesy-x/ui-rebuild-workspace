# SCAFFOLD + FILL 工作流(2026-05 起 · projectF 试点)

> 解决"design 写工程代码被 Claude 重写"的无用功问题。
> 三方分工 v3 · 跟之前"design 出完整 Vue · Claude refactor"模式区分。

---

## 一句话规则

**Claude 写 `<script setup>` · design 填 `<template>` + `<style scoped>`**

每个 `.vue` 文件里 Claude 留两段 `⭐⭐⭐ DESIGN: 在这里填` 注释 · design 只往这两段里填东西。

---

## 谁写什么

| 文件 / 段落 | 谁写 | 内容 |
|---|---|---|
| `<script setup>` | **Claude** | import / ref / computed / store / utility / handler / watch / 注释 |
| `<template>` | **design** | HTML 结构 · 调用 scaffold 提供的变量 / handler |
| `<style scoped>` | **design** | 本组件视觉(color / layout / animation / etc.)|
| `data/*.json` 内容 | **design** | 字段值(scaffold 提供字段定义)|
| `preview/*.html`(可选) | design | 视觉原型(可选 · 给用户提前看效果) |
| `useXxxStore.ts` / `services/` / `utils/` | **Claude** | 业务逻辑 / 数据流 / 持久化 |
| `router.ts` / `main.ts` / `App.vue` | **Claude** | 工程脚手架 |
| `ModalShell.vue` map / `useModalStore.ts` ModalName | **Claude** | 新 modal 时 Claude 注册 · design 不动 |
| 全局 `styles/*.css`(tokens / components) | **Claude** | canonical 锁定 · 不许 design 改 |

---

## 流程(3 步 · 每个新屏)

```
1. Claude 看 spec/ + canonical → 写 .vue scaffold
   - 完整 <script setup>(import / state / handler / 注释 ⭐ 标可用变量)
   - 空 <template> ⭐⭐⭐ 注释 + 建议结构
   - 空 <style scoped> ⭐⭐⭐ 注释 + 视觉约束提示
   - 同时新建相关 store / data 文件 + 注册 modal(如需)
   - ⭐ 同步更新 handoff/spec/scaffold-contract.md(列暴露的 binding 全表)
     这是 design 第一拉的"binding 字典" · 不让它猜名字

2. design 沙箱
   - 拉 handoff/ 整个目录
   - 看 .vue scaffold 里的 ⭐⭐⭐ 注释
   - 填两段 + data/*.json 内容
   - 可选出 preview/<screen>.html 原型
   - 出 design link · 必带 _design-notes.md

3. Claude verify
   - import-design.sh
   - git diff 检 <script setup> 段未改(改了 = 退回 重做)
   - cd handoff/final && npx vite build
   - 浏览器实测 · 反馈视觉 bug 给 design / 反馈代码 bug 自修
   - 更新 PROGRESS.md 标 ✅
```

---

## design 的 6 条铁规

1. **不要改 `<script setup>` 段**(Claude 会 diff · 改了 = 退回)
2. **不要新增 .vue 文件**(scaffold 里没有的)— 有需要在 `_design-notes.md` 风险段提
3. **不要 import 任何文件**(scaffold 都 import 好了 · 直接用变量就行)
4. **不要碰** `ModalShell.vue` / `useModalStore.ts` / `router.ts` / `main.ts` / `App.vue`
5. **不要写全局样式**(`styles/*.css` 是 canonical)· scoped 块里写本组件样式即可
6. **不要猜 binding 名** — 看 `handoff/spec/scaffold-contract.md` 那是 scaffold 暴露的所有 binding 字典 · 不在里面就别用 · 缺什么写 `_design-notes.md` 风险段让 Claude 扩

如果 design 觉得 scaffold 漏了什么变量 / handler · **不要私自加**,在 `_design-notes.md` 写"建议 Claude 加 X" → Claude 看到后扩 scaffold → design 第二轮再用。

---

## Claude 的 5 条铁规

1. **scaffold 必须**给 design 留 ⭐⭐⭐ 注释 + 可用变量清单 + 建议结构(template / style 都要)
2. **scaffold 不要 over-design** — 不强行抽 composable / utility 让 design 看不懂 · 直观就是好
3. **verify 时不重写 design 的 template / style** — 视觉是 design 的权威 · 只反馈不直接改(除非违反 token 锁)
4. **新增 store / utility 后**更新 `PROGRESS.md` 说"X 已就位" · design 拉 PROGRESS 时知道
5. **scaffold 改 binding 时必须同步更新** `handoff/spec/scaffold-contract.md` · 这是 design 的字典 · 不一致 = design 猜错的根源

---

## 跟之前模式对比

| 维度 | 旧模式(projectE T-B1~T-B5)| **新模式(projectF Phase 0+)**|
|---|---|---|
| design 写 .vue | 完整(template + style + **script**)| 只填 template + style |
| Claude 后处理 | refactor / dedup / 抽 utility / 改 type | verify(不重写)|
| "无用功" | 高(script 段经常被重写)| **0**(design 不写 script)|
| 单一真值 | .vue(含 script)| .vue(script Claude 写 · template/style design 写) |
| 视觉权威 | design(但 Claude 会改字号 / 颜色违规)| design 100%(只反馈不改)|
| 工程权威 | 半 design 半 Claude | **100% Claude** |
| 时序 | design 先 · Claude 后 refactor | **Claude 先 scaffold · design 后填** |

---

## 实验:projectF · Pomodoro 番茄钟

projectF 是第一个用新模式的项目(纯验证 · 1 屏 + 1 modal · 3-4h)。

跑通后:
- ✅ 流程顺 → 推广到 projectE T-B7+ / 新项目
- ❌ 流程不顺 → 复盘 → 回滚或调整

---

## 风险 + 防控

| 风险 | 防 |
|---|---|
| Claude scaffold 漏 design 需要的变量 | 第一轮 design 反馈 `_design-notes.md` 风险段 · Claude 补 · 第二轮再来 |
| design 偷偷改 script | git diff script 段 · 改了 = 退回 |
| scaffold 起的变量名不贴近视觉直觉 | spec/screen-details.md 提前对齐 · 命名歧义时 Claude 看 spec 取名 |
| design 卡在不知怎么调 store | scaffold 注释里给 handler 例子(像 PomodoroTimer.vue 顶部那样) |
| 时序冲突(Claude 没写完 design 不能开工) | 一次 scaffold 完整 1 屏 + 1 modal · 不分多轮 |

---

## 何时不该用这个模式

- **业务极简的 demo**(就 1 个 click + 跳页 · 抽 store / scaffold 反而麻烦)— 这种沿用旧模式 OK
- **快速原型**(只是给客户看视觉 · 不要交付代码)— design 出 HTML 真值就行,根本不用 Vue
- **design 想试一个全新视觉框架**(还没确定要不要落地)— 让它先出 HTML · 落地再 scaffold
