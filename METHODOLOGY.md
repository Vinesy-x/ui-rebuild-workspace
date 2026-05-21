# 视频 UI 重建方法论(v2 范式)

> 这是一份**可复用模板文档**,描述如何把一段手游/Web 应用录屏转成 Claude Design 可消费的"原料包",让 Design 重建 UI。

## 核心信念

**LLM 多模态视觉能力 > 任何中间人写的文字描述**。把视频"翻译"成抽象规约是有损压缩,在视觉密集的任务上反向抑制 Design 发挥。

**结论**:不要给 Design 详尽的"任务卡 / 组件规约 / JSON elements 描述",直接给它**高清原帧 PNG** + 少量跨屏数据,让它自主提炼风格、组件、实现。

## 范式对比

| 维度 | ❌ 规约驱动(避免) | ✅ 原料供应(推荐) |
|---|---|---|
| 主要输入 | JSON elements 描述 + 组件 md + 详细任务卡 | 高清 PNG + 跨屏跳转 + 色板事实 |
| Design 角色 | 按规约填空 | 主导设计 |
| 适合 | 结构型屏(主菜单 / 战斗 HUD) | 内容密集屏(卡牌列表 / 详情) |
| 不适合 | 内容密集屏(视觉细节被压缩抹除) | 跨屏一致性(需 Phase 0 风格定义补) |

## 11 步流程

```
Step 1   环境检查              (ffmpeg, Python, Pillow, imagehash)
Step 2   抽帧                  (scene 切换 + 固定间隔 双策略)
Step 3   pHash 去重            (相似帧合并)
Step 4   人工筛选 ⏸           (用户介入,从 100+ 张挑 30-40 张精选)
Step 5   分类(可选)            (自动按视觉特征分类 — 战斗 vs 非战斗等)
Step 6   调色板提取            (从精选帧统计色板事实)
Step 7   跨屏数据归纳          (信息架构 + 动效时序,标注 REFERENCE_ONLY)
Step 8   打包 handoff/ + _internal/  (PNG → _internal/analysis/png · 跨屏 md → handoff/spec · 色板 / KICKOFF / TASKS → handoff/)
Step 9   交给 Claude Design    (Phase 0 风格定义 → Phase 1-N 屏实现)
Step 10  浏览器交互测试        (preview server + viewport resize + DOM 实测)
Step 11  反馈修复              (具体 bug 报给 Design 让它修)
```

**关键**:Step 8 输出的 `handoff/spec/` + `_internal/analysis/` 只包含 **PNG + 跨屏数据 + 软参考**,**不包含**:
- 每张帧的 JSON elements 描述
- 详细组件 md(ButtonStyles / CardStyles 等)
- 严格任务卡序列

## handoff/ + _internal/ 标准结构(2026-05 refactor v2)

```
projects/<name>/
├── README.md                          # user 视角入口
├── handoff/                           ⭐ design 边界
│   ├── PROGRESS.md                    # 项目状态(design 每次必拉)
│   ├── KICKOFF.md                     # 首次启动 prompt
│   ├── spec/                          # canonical 屏映射 / 交互 / 拓扑(design 必读)
│   │   ├── info-architecture.md
│   │   ├── interaction-spec.md
│   │   ├── screen-details.md
│   │   └── topology.html
│   ├── tasks/                         # 各屏 task prompt(T-B<N>.md + archive)
│   ├── preview/                       # design 出的 HTML 真值
│   └── final/                         # Vite Vue 3 工程层
└── _internal/                         ⬅ design 不碰(user/Claude 内部)
    ├── analysis/
    │   ├── png/                       # 25-35 张关键帧高清 PNG
    │   ├── extras/                    # 备份抽帧
    │   └── style-reference/           # 风格参考底图(归档)
    ├── bugs/                          # bug 报告 + archive
    ├── frames/                        # ffmpeg 抽帧三层(raw / dedup / selected)
    └── input/                         # 视频原料
```

> 旧版(2026-04 前)用扁平 `design-brief/{flows,analysis,...}` 跟 `preview/ final/ tasks/ bugs/ frames/ input/` 各 standalone · 2026-05 重组为 handoff/_internal 双区,design 边界物理化。

## 3 条强约束(给 Design)

任何 v2 项目都用这 3 条,无须改:

1. **每个内容元素从 PNG 真实提取** — 卡牌的具体名字 / 等级 / 品质 / 状态都从 PNG 提取,不许 mock 占位
2. **每个图标用 SVG** — 不允许 emoji / unicode 字符当图标渲染
3. **跨屏组件命名一致** — Phase 0 定义后,后续屏沿用同一套命名

## Phase 0 — 风格定义(Design 主导)

Design 收到 design-brief 后,**先做这一步**,不要直接实现屏:

1. 完整看一遍所有 PNG
2. 自主输出:
   - 视觉风格描述
   - 色板(10-15 个核心色 + 5 档品质 + 专用色)
   - 字号体系(4-6 档)
   - SVG 资产清单(通用图标 + **每个具体单位/法术独立 SVG**)
   - 组件系统(自命名)
3. 给用户审查,对齐方向后再做 Phase 1-N

## 关键工程经验

### 1. 浏览器看产物必须起 HTTP 服务器
SVG sprite 用 `fetch()` 注入,`file://` 协议被 CORS 阻塞。模板自带 `preview.sh`。

### 2. handoff/ 必须自包含
所有相对路径引用都能解析到 handoff/ 内部文件。可用脚本自动校验。

### 3. 不要把 Design 工具生成的 `final/uploads/` 和 `final/design-brief/` 进 repo
那是 Design 工具内部缓存,典型 20-50 MB 冗余。`.gitignore` 模板已配置。

### 4. 浏览器交互测试必须 resize viewport 到目标尺寸
Preview 默认 viewport ≠ 设计目标(常见 375 / 353),需要 `preview_resize(target_w, target_h)`。

### 5. 静态扫描 ≠ 实际渲染
涉及交互/视觉验证,必须真实渲染 + DOM 实测,不能只 grep 源码。

## 常见踩坑

| 现象 | 实际原因 | 教训 |
|---|---|---|
| 字是黑的看不见 | 不是 dark mode — CSS @import 失败,变量 undefined | DOM inspect 先,直觉解释后 |
| SVG 全空白 | file:// CORS 阻塞 fetch() | 起 HTTP 服务器看 |
| Design 用占位简笔 | 任务卡写得太抽象("网格 N×N 卡片") | 强约束 #1 禁占位,Phase 0 强制每个具体内容独立 SVG |
| Tab/翻页交互无响应 | JS handler 没绑定 | preview_click + DOM 状态 inspect 验证 |

## 工具链

模板自带的脚本:

| 脚本 | 用途 |
|---|---|
| `scripts/dedup.py` | Step 3 pHash 去重 |
| `scripts/build_preview.py` | Step 4 生成筛帧预览 HTML(用户在浏览器勾选) |
| `scripts/make_grid.py` | 缩略图网格(debug 用) |
| `scripts/extract_palette.py` | Step 6 调色板事实提取 |
| `scripts/lib/ids.py`、`grid.py` | 共享 helper |
| `preview.sh` | Step 10 起本地 HTTP 服务器看 Design 产物 |

## 给 Design 的 starter prompt 模板

见 [`KICKOFF_PROMPT.md`](KICKOFF_PROMPT.md)。
