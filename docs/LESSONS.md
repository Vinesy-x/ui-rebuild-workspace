# LESSONS · 跨项目经验沉淀

> 这份文档累积所有项目的踩坑教训,新项目开工前看一遍,不重蹈覆辙。
> 每个项目结束后(或重大事故后)往这里追加。

---

## 三方协作流程

### L1:design 沙箱 ≠ GitHub 真值
**事故**:projectE T-B1 import 后,本地清过的 4 处 NPC click 全回滚(commit 3a81c3b → 68d7850)。
**根因**:design 沙箱里旧版被 design 复制到新产出 + rsync --delete 单向覆盖本地手改。
**修法**:每个 task prompt 顶部 inline 强制"主动拉 GitHub 最新版"指令 + 已废清单(SYNC_PROTOCOL 提案后无再发生)。

### L2:prompt 里复制粘贴 canonical 会漂移
**事故**:第 1 版 T-B1 prompt 198 行,把 13 技能 / 3 档解锁价 / 古风对照表全抄进 prompt。
**根因**:双源(prompt + canonical 文档)同步成本高,容易不一致。
**修法**:prompt 只引用 `design-brief/flows/*` 路径,不复制内容(瘦身后 ~70 行)。

### L3:design 沙箱可拉 GitHub 文件,但不会自动拉
**事故**:早期以为"放到 design-brief/ 下 design 就能读到",实际上不主动拉就用沙箱旧版。
**修法**:每个 task prompt 顶部显式列 raw URL 必拉清单。

### L4:HTML 真值默认在沙箱根
**事故**:design 把 3 个 HTML 真值产出在沙箱根(项目根),本地仓库根也跟着乱。
**修法**:KICKOFF 顶部立规约"HTML 真值放 preview/ 子目录,link 用 `../final/...`"。下次开新项目时**清白沙箱 + 第一个指令就立规**。

### L5:Phase A 走 design / Phase B 可让 Claude 直接做
**观察**:Phase A 是风格定档(视觉判断,design 强项)→ 走 design。Phase B 是代码填充(工程化)→ Claude 直接做更快不漂移。
**规约**:Phase B 各屏由用户决定走 design 还是 Claude 直接做。design 没用量时 Claude 顶上(已实测可行,T-B2 完全 Claude 做)。

---

## canonical 维护

### L6:8 agent 并发分析的推测要核实
**事故**:8 agent 初轮认定 fps_0037 = "NPC tap → 焊工要求 modal",实际是工作详情 modal(跟 0040 同类)。从未真正核实底板,看到 6 项要求就推测。
**修法**:agent 报告里的"推测"必须用 PNG 核实(看底板元素 / 邻近帧)再写进 canonical。重大归属变化要标 ⭐ 校正 + 记录到 PROGRESS.md。

### L7:130 帧视频里"不存在的 modal"也要明示
**观察**:月度结算 modal / 字符 3rd sub-tab / 行为子 modal 等 — 不是没抽到,是**机制不存在**(passive HUD-only 月度推进 / sub-tab 数固定 2 / 行为是 inline cd)。
**修法**:这些标 ⚠️ "不存在(机制问题)",不再期待补抽,canonical 顶部记录。

### L8:canonical 文档分层
| 层 | 文档 | 维护频率 |
|---|---|---|
| 屏映射 + 时序 | info-architecture.md | 高(每屏更新)|
| 行为契约 | interaction-spec.md | 中 |
| 视觉拓扑 | topology.html | 中(mermaid)|
| 逐屏深度 | screen-details.md | 一次性 |
| 备用帧增量 | screen-details-extras*.md | 一次性 |
| 同步规约 | SYNC_PROTOCOL.md | 低 |

---

## 工程实践

### L9:Modal 走 Pinia store 不嵌 router
**经验**:从 projectB 沉淀的最佳实践 — 9 共享 modal 全部走 `useModalStore.open(name, props) / close()`,ModalShell 挂根 layout,router.afterEach 切屏自动 reset。比 router 嵌套 modal 路由简单得多。

### L10:跨屏复用 modal 设计模式 — 同入口 / 不同 props
**经验**:Phase A 风格定档时识别"哪些 modal 跨屏复用",归为共享组件(`final/src/components/*.vue`),Phase B 各屏只挂入口、不重写。

识别套路:
- 同布局 + 不同数据(如礼物 / 约会都是"标题 + 选项列表 + 接受 CTA"→ 共享一个 OptionPickerModal)
- 同步序 + 不同状态(如卖车 启动→loading→出价 共享 AsyncWaitModal)
- 同动画 + 不同标签(如各种"升级粉心" 共享 UpgradeOverlay)

每个项目独立维护自己的"共享 modal 清单"(在该项目 `PROGRESS.md`),Phase A 锁定后不允许各屏单独写 modal(除非 useModalStore 已有 name 占位)。

projectE 实际的 9 共享 modal 清单见 `projects/projectE/PROGRESS.md` "共享 modal 组件清单" 段。

### L11:中文 UI 字号 ≥ 18px(v3.1)
**经验**:v1/v2 用 10-30px 字号梯度,中文 14px 太小手机看不清。v3.1 升级到 8 档 14-40px,最小正文 18px。

### L12:印章 + 汉字 = 货币 icon 标准(古风换皮)
**经验**:禁 emoji / unicode 货币图标,用"朱砂方印 + 楷书汉字"方块表达。Phase A 用 CSS,Phase B 替换为 SVG 切片(retina 清晰)。

---

## 工具 / 脚本

### L13:`import-design.sh` 同步策略
- `rsync --delete` 单向覆盖(本地手改危险,优先走 bug 报告)
- HTML 真值双拉(并存):优先沙箱 `preview/`(KICKOFF 新约定)+ 兼容沙箱根 `*.html`(老沙箱习惯)+ sed idempotent 修 `href="final/"` → `href="../final/"`
- 项目定位:`projects/<name>/` 自动单项目识别,多项目时需指定 arg2

### L14:`new-project.sh` 脚手架
新项目开工 = 一行命令:
```bash
./scripts/new-project.sh <project-name>
```
自动:mkdir 全部子目录 + cp 模板 + 初始化 PROGRESS.md + 输出后续步骤。

### L15:vite build 是工程层 verify 的关键
每次 import / 改 Vue 文件后跑 `npm install && vite build`,看 css/js 输出大小印证视觉填实(< 1kB = placeholder,> 5kB = 真填实)。

---

## 通用项目模板

### L16:workspace 多项目结构
单 GitHub repo 管多项目:
```
ui-rebuild-workspace/
├── docs/  scripts/         # 通用(跨项目)
└── projects/
    ├── projectE/           # 项目 1
    ├── projectF/           # 项目 2(同游戏不同风格 / 不同游戏)
    └── ...
```
**design 沙箱视角**:每项目独立沙箱,沙箱根 = `projects/<name>/`。raw URL 加 `projects/<name>/` 前缀。

### L17:经验复利
每完成 1 个项目,把踩坑 / 教训追加到本文件。**新项目开工前先读 LESSONS.md**,避免重复造轮子。

---

## 待补(后续项目沉淀)

- 多游戏多风格并行任务的 prompt 模板差异
- 跨项目共享 design 风格库(用户多个项目复用同 Style Lock?)
- 工程模板版本化(Vite 6 / Vue 3.5 等)
