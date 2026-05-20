# audit-pre-design · 设计前对齐检查

> design 新会话/新沙箱开工设计前的必做 audit。两件事 + 出报告 + 停。

## 步骤 1 · 同步 GitHub(沙箱状态 ≠ 真值)

按 PROGRESS.md 顶部「项目快照」表 + `docs/SYNC_PROTOCOL.md` 拉:

- `projects/projectE/PROGRESS.md`(全局状态 · 必拉)
- `projects/projectE/design-brief/flows/`(canonical 6 文档)
- `projects/projectE/preview/大掌柜.html`(HTML 真值全集)
- `projects/projectE/preview/Style Lock · 风格定档.html`(15 色 / 8 字阶 / 9 货币 / 7 角标 / 27 古风对照速查)
- `projects/projectE/final/`(Vite + Vue 3 工程层 · 递归)

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
