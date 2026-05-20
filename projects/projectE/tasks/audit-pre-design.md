# audit-pre-design · 设计前对齐检查

> design 新会话/新沙箱开工设计前的必做 audit。两件事 + 出报告 + 停。

## ⚠️ 沙箱目录结构(多项目 workspace)

- repo 根 = `ui-rebuild-workspace/`(多游戏并行 · 同根下还会有 `projects/projectF/` 等)
- **你的项目根 = `projects/projectE/`** · 沙箱里看到的 `projects/projectE/` 这一层就是你的工作目录
- 任何「项目内相对路径」(如 `design-brief/flows/...`、`final/src/...`、`preview/...`)以 `projects/projectE/` 为根
- raw URL 仍按 GitHub 完整路径拉:`https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/projects/projectE/<path>`
- 不要在 repo 根、不要在 `projects/` 根创建文件 · 一切产出必须在 `projects/projectE/` 之内

## 步骤 1 · 同步 GitHub(沙箱状态 ≠ 真值 · 每一份都必拉)

raw URL 前缀 = `https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/`

**全局状态(1 份 · 顶部「项目快照」一表知全局)**
- `projects/projectE/PROGRESS.md`

**canonical 真值 6 文档**(design-brief/flows/ · 5 条已废清单 / 9 共享 modal / 屏映射 / 交互规范都在这里 · ⚠️ **不拉这 6 份必出错**)
- `projects/projectE/design-brief/flows/info-architecture.md`
- `projects/projectE/design-brief/flows/interaction-spec.md`
- `projects/projectE/design-brief/flows/screen-details.md`
- `projects/projectE/design-brief/flows/screen-details-extras.md`
- `projects/projectE/design-brief/flows/screen-details-extras2.md`
- `projects/projectE/design-brief/flows/topology.html`

**视觉真值(2 份)**
- `projects/projectE/preview/大掌柜.html`(HTML 全集 · 4847 行)
- `projects/projectE/preview/Style Lock · 风格定档.html`(风格速查 · 1116 行)

**Vue 工程层**(`projects/projectE/final/src/` 整个递归拉)
- 顶层:`main.ts` / `App.vue` / `router.ts`
- `styles/`:`tokens.css` / `components.css`
- `components/`:13 个(HudBar / BottomTabBar / ModalShell + 11 modal)
- `views/`:8 个(MainMenu / SkillList / MeetList / RelationDetail / WorkDAG / BusinessList / InvestBank 占位 / ShopItems 占位)
- `stores/useModalStore.ts`
- `data/`:mainMenu.json / skillList.json / relations.json / workList.json / businessList.json

**Pre-flight checklist · 拉完逐项打勾再开干**:
- [ ] PROGRESS.md ✓
- [ ] 6 份 canonical 真值(design-brief/flows/) ✓
- [ ] 2 份 HTML(大掌柜.html + Style Lock) ✓
- [ ] final/src/ 递归全套 ✓

沙箱与 GitHub 不一致的全部覆盖 → 以 GitHub 为准。

## 任务 A · HTML 真值 ↔ Vue 工程层 alignment audit

对照 `preview/大掌柜.html` vs `final/src/`,逐屏 + 逐 modal 检视觉 + 交互一致性。

**输出格式**(精炼清单 · ≤ 800 字 · 绝对路径 + 行号 + 一句修法):

```
## A. 🔴 严重 — 视觉错位
| # | Vue 文件:行 | HTML 真值 行号 | 问题 | 修法 |

## B. 🟡 中度 — 字号/颜色违反 Style Lock
| # | 文件:行 | 错值 → 应改 |

## C. 🟢 轻度 — 注释 / 死代码 / 命名
```

强约束(不要漏检):
- 字号必走 `var(--fs-*)` 8 阶 · 颜色必走 15 色 var
- ModalShell map 注册 ↔ useModalStore ModalName ↔ 各 view click 事件三方对齐
- 11 共享 modal + 4 全局 modal 全数 alive(无 dead click)

## 任务 B · preview/ 清理

`preview/Style Lock · 风格定档.html`(1116 行,55KB)vs canonical 全集 `preview/大掌柜.html`:

- 27 古风对照表 / 15 色 swatch / 8 字阶 scale / motion 体系 → 是否仍是不可替代的速查参考?
- 任何内容被 `大掌柜.html` 100% 涵盖的段落 → 标注可移除

输出建议:`keep` / `archive 到 preview/archive/` / `delete` · 一行理由。

## 完成

报告整理成一条消息发回用户。**不写代码 · 不开设计 · 等用户基于报告下下一步指令**(可能是修 alignment / 清 preview / 启动 T-B5 投资 fps_0058-0062 设计)。
