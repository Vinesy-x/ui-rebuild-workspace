# audit-pre-design · 设计前对齐检查

> design 新会话/新沙箱开工设计前的必做 audit。两件事 + 出报告 + 停。

## ⚠️ 沙箱目录结构(2026-05 refactor v2 · handoff/ 强隔离)

- repo 根 = `ui-rebuild-workspace/`(多游戏 workspace · 同根下还会有 `projects/projectF/` 等)
- **你的边界 = `projects/projectE/handoff/`** · 一切产出必须在此目录之内
- 项目内相对路径:`spec/` / `final/` / `preview/` / `tasks/` 以 `handoff/` 为根
- raw URL 仍按 GitHub 完整路径:`https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/projects/projectE/handoff/<path>`
- ⚠️ **绝对禁止**写到 repo 根 / `projects/` 根 / `projectE/` 根 / `projectE/_internal/`
- `projectE/_internal/`(bugs / input / frames / analysis)= user/Claude 内部用 · design 不拉不碰

## 步骤 1 · 同步 GitHub(沙箱状态 ≠ 真值)

**拉 `projects/projectE/handoff/` 整个目录递归** — 这是你的完整工作集。

策略:GitHub tree API 列 + raw URL 逐份 fetch:
```
1. https://api.github.com/repos/Vinesy-x/ui-rebuild-workspace/git/trees/main?recursive=1
2. 过滤 path 以 "projects/projectE/handoff/" 开头的 blob entries
3. 每份 raw = https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/<path>
```

工作集 ~50 文件 · ~800KB · ~195K tokens · 含:
- 根 3 份:`PROGRESS.md` / `AUDIT_PROTOCOL.md` / `KICKOFF.md`
- `spec/` 6 canonical(屏映射 / 交互 / 拓扑 · ⚠️ 不拉必错)
- `tasks/T-B<N>.md`(本任务)+ `archive/`(历史)
- `preview/`:大掌柜.html(全集)+ Style Lock(风格速查)
- `final/src/`:13 共享 modal + 7 filled view + tokens.css + components.css + …

沙箱与 GitHub 不一致的全部覆盖 → 以 GitHub 为准。

⚠️ 不要拉 `projects/projectE/_internal/`(user/Claude 内部 · design 不碰)

## 任务 A · HTML 真值 ↔ Vue 工程层 alignment audit

对照 `handoff/preview/大掌柜.html` vs `handoff/final/src/`,逐屏 + 逐 modal 检视觉 + 交互一致性。

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

`handoff/preview/Style Lock · 风格定档.html`(1116 行,55KB)vs canonical 全集 `handoff/preview/大掌柜.html`:

- 27 古风对照表 / 15 色 swatch / 8 字阶 scale / motion 体系 → 是否仍是不可替代的速查参考?
- 任何内容被 `大掌柜.html` 100% 涵盖的段落 → 标注可移除

输出建议:`keep` / `archive 到 preview/archive/` / `delete` · 一行理由。

## 完成

报告整理成一条消息发回用户。**不写代码 · 不开设计 · 等用户基于报告下下一步指令**。
