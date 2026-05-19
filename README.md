# projectE — 视频 UI 重建项目

## 这是什么

一个**可复用的视频 UI 提取模板** + 当前实例(分析 `input/projectE.mp4`)。

通过 11 步流程,把一段录屏转成可供 Claude Design 重建 UI 的"原料包"。范式:**原料供应**(不是规约驱动)— 让 Design 看高清 PNG 自主提炼风格,而不是按详细规约填空。

## 快速使用

### 作为模板复用(新项目)

```bash
cp -r "claude code/projectE" "claude code/<new-project>"
cd "claude code/<new-project>"
rm -rf input/* frames/raw/* frames/dedup/* frames/selected/* design-brief/analysis/* design-brief/reference-frames/*
# 把新视频放进 input/
# 按 METHODOLOGY.md 跑 11 步流程
```

### 作为当前实例(继续这次)

```bash
# Step 4 人工筛选后:
./preview.sh                # 启动本地 HTTP 服务器看 Design 产物 final/
```

## 入口文档

- [`METHODOLOGY.md`](METHODOLOGY.md) — **方法论**:11 步流程 / 范式对比 / 工程经验 / 踩坑
- [`KICKOFF_PROMPT.md`](KICKOFF_PROMPT.md) — **启动提示词**:给 Claude Design 的 prompt 模板
- [`design-brief/`](design-brief/) — **最终交付物**(给 Design 的原料包,Step 8 产出)

## 目录结构

```
projectE/
├── README.md                  # 本文档
├── METHODOLOGY.md             # 11 步流程方法论(可复用)
├── KICKOFF_PROMPT.md          # 给 Design 的 starter prompt 模板
├── preview.sh                 # 启动本地 HTTP 服务器(看 final/)
├── input/                     # 原视频
├── frames/                    # 抽帧 / 去重 / 筛选产物
│   ├── raw/                   # Step 2 抽帧
│   ├── dedup/                 # Step 3 去重
│   └── selected/              # Step 4 人工筛选
├── scripts/                   # 流程脚本
│   ├── dedup.py
│   ├── build_preview.py
│   ├── make_grid.py
│   ├── extract_palette.py
│   └── lib/                   # 共享 helper
├── design-brief/              # ★ 给 Design 的原料包(Step 8 产出)
│   ├── README.md
│   ├── TASKS.md
│   ├── analysis/              # 关键帧高清 PNG
│   ├── reference-frames/      # 精选 PNG
│   ├── tokens/                # 色板事实
│   ├── flows/                 # 屏跳转
│   └── interactions/          # 动效时序
└── final/                     # Design 产出的 HTML(由 Design 生成)
```

## 关键原则

| 这样做 | 不这样做 |
|---|---|
| 给 Design 高清 PNG | 给 Design JSON elements 描述 |
| Design 主导命名 / 风格 | 我们规定 ButtonStyles.md 等组件名 |
| 强约束 3 条(禁占位 / 禁 emoji / 跨屏一致) | 详细任务卡序列规定每步做什么 |
| 浏览器实测交互 | 静态 grep 源码 |

详见 [`METHODOLOGY.md`](METHODOLOGY.md)。
