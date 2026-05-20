# COLLABORATION_PROTOCOL · projectE 三方协作规约

> 沉淀 Phase A + T-B1 走通后的协作经验,后续 Phase B 各屏复用此规约。
>
> 三方:**用户**(决策 + 中转 prompt) · **Claude**(canonical 维护 + 工程层 + import 验) · **design**(沙箱视觉/Vue 产出)

---

## 1 · 三方角色 + 能力边界

### 用户
- 决策(选风格 / 验视觉 / 选 Phase B 节奏)
- **中转 prompt 文本**:Claude 起草 → 用户复制粘贴整段给 design(沙箱接受指令的唯一可靠入口)
- 给 design 短指令触发任务(配合 raw URL 让 design 拉 prompt)
- 审视 design 出 link 后的产出
- 决定走 design 沙箱 vs 让 Claude 直接做

### Claude(我)
- 维护 canonical(`design-brief/flows/*.md` + `.html`)— GitHub 唯一真值
- 写 task prompt(`TASK_PROMPT_T_B*.md`,瘦身 + 自包含)
- `./scripts/import-design.sh <link>` 拉沙箱产出本地
- import 后跑 grep checklist 防漂移
- 跑 `vite build` 验工程
- 起 bug 报告(`BUG_REPORT_*.md`)给用户中转给 design
- Phase B 工程填充工作**可以选择不走 design**,直接编辑 `final/src/*`
- 提交 GitHub(用户授权后)

### design(沙箱独立 AI 实例)
- 在沙箱里改 `design-brief/` + `final/` + 项目根 HTML 真值
- 出 link(tarball)
- 不会自动同步 GitHub,**必须 prompt 明确指令主动拉**
- 风格视觉判断(色板 / 字号 / 印章 / 古风 icon)极强
- 工程层填充也能做,但来回 ceremony 慢

---

## 2 · 沙箱 ↔ GitHub 同步模型

```
   ┌──────────────────┐                  ┌──────────────────┐
   │  design 沙箱     │                  │  GitHub repo     │
   │  (独立状态)      │                  │  main HEAD       │
   │                  │                  │  = 唯一真值       │
   └──────────────────┘                  └──────────────────┘
           │                                       ▲   ▲
           │ design 出 link                       │   │
           │ (tarball snapshot)                   │   │ Claude 维护 canonical
           ▼                                       │   │ 推 GitHub
   ┌──────────────────┐                          │   │
   │  本地仓库         │ ─ git push ──────────────┘   │
   │  /Users/.../projectE │                              │
   │                      │                              │
   │  import-design.sh    │ ◄─ rsync --delete ─ design 沙箱
   │  (单向覆盖)          │                              │
   └──────────────────┘                                 │
           │                                              │
           │ Claude/用户 grep checklist + vite build      │
           │ Claude/用户 本地 commit                       │
           └──── git push ────────────────────────────────┘
```

### 关键事实
1. **沙箱状态 ≠ GitHub 真值**(独立两套状态)
2. **design 能主动拉 GitHub 任何文件**(raw URL `https://raw.githubusercontent.com/Vinesy-x/projectE/main/<path>`)
3. **但不会自动拉**,必须 prompt 明确指令拉哪些文件
4. **import-design.sh 用 rsync --delete 单向覆盖**:design 沙箱 → 本地,本地手改会被回滚
5. **修复模式**:每次新 task prompt 顶部 inline 必拉清单 + 已废弃项,让 design 在写新产出前先拉最新覆盖沙箱

---

## 3 · task prompt 模板(瘦身 + 自包含)

每个 `TASK_PROMPT_T_B*.md` 严格按这个结构,不复制 canonical 内容,只引用:

```
projectE · 大掌柜 — Phase B T-Bx
fps_XXXX 短描述

⚠️⚠️⚠️ 开工前同步(必做)— 避免 canonical 漂移 ⚠️⚠️⚠️

你的沙箱状态 ≠ GitHub 真值。你能主动从 GitHub 拉任何文件,但不会自动
拉。请你主动从 GitHub 拉下列文件最新版,覆盖你沙箱里对应文件:
  repo = https://github.com/Vinesy-x/projectE  branch = main
  raw URL = https://raw.githubusercontent.com/Vinesy-x/projectE/main/<path>

必拉清单(3 组):
  canonical 演进(6 个 flows + 同步规约,在 design-brief/):
  - design-brief/SYNC_PROTOCOL.md
  - design-brief/flows/info-architecture.md
  - design-brief/flows/interaction-spec.md
  - design-brief/flows/screen-details.md
  - design-brief/flows/screen-details-extras.md
  - design-brief/flows/screen-details-extras2.md
  - design-brief/flows/topology.html

  HTML 真值(在仓库根,不是 final/ 下):
  - Phase A · 主菜单 大掌柜.html
  - Style Lock · 风格定档.html
  - 大掌柜.html

  Vue 工程层:
  - final/src/(整个目录递归)
  - final/README.md

5 条已知废弃项(canonical v2 后,不要重新引入):
1. 关系详情 5 按钮(约/送礼物/互聊/加速看广告/變為主要),不是 4 按钮
   (旧 4 按钮 打个招呼/雇佣 已废)
2. fps_0037 = 工作详情 modal "焊工"(同 0040 同类,跟 JobDetailModal
   共用),不是 NPC tap 触发的 npc-req modal
3. 衣服 5 个 2nd sub-tab = 帽子/上衣/包/戒指/口红,不是裤子/鞋
4. 字符窗口 sub-tab = 2(交易/升级),没有第 3 个 🔒
5. 月度结算 modal 不存在(passive HUD-only 月度推进)


【任务范围】
N 帧 + inline state(列帧号 + 短描述)

【产出 N 件】
1. final/src/views/XxxView.vue   填实/新增
2. final/src/components/XxxModal.vue   新增(挂到 ModalShell map)
3. final/src/data/xxx.json   新增
4. router.ts 加路由 / BottomTabBar 跳转验证

【先读这些(canonical = 唯一真值,看,不复制)】
- PNG 真值:design-brief/analysis/projectE_fps_XXXX.png
- canonical 文档:design-brief/flows/*(具体段落定位)
- 视觉参考:仓库根 HTML 真值 + final/src 既有结构

【强约束(继承 Phase A,不重写)】
1. tokens.css 唯一源
2. 9+ 共享 modal 走 useModalStore
3. 印章+汉字 = 货币 icon 标准
4. modal scrim 锁定
5. 中文正文 ≥18px
6. canonical 跟 PNG 冲突时 PNG 优先,然后更新 canonical
7. 已废弃项不要重新引入

【完成后告诉用户】
- 关键命名 / 视觉 / 实现策略问题清单

完成停下等用户验收。
```

### 触发 prompt 的两种方式
**方式 A** — 用户复制粘贴整段:稳但慢(prompt 长),已用于 T-B1 / T-B2
**方式 B** — 用户发短指令 + raw URL,design 自己拉 prompt:
```
继续做 T-Bx。任务详情拉:
https://raw.githubusercontent.com/Vinesy-x/projectE/main/TASK_PROMPT_T_Bx.md
完成出 link。
```

---

## 4 · canonical 文档分层(谁维护 / 给谁看)

| 文档 | 位置 | 维护者 | 给谁看 |
|---|---|---|---|
| **canonical 屏映射** | `design-brief/flows/*.md` + `topology.html` | Claude | design 必读 |
| **HTML 视觉真值** | 仓库根 3 个 `.html` | design 写,Claude 清漂移 | design 沿用 + 用户看 |
| **Vue 工程** | `final/src/*` | design 写,Claude verify | npm run dev 可跑 |
| **PNG 抽帧** | `design-brief/analysis/*.png` + `analysis-extras/*` | 用户 + Claude(ffmpeg+phash) | design 必读 |
| **style 风格** | `final/Style Lock · 风格定档.html` + `tokens.css` | design,Phase A 锁定 | Phase B 沿用 |
| **同步规约** | `SYNC_PROTOCOL.md`(根+design-brief/)| Claude | design 必读(指令拉)|
| **三方协作规约** | `COLLABORATION_PROTOCOL.md`(本文件,仓库根)| Claude | 用户 + Claude(给我自己看)|
| **task prompt** | `TASK_PROMPT_T_B*.md`(仓库根)| Claude | design 拉 / 用户中转 |
| **bug 报告** | `BUG_REPORT_*.md`(仓库根)| Claude | 用户中转给 design |
| **KICKOFF** | `KICKOFF_PROMPT.md`(仓库根)| Claude | Phase A 启动用,Phase B 可参考 |
| **方法论** | `METHODOLOGY.md`(仓库根)| Claude | 整体流程 |

---

## 5 · import 后防漂移 checklist(Claude 我执行)

每次 `./scripts/import-design.sh <link>` 完后,**这 4 步必做**:

```bash
# 1. 看 design 改了什么
git status -s
git diff --stat

# 2. grep 已废弃项(应该全 0,只允许"作废注释")
grep -nE "openModal\('npc-req'\)|data-act=\"open:npc-req\"" "Phase A · 主菜单 大掌柜.html" "大掌柜.html"  # → 0
grep -nE "打个招呼|关系详情.{0,15}雇佣 button" final/src/ design-brief/flows/ -r  # → 0
grep -nE "5 个 icon:帽子 / 上衣 / 裤子 / 鞋 / 配饰" final/src/ design-brief/flows/ -r  # → 0
grep -nE "推测有第 3 个 🔒|字符窗口第 3 sub-tab.{0,15}推测" design-brief/flows/ -r  # → 0
grep -nE "月度结算.{0,15}需重抽|月度结算.{0,15}从未抽到" design-brief/flows/ -r  # → 0

# 3. vite build 验工程能跑
cd final && npx vite build && cd ..

# 4. 看新增 view / component / json,对照 canonical 验证数据
```

如果 grep 出非 0 → 立刻本地清漂移 → commit 标 "fix(漂移): 沙箱旧版回滚" → 下次 task prompt 顶部加强"已废弃"提醒。

---

## 6 · 沟通节奏(每屏 1 task)

```
1. Claude 起草 TASK_PROMPT_T_Bx.md(瘦身 + 自包含)
2. Claude commit + push GitHub
3. 用户发短指令 + raw URL 给 design,触发任务
4. design 主动拉 GitHub canonical + 必拉清单
5. design 在沙箱里做产出(Vue + 数据 + 顺手 HTML 真值)
6. design 出 link
7. 用户给 Claude link
8. Claude 跑 ./scripts/import-design.sh <link>
9. Claude 跑 import 后防漂移 checklist
10. Claude commit 验收
11. 有漂移 / bug → Claude 起 BUG_REPORT_*.md → 用户中转给 design
12. 全部通过 → 进下一屏 T-B(x+1)
```

---

## 7 · 何时不走 design 沙箱(Claude 直接做)

| 类型 | 走 design? | 理由 |
|---|---|---|
| 风格定档(色板 / 字体 / 印章 / 古风元素) | ✅ 走 | design 视觉判断强,沙箱视觉调试好 |
| Phase B 工程填充(Vue view / data / 复用 modal) | 可选(用户决定)| 代码工作,Claude 直接做更快不漂移 |
| canonical 维护(`flows/*.md`)| ❌ Claude 直接做 | canonical 是 Claude 的职责 |
| 仓库根 docs(prompt / bug / sync / collab / kickoff)| ❌ Claude 直接做 | 给用户 + Claude 用 |
| scripts/ 工程工具 | ❌ Claude 直接做 | 跟 design 无关 |
| 修 design 沙箱产出的小漂移(NPC click 等)| ⚠️ 优先 bug 报告让 design 改 | 本地手改会被 rsync 覆盖 |

---

## 8 · 已知反模式(吸取教训)

| 反模式 | 后果 | 修法 |
|---|---|---|
| prompt 里复制粘贴 canonical 内容 | 双源 → 漂移风险 | prompt 只 ref 路径,不复制内容 |
| prompt 写"读 SYNC_PROTOCOL.md" | design 不会自动拉,等于没说 | 显式列 raw URL + "主动拉到沙箱" |
| 本地手改 design 沙箱产出 | 下次 import 会被覆盖回滚 | 优先走 bug 报告 → design 沙箱改 |
| canonical 文档没标 ⚠️ 校正 | design 复制旧代码到新产出 | canonical 顶部明示废弃项 + 历史 |
| 走 design 做 Phase B 纯代码工作 | 4 回合 ceremony 慢 | Phase B 可让 Claude 直接做 |
| 多个 task 并发改同一 view | 合并冲突 | Phase B 严格串行,每屏 1 task |
| 不在 commit message 记录漂移源 | 事故难追踪 | commit 写"漂移源 = 沙箱旧版回滚" |

---

## 9 · 历史事件 log(便于追踪)

| 日期 | commit | 事件 |
|---|---|---|
| 2026-05-19 | 初始化 | projectE 仓库建 + 50 张抽帧 + flows 三件套 |
| 2026-05-20 | `3a81c3b` | 清 Phase A.html 4 处 NPC click(canonical v2 fps_0037 校正)|
| 2026-05-20 | `68d7850` | T-B1 import,设 NPC click 4 处全回滚(design 沙箱没改)|
| 2026-05-20 | `592b62c` | 再清 8 处(Phase A.html 4 + 大掌柜.html 4)|
| 2026-05-20 | `f1a7ea3` | 立 SYNC_PROTOCOL(沙箱 ≠ GitHub)|
| 2026-05-20 | `b6c18ec` | 修认知:design 沙箱不限 design-brief/,能拉仓库根 |
| 2026-05-20 | `552bdfb` | 改"主动拉取" 模型 + raw URL 模板 |
| 2026-05-20 | `23823fc` | 修 2 处文档错(HTML 真值在根 / flows 6 个不是 7)|
| 2026-05-20 | 本 commit | 沉淀 COLLABORATION_PROTOCOL(整体规约)|

---

## 10 · TL;DR(给我和未来 task 用的速查)

1. **每个 task 起草 prompt** → 套 §3 模板 → 不复制 canonical,只 ref 路径
2. **prompt 顶部必 inline** → 同步指令 + 必拉清单 + 5 条已废弃项
3. **触发 design** → 用户发短指令 + raw URL,design 拉 prompt → 出 link
4. **import 后** → 跑 §5 grep checklist + vite build → 有漂移立刻清
5. **canonical 维护** → Claude 直接改 push,不走 design
6. **下次 prompt** → 5 条已废弃项可能要更新(随 canonical 演进)
7. **Phase B 工程填充** → 可让 Claude 直接做(节省 4 回合)
