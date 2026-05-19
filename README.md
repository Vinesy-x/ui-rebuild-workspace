# projectE · 大掌柜 — 视频 UI 重建项目

## 这是什么

**视频版 UI 重建**: 把现代版互动养成手游的 50 张抽帧 → 转换成 **宋朝古风**(中国古代)的 Vue + Vite 工程实现。

- 游戏名: **大掌柜**
- 类型: 模拟、互动剧情
- 核心机制: 各种文字互动情景对话 + 事件经营
- **布局参考**: input/projectE.mp4 (现代版,488×960 竖屏,4分23秒,HEVC)
- **视觉风格**: 宋朝古风 (待用户提供风格参考图到 `design-brief/style-reference/`)

## 流程

按 [`METHODOLOGY.md`](METHODOLOGY.md) 11 步:

```
1. 视频 input/projectE.mp4              ✅
2. ffmpeg @ 1/2 fps 抽帧 → 131 张        ✅
3. dedup.py (phash) → 83 张              ✅
4. 用户筛选 → 50 张关键屏                ✅
5. 拷到 design-brief/analysis/(高清)    ✅
6. 风格参考图(宋朝)→ style-reference/   ⏳ 等用户
7. Phase A 风格定档屏:fps_0001 技能/主页 ⏳ 等用户风格参考图后启动
8. 三件套 flows(info-arch / interaction / topology)— 跟着 Phase B 推进
9. design 出 Vite Vue 工程
10. 数据接入(待加策划表)
11. 部署 / 演示
```

## 当前状态

```
projectE/
├── input/projectE.mp4              ✅ 视频原料
├── frames/
│   ├── raw/                        ✅ 131 张抽帧
│   ├── dedup/                      ✅ 83 张去重
│   ├── selected/                   ✅ 50 张筛选后
│   └── _grid_part1.png / 2.png     ✅ 缩略图 grid
├── design-brief/
│   ├── analysis/                   ✅ 50 张高清(给 design)
│   ├── reference-frames/0001_home.png  ✅ Phase A 候选屏
│   ├── style-reference/            ⏳ 宋朝风格参考图(用户传)
│   ├── data-source/                — 暂无策划表
│   ├── flows/                      — 跟 Phase A 一起推进
│   ├── tokens/                     — design 沉淀
│   └── interactions/
├── scripts/                        ✅ 通用工具(import-design.sh / extract_palette / dedup / make_grid)
└── final/                          — 等 design Phase A 后建
```

## 入口文档

- [`METHODOLOGY.md`](METHODOLOGY.md) - 11 步流程方法论
- [`KICKOFF_PROMPT.md`](KICKOFF_PROMPT.md) - 给 design 的 starter prompt(等宋朝参考图后启动)
- [`design-brief/TASKS.md`](design-brief/TASKS.md) - 任务清单(Phase A + Wave 1-8 待拆解)

## 跟 projectB 的关系

projectB 是另一个游戏的 UI 重建项目,**已有的工程模板**(scripts / ENGINEERING_TEMPLATE / KICKOFF / METHODOLOGY)从那里复用。两个项目数据独立。
