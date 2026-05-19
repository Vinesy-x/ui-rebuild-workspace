# design-brief — 视频 UI 重建原料包

从一段手游录屏(竖屏 448×960,**卡通像素塔防对战 + 角色养成 + 抽卡**)提取的原料,供 Claude Design 完整重建 UI。

## 工作流程(两阶段)

```
Phase A:风格测试屏(1 张:fps_0012 卡组列表)
   ↓
   用户验收风格 → 风格定档(锁定 token + 组件 + SVG 清单)
   ↓
Phase B:剩余 36 张帧,逐张实现
   每张完成 → 用户验收 → 下一张
```

完整任务清单见 [`TASKS.md`](TASKS.md)。

**核心原则**:
- **1 task = 1 帧 / 1 屏**,不打包多屏
- **完成 1 张停 1 张**,等用户验收再做下一张
- 风格在 Phase A 锁定,Phase B 沿用

## 目录结构

```
design-brief/
├── README.md                  # 本文档
├── TASKS.md                   # 任务清单(Phase A + Phase B)
├── style-reference/           # 用户提供的风格参考图(Phase A 用)
│   └── README.md              # 占位说明
├── reference-frames/          # 8 张精选 PNG(每种主要界面 1 张)
├── analysis/                  # 37 张关键帧高清 PNG(覆盖所有屏)
├── tokens/
│   └── design-tokens.json     # 色板事实(REFERENCE_ONLY,Phase A 时由 Design 重新提炼)
├── flows/
│   ├── info-architecture.md   # 屏间跳转主图(Mermaid,参考)
│   └── interaction-spec.md    # 每屏可点击元素 → 目标屏(硬约束行为,不约束视觉)
└── interactions/
    └── animations.md          # 动效时序估算(参考)
```

## 原料分级

| 文件 | 权威性 |
|---|---|
| `style-reference/*.png` | **强** — Phase A 的视觉风格 ground truth |
| `analysis/*.png`、`reference-frames/*.png` | **强** — 内容 / 元素布局 ground truth |
| `tokens/design-tokens.json` | 弱 — 原视频色板事实,Phase A 由 Design 重新命名 / 选取 |
| `flows/info-architecture.md` | 弱 — 屏跳转线索 |
| `interactions/animations.md` | 弱 — 动效估算 |

## 强约束(全程,只有 3 条)

1. **每个内容元素从 PNG 真实提取**(具体卡牌名 / 等级 / 品质 / 装备 / 商品价格...)— 不许占位 mock 数据
2. **每个图标用 SVG** — 不允许 emoji / unicode 字符当图标渲染
3. **跨屏组件 + token 命名一致** — Phase A 锁定后 Phase B 沿用

## 输出位置 + 工程格式

新代码进 `final/` 目录。**重要**:`final/` 已经是一个初始化好的 **Vite + Vue 3 + TS + Pinia + Vue Router** 工程。Design 的产出必须按以下 4 类放进去:

- **token** → `final/src/styles/tokens.css`(CSS 变量)
- **共享组件** → `final/src/components/*.vue`(跨屏复用 SFC)
- **屏组件** → `final/src/views/*.vue`(每屏 1 个 SFC)
- **数据 JSON** → `final/src/data/*.json`(从 PNG 提取的池子)

**禁止再产出散装 HTML**。详细规约见 [`ENGINEERING_TEMPLATE.md`](ENGINEERING_TEMPLATE.md)。

工程跑起来:
```bash
cd final && npm install && npm run dev   # http://127.0.0.1:5173/
```

## 风格说明

**这次允许风格转换**。用户在 `style-reference/` 提供目标风格参考图,Phase A 把 `fps_0012` 用新风格重画。

- **内容元素**:从 `analysis/projectE_fps_0012.png` 提取(具体卡牌 / 等级 / 货币 ...)
- **视觉风格**:参照 `style-reference/` 里的图(色调 / 字体 / 装饰 / 整体氛围)

简言之:**新瓶装旧酒** — 内容是原视频的,风格是用户参考图的。

## 视频内容

竖屏(448×960)手游录屏,3 分 48 秒。**卡通像素塔防对战 + 角色养成 + 抽卡**(类 Brawl Stars / Castle Crush / Cards 风格)。涵盖 11+ 类独立界面:开场宝箱、主菜单、竞技场、卡组管理、卡片弹窗、角色/技能/天赋详情、装备/武器详情、神器召唤、表情商店、资源商店、新手礼包。详见 [`flows/info-architecture.md`](flows/info-architecture.md)。
