# projectE · 大掌柜

> 现代版 BitLife 类放置养成游戏视频帧 → 宋朝古风(江南水乡水墨彩绘)Vue 工程重建。

## 当前阶段

看 [`PROGRESS.md`](PROGRESS.md)。Phase B T-B1~T-B5 ✅ / T-B6 待启动。

## 跑工程

```bash
cd final && npm install && npm run dev
# 浏览器打开 http://localhost:5173
```

## 视觉真值参考

`preview/`:
- `大掌柜.html` — ⭐ canonical 全集(Phase A + T-B1~T-B5)
- `Style Lock · 风格定档.html` — 风格速查(15 色 / 8 字阶 / 9 货币 / 7 角标 / 27 古风对照)

## 入口(project-level docs)

- `PROGRESS.md` — 项目快照 / 当前阶段 / 5 已废 / 13 modal 状态(design 每次必拉)
- `AUDIT_PROTOCOL.md` — 永久流程文档 · 每次设计前的 audit 协议(design 每次必拉)
- `KICKOFF.md` — Phase A 首次启动 prompt(已过 Phase A 锁定)
- `README.md` — 本文件
- `tasks/` — 各屏一次性 task prompt(README + T-B6 当前 + archive/ 历史)
- `bugs/` — bug 报告(README + archive/ 历史 · 当前无未修)
- `design-brief/flows/` — canonical 屏映射 / 交互 / 拓扑(6 份 · design 每次必拉)
- `design-brief/analysis/` — 50 张 PNG 抽帧高清
- `design-brief/style-reference/` — 归档:Phase A 启动时的视觉参考底图(2.7MB · 已被 Style Lock 取代)

## workspace 级文档

跨项目通用规约 / 模板见 workspace 根的 `docs/` 和 `scripts/`。
