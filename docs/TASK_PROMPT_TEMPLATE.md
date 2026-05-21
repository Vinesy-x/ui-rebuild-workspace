# task prompt 模板 · Phase B 每屏

> 复制此文件到 `projects/<name>/handoff/tasks/T-B{{n}}.md`,改 `{{...}}` 占位符。
> 跟 KICKOFF 不同 — 这是 Phase B 各屏推进的标准 task。
>
> ⚠️ **v2 强约束**(2026-05 后):两阶段交付 + 文件白名单 + `_design-notes.md` 强 deliverable。
> 上一轮 T-B5 经验沉淀(scope creep / 漏 audit / 无变更说明)→ 模板全量收紧。

---

```
{{游戏名}} · Phase B T-B{{n}}
fps_{{帧号}} {{短描述}}

> **两阶段交付** · audit 先,实现后 · 严格白名单 + `_design-notes.md` deliverable

## ⚠️ 沙箱目录结构(2026-05 refactor v2 · handoff/ 强隔离)

- repo 根 = `{{repo-name}}/`(多游戏 workspace · 同根还有 `projects/projectX/` 等)
- **你的边界 = `projects/{{name}}/handoff/`** · 所有相对路径以 handoff/ 为根 · 产出必须在此之内
- ⚠️ 禁止写到 repo 根 / `projects/` 根 / `{{name}}/` 根 / `{{name}}/_internal/`(后者是 user/Claude 内部)

## 步骤 1 · 同步 GitHub(沙箱状态 ≠ 真值)

**拉 `projects/{{name}}/handoff/` 整个目录递归** — 这是你的完整工作集。

策略:
```
1. https://api.github.com/repos/{{owner}}/{{repo}}/git/trees/main?recursive=1
2. 过滤 path 以 "projects/{{name}}/handoff/" 开头的 blob entries
3. 每份 raw = https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/<path>
```

工作集含:
- 根 3 份:`PROGRESS.md` / `AUDIT_PROTOCOL.md` / `KICKOFF.md`
- `spec/`:N canonical(⚠️ 不拉必错)
- `tasks/T-B{{n}}.md` 本任务 + `archive/` 历史
- `preview/`:HTML 真值
- `final/src/`:Vue 工程层

沙箱与 GitHub 不一致的全部覆盖 → 以 GitHub 为准。
⚠️ 不要拉 `_internal/`(design 不碰)


====================================================================
【阶段 1 · audit-pre-design 报告(必先 · 不出代码/HTML)】
====================================================================

照 `projects/{{name}}/handoff/AUDIT_PROTOCOL.md` 跑两件 audit:

**A. HTML 真值 ↔ Vue 工程层 alignment**
- 视觉:字号走 `var(--fs-*)` 8 阶 / 颜色走 N 色 var(项目自定)
- 交互:`useModalStore.ts ModalName` ↔ `ModalShell.vue map` ↔ 各 view click 三方对齐
- 工程层完整度(只有 {{本任务对应的 view}} 占位是预期的)

**B. preview/ HTML 是否仍有不可替代价值**

输出格式(精炼清单 · ≤ 800 字 · 绝对路径 + 行号 + 一句修法):
```
## A. 🔴 严重 — 视觉错位
| # | Vue 文件:行 | HTML 真值 行号 | 问题 | 修法 |

## B. 🟡 中度 — 字号/颜色违反 Style Lock
| # | 文件:行 | 错值 → 应改 |

## C. 🟢 轻度 — 注释 / 死代码 / 命名
```

**完成阶段 1 → 出报告 → 停 → 等用户验收 → 用户口头放行后才进入阶段 2**

⚠️ 不要把阶段 1 跟阶段 2 一次性交付,会被退回。


====================================================================
【阶段 2 · T-B{{n}} {{屏名}} 实现(用户放行后才开始)】
====================================================================

## 任务范围

{{N}} sub-tab / 帧 + inline state:
- fps_{{帧号}} = {{描述}}
- ...

涉及帧:fps_{{...}}({{N}} 帧)。

## ⚠️ 文件白名单(本次只能新增/修改这些 · 其余 read-only)

**新增**:
- `final/src/views/{{XxxView}}.vue`(填实)
- `final/src/data/{{xxx}}.json`(数据层)
- `final/src/components/{{XxxModal}}.vue`(如需新 modal · 优先复用既有)

**修改**(只允许触这 2 个 · 加注册条目)
- `final/src/stores/useModalStore.ts` ← 加 ModalName(如有新 modal)
- `final/src/components/ModalShell.vue` ← map 注册(同上)

**视觉真值**(可选 · 顺手)
- `projects/{{name}}/handoff/preview/{{游戏名}}.html` ← 补本 task 屏段

**绝对禁止**触:
- 其他 view 文件(不是本 task 范围内的)
- 其他既有 modal 内部逻辑(只能加注册,不改结构)
- `styles/tokens.css` / `styles/components.css`(canonical 已锁定)
- `router.ts`(路由已存在)
- 其他 view 对应的 data json
- `utils/` / `types/` 既有文件(只能新增,不改既有)

> 任何"顺手对齐"既有文件 = scope creep = 退回(T-B5 已踩坑)。
> 如果发现既有文件确实有 bug 必须修,**单独列在 `_design-notes.md` 待用户审批**,不直接改。

## 强约束(继承,不重写)

1. tokens.css = 唯一颜色 / 字号源 · 字号走 `var(--fs-*)` 8 阶
2. 共享 modal 走 `useModalStore` + `ModalShell` map · 不重复 implement
3. 印章 + 汉字 = 货币 icon 标准 · 复用全局 `.ic-seal.ic-*` class
4. modal scrim 锁定 rgba(0,0,0,.65) + backdrop-filter blur(8px)
5. 中文正文 ≥18px(项目自定阈值)
6. canonical 跟 PNG 冲突时 PNG 优先,然后更新 canonical
7. 已废弃项(PROGRESS.md 清单)不要重新引入

## 古风化 / 风格化(预期范围 · 由 design 最终拍板)

参考:{{现代名 → 风格化名}} / ... · 完整对照在 `_design-notes.md` 列。


====================================================================
【deliverable · `_design-notes.md`(沙箱根放一份)】
====================================================================

完成后必须给 · 模板:
```
# T-B{{n}} _design-notes

## audit 阶段发现(回顾)
| # | 项 | 已修 | 跳过 + 理由 |

## 本次产出清单(文件级)
| 文件 | 新增/修改/删除 | 一句话变更说明 |

## 风格化对照表(本 task 新增)
| 现代 | 风格化 |

## 共享 modal 复用清单
| modal | 用法 | 触发位置 |

## 跳过未做的项(必须显式列)
| 项 | 原因 |

## 风险 / 待用户确认
| # | 项 | 建议 |
```


====================================================================
【完成】

- 阶段 1 audit 报告 → 停 → 等放行
- 阶段 2 完成 → 出 design link · `_design-notes.md` 必须在沙箱根
- 用户 import 后跑 vite build · 通过才算完工
- 跑通后更新 PROGRESS.md 标记 T-B{{n}} ✅

不要写代码 · 不要主动开下一屏 · 阶段 1 完成 → 停。
```

---

## 用法

### 方式 A — 整段复制粘贴(稳)
打开本文件,复制 ``` 块整段(替换 `{{...}}` 占位符),发给 design 沙箱。

### 方式 B — 短指令 + raw URL(轻量,推荐)
1. 复制本模板到 `projects/<name>/handoff/tasks/T-B{{n}}.md`
2. 填 `{{...}}` 占位符
3. commit + push
4. 给 design 发短指令:
   ```
   {{游戏名}} T-B{{n}} {{屏名}} 设计。拉:
   https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/projects/{{name}}/handoff/tasks/T-B{{n}}.md

   按里面 步骤 1 pull list 拉完 PROGRESS.md + AUDIT_PROTOCOL.md +
   canonical N 份 + preview HTML + final/src/
   两阶段交付:阶段 1 = audit 报告 → 停 → 等放行
   阶段 2 = 实现 · 严格白名单 · 必带 _design-notes.md
   ```

## 设计模式说明

| 维度 | 旧模式(已废) | v2 强约束(当前) |
|---|---|---|
| 交付方式 | 一次给 audit + 实现混在一起 | **两阶段** · audit 先 → 停 → 用户放行 → 实现 |
| scope 边界 | 没白名单 · design 顺手"对齐" | **文件白名单** · 越界 = 退回 |
| 变更说明 | 散在代码注释 / commit msg | 强制 `_design-notes.md` · 6 段固定结构 |
| 拉取约束 | 目录引用("拉 design-brief/flows/") | 显式列每份 raw URL + Pre-flight checklist |
| 永久流程 | inline 在每个 task prompt | 抽 `AUDIT_PROTOCOL.md` 项目根 · task prompt ref |

> 模板演进史:v1 简单 4 步同步(2026-04)→ v2 强约束(2026-05 · T-B5 踩坑后)。
> 实例参考:`projects/projectE/handoff/tasks/T-B6.md` 是 v2 最新落地版本。
