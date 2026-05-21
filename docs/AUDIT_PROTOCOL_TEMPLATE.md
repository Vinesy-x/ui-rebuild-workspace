# AUDIT_PROTOCOL.md 模板

> 复制此文件到 `projects/<name>/handoff/AUDIT_PROTOCOL.md`,改 `{{...}}` 占位符。
> `new-project.sh` 会自动做这件事。
>
> 这是设计前 audit 协议(每个 task design 都必拉一份)— 跨项目通用约束,
> task 专有内容在 `handoff/tasks/T-B<N>.md`。

---

# audit-pre-design · 设计前对齐检查

> design 新会话/新沙箱开工设计前的必做 audit。两件事 + 出报告 + 停。

## ⚠️ 沙箱目录结构(2026-05 refactor v2 · handoff/ 强隔离)

- repo 根 = `{{repo}}/`(多游戏 workspace · 同根下还会有 `projects/projectF/` 等)
- **你的边界 = `projects/{{name}}/handoff/`** · 一切产出必须在此目录之内
- 项目内相对路径:`spec/` / `final/` / `preview/` / `tasks/` 以 `handoff/` 为根
- raw URL 仍按 GitHub 完整路径:`https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/projects/{{name}}/handoff/<path>`
- ⚠️ **绝对禁止**写到 repo 根 / `projects/` 根 / `{{name}}/` 根 / `{{name}}/_internal/`
- `{{name}}/_internal/`(bugs / input / frames / analysis)= user/Claude 内部用 · design 不拉不碰

## 步骤 1 · 同步 GitHub(沙箱状态 ≠ 真值 · 每一份都必拉)

raw URL 前缀 = `https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/`

**全局状态(1 份 · 顶部「项目快照」一表知全局)**
- `projects/{{name}}/handoff/PROGRESS.md`

**canonical 真值 6 文档**(`handoff/spec/` · 5 条已废清单 / 9 共享 modal / 屏映射 / 交互规范都在这里 · ⚠️ **不拉这 6 份必出错**)
- `projects/{{name}}/handoff/spec/info-architecture.md`
- `projects/{{name}}/handoff/spec/interaction-spec.md`
- `projects/{{name}}/handoff/spec/screen-details.md`
- `projects/{{name}}/handoff/spec/screen-details-extras.md`
- `projects/{{name}}/handoff/spec/screen-details-extras2.md`
- `projects/{{name}}/handoff/spec/topology.html`

**视觉真值(2 份)**
- `projects/{{name}}/handoff/preview/{{game}}.html`(HTML 全集)
- `projects/{{name}}/handoff/preview/Style Lock · 风格定档.html`(风格速查)

**Vue 工程层**(`projects/{{name}}/handoff/final/src/` 整个递归拉)
- 顶层:`main.ts` / `App.vue` / `router.ts`
- `styles/`:`tokens.css` / `components.css`
- `components/`:多个共享 modal(含 HudBar / BottomTabBar / ModalShell)
- `views/`:每屏 1 个 view
- `stores/useModalStore.ts`
- `types/modalPayloads.ts`
- `utils/mergeHud.ts`
- `data/`:每屏 1 份 json

**Pre-flight checklist · 拉完逐项打勾再开干**:
- [ ] PROGRESS.md ✓
- [ ] 6 份 canonical 真值(`handoff/spec/`) ✓
- [ ] 2 份 HTML(`handoff/preview/`) ✓
- [ ] `handoff/final/src/` 递归全套 ✓

沙箱与 GitHub 不一致的全部覆盖 → 以 GitHub 为准。

## 任务 A · HTML 真值 ↔ Vue 工程层 alignment audit

对照 `handoff/preview/{{game}}.html` vs `handoff/final/src/`,逐屏 + 逐 modal 检视觉 + 交互一致性。

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
- N 共享 modal + 4 全局 modal 全数 alive(无 dead click)

## 任务 B · preview/ 清理

`handoff/preview/Style Lock · 风格定档.html`(风格速查)vs canonical 全集 `handoff/preview/{{game}}.html`:

- 风格化对照表 / 色 swatch / 字阶 scale / motion 体系 → 是否仍是不可替代的速查参考?
- 任何内容被 `{{game}}.html` 100% 涵盖的段落 → 标注可移除

输出建议:`keep` / `archive 到 preview/archive/` / `delete` · 一行理由。

## 完成

报告整理成一条消息发回用户。**不写代码 · 不开设计 · 等用户基于报告下下一步指令**。
