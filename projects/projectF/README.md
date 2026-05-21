# projectF

> UI 重建项目,在 ui-rebuild-workspace 下。

## 目录边界(handoff / _internal 强隔离)

```
projectF/
├── README.md                  ← 本文件
├── handoff/                   ⭐ design 唯一边界
│   ├── PROGRESS.md            ⭐ 每次必拉
│   ├── KICKOFF.md             首次启动
│   ├── spec/                  canonical 真值
│   ├── tasks/                 各屏 task prompt
│   ├── preview/               HTML 真值
│   └── final/                 Vite + Vue 3 工程
└── _internal/                 ⬅ design 不碰
    ├── analysis/              Claude 分析用 PNG
    ├── bugs/                  bug 报告
    ├── frames/                ffmpeg 抽帧三层
    └── input/                 视频原料
```

## 当前阶段
看 `handoff/PROGRESS.md`

## 给 design
首次:整段复制粘贴 `handoff/KICKOFF.md`
后续:发短指令 + `handoff/tasks/T-B<N>.md` raw URL

## 跑工程
```bash
cd handoff/final && npm install && npm run dev
# 浏览器:http://localhost:5180/(projectF 固定 5180 · 跟 projectE 5173 / 其他项目隔开)
```
