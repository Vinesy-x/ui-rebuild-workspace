# projectE · 大掌柜

> 现代版 BitLife 类放置养成游戏视频帧 → 宋朝古风(江南水乡水墨彩绘)Vue 工程重建。

## 目录边界(2 区强隔离 · 2026-05 refactor)

```
projects/projectE/
├── README.md           ← 本文件 · user 视角入口
│
├── handoff/            ⭐⭐⭐ design 唯一边界(拉 + 出 都在这)
│   ├── PROGRESS.md           ⭐ 实时进度(design 每次必拉)
│   ├── KICKOFF.md            Phase A 启动 prompt(已锁定)
│   ├── spec/                 canonical 6 文档(屏映射/交互/拓扑等)
│   ├── tasks/                各屏一次性 task prompt + archive
│   ├── preview/              ⭐ design 出的 HTML 真值(大掌柜.html + Style Lock)
│   └── final/                ⭐ Vite + Vue 3 工程层(design 改 + Claude verify)
│
└── _internal/          ⬅ design 不碰 · user/Claude 内部用
    ├── analysis/             Claude 分析用 PNG(png/extras/style-reference)
    ├── bugs/                 bug 报告 + archive
    ├── frames/               ffmpeg 抽帧三层(raw/dedup/selected)
    └── input/                视频原料
```

`handoff/` = design 沙箱镜像的全部 · 100% 隔离 user 内部档案。

## 当前阶段

看 [`handoff/PROGRESS.md`](handoff/PROGRESS.md)。Phase B T-B1~T-B5 ✅ / T-B6 待启动。

## 跑工程

```bash
cd handoff/final && npm install && npm run dev
# 浏览器打开 http://localhost:5173
```

## 给 design 的精简 prompt

```
projectE T-B6 物品 Tab 6 设计。拉:
https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/projects/projectE/handoff/tasks/T-B6.md

按里面 步骤 1 pull list 拉完 PROGRESS.md(含末尾 audit-pre-design 段) + canonical 6 份
+ preview HTML + final/src/
两阶段交付:阶段 1 = audit 报告 → 停 → 等放行
阶段 2 = T-B6 实现 · 严格白名单 · 必带 _design-notes.md
```

## workspace 级文档

跨项目通用规约 / 模板见 workspace 根的 `docs/` 和 `scripts/`。
