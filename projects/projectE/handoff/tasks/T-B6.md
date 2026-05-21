# T-B6 · 物品 Tab 6 (fps_0065-0088)

> **两阶段交付** · audit 先,实现后 · 严格白名单 + `_design-notes.md` deliverable
> 上一轮 T-B5 经验沉淀(scope creep / 漏 audit / 无变更说明)→ 本任务强约束

## ⚠️ 沙箱目录结构(2026-05 refactor v2 · handoff/ 强隔离)

- repo 根 = `ui-rebuild-workspace/`(多游戏 · 同根还有 `projects/projectF/` 等)
- **你的边界 = `projects/projectE/handoff/`** · 所有相对路径以 handoff/ 为根 · 产出必须在此之内
- ⚠️ 禁止写到 repo 根 / `projects/` 根 / `projectE/` 根 / `projectE/_internal/`(后者是 user/Claude 内部 · design 不碰)

## 步骤 1 · 同步 GitHub(沙箱状态 ≠ 真值)

raw URL 前缀 = `https://raw.githubusercontent.com/Vinesy-x/ui-rebuild-workspace/main/`

**全局状态 + 永久流程(2 份 · 每个 task 必拉)**
- `projects/projectE/handoff/PROGRESS.md`(项目快照 / 当前阶段 / 5 已废 / 13 modal 状态)
- `projects/projectE/handoff/AUDIT_PROTOCOL.md`(设计前 audit 协议 · 跨 task 通用 · ⭐ 阶段 1 跑它)

**canonical 真值 6 文档**(handoff/spec/ · ⚠️ 不拉这 6 份必出错)
- `projects/projectE/handoff/spec/info-architecture.md`
- `projects/projectE/handoff/spec/interaction-spec.md`
- `projects/projectE/handoff/spec/screen-details.md`
- `projects/projectE/handoff/spec/screen-details-extras.md`
- `projects/projectE/handoff/spec/screen-details-extras2.md`
- `projects/projectE/handoff/spec/topology.html`

**视觉真值 + 工程层**
- `projects/projectE/handoff/preview/大掌柜.html`(canonical 全集)
- `projects/projectE/handoff/preview/Style Lock · 风格定档.html`(15 色 / 8 字阶 / 9 货币 / 7 角标 / 27 古风对照)
- `projects/projectE/handoff/final/src/`(递归 · 已有 13 共享 modal + 7 filled view + tokens.css + components.css)

**Pre-flight checklist · 拉完打勾再开干**
- [ ] PROGRESS.md ✓
- [ ] 6 份 canonical flows ✓
- [ ] 大掌柜.html + Style Lock ✓
- [ ] final/src/ 递归 ✓

---

# 阶段 1:audit-pre-design 报告(必先 · 不出代码/HTML)

照 `projects/projectE/handoff/AUDIT_PROTOCOL.md` 跑两件 audit(handoff/ 根 · 不是 tasks/):

**A. HTML 真值 ↔ Vue 工程层 alignment**(7 个 filled view + 13 共享 modal)
- 视觉:字号走 `var(--fs-*)` 8 阶 / 颜色走 15 色 var
- 交互:`useModalStore.ts ModalName` ↔ `ModalShell.vue map` ↔ 各 view click 三方对齐
- 工程层完整度(只有 ShopItems 占位是预期的 = 本任务 T-B6 才填)

**B. preview/ Style Lock HTML 是否仍有价值**(27 古风对照 / 15 色 swatch 等是否被大掌柜.html 涵盖)

输出格式(精炼清单 · ≤ 800 字 · 绝对路径 + 行号 + 一句修法):
```
## A. 🔴 严重 — 视觉错位
| # | Vue 文件:行 | HTML 真值 行号 | 问题 | 修法 |

## B. 🟡 中度 — 字号/颜色违反 Style Lock

## C. 🟢 轻度
```

**完成阶段 1 → 出报告 → 停 → 等用户验收 → 用户口头放行后才进入阶段 2**

⚠️ 不要把阶段 1 跟阶段 2 一次性交付,会被退回。

---

# 阶段 2:T-B6 物品 Tab 6 实现(用户放行后才开始)

## 任务范围

5 sub-tab(canonical · `screen-details.md` 物品段):
- **衣服**(2 级 sub-tab:帽子/上衣/包/戒指/口红 5 项 · canonical v2 校正)
- **食物**(fps_0075 → PurchaseConfirmModal 食饮系)
- **居所**(fps_0082 → PurchaseConfirmModal 屋宅系)
- **车马**(canonical 古风化:車輿)
- **大件**(fps_0077 → CinematicScene 过场 · fps_0067-69 → AsyncWaitModal 卖车 3 步链)

涉及帧:fps_0065-0088(24 帧)。

## ⚠️ 文件白名单(本次只能新增/修改这些 · 其余 read-only)

**新增**:
- `final/src/views/ShopItems.vue` ← 当前是 15 行占位 · 填实
- `final/src/data/itemsList.json` ← 衣食居車大件 5 分类 + 古风化命名 + tier 体系

**修改**(只允许触这 2 个 · 加注册条目)
- `final/src/stores/useModalStore.ts` ← 加 ModalName(如有新 modal · 但 canonical 推荐复用既有 PurchaseConfirm/AsyncWait/Cinematic)
- `final/src/components/ModalShell.vue` ← map 注册(同上)

**视觉真值**(可选 · 顺手)
- `projects/projectE/handoff/preview/大掌柜.html` ← 补 T-B6 物品屏段(参照 T-B3/T-B4 段的格式)

**绝对禁止**触:
- 其他 view(MainMenu / SkillList / MeetList / RelationDetail / WorkDAG / BusinessList / InvestBank)
- 其他 modal(13 个已就位的)
- HudBar / BottomTabBar / ModalShell 内部逻辑(只能加注册条目,不改结构)
- styles/tokens.css / styles/components.css(canonical 已锁定)
- router.ts(/items 路由已存在)
- 其他 view 对应的 data json

> 任何"顺手对齐"既有文件 = scope creep = 退回(T-B5 已踩坑)。
> 如果发现既有文件确实有 bug 必须修,**单独列在 _design-notes.md 待用户审批**,不直接改。

## 强约束(继承,不重写)

1. tokens.css = 唯一颜色 / 字号源 · 字号走 `var(--fs-*)` 8 阶
2. 共享 modal 走 `useModalStore` + `ModalShell` map · 不重复 implement
3. 印章 + 汉字 = 货币 icon 标准 · 复用 `.ic-seal.ic-coin/ic-jade/...` 全局 class
4. modal scrim 锁定 rgba(0,0,0,.65) + backdrop-filter blur(8px)
5. 中文正文 ≥18px(v3.1)
6. canonical 跟 PNG 冲突时 PNG 优先,然后更新 canonical
7. 已废弃项(PROGRESS.md 5 条已废清单)不要重新引入

## 古风化(预期范围 · 由 design 最终拍板)

参考:衣服→服飾 / 食物→膳食 / 居所→宅邸 / 车马→車輿 / 大件→重器 · 等。完整对照在 `_design-notes.md` 列。

## deliverable:`_design-notes.md`(沙箱根放一份)

完成后必须给 + 内容:
```
# T-B6 _design-notes

## audit 阶段发现(回顾)
| # | 项 | 已修 | 跳过 + 理由 |

## 本次产出清单(文件级)
| 文件 | 新增/修改/删除 | 一句话变更说明 |

## 古风化对照表(T-B6 新增)
| 现代 | 古风 |
|---|---|
| 衣服 | ? |
| ... | ... |

## 共享 modal 复用清单
| modal | 用法 | 触发位置 |

## 跳过未做的项(必须显式列)
| 项 | 原因 |

## 风险 / 待用户确认
| # | 项 | 建议 |
```

## 完成

- 阶段 1 audit 报告 → 停 → 等放行
- 阶段 2 完成 → 出 design link · `_design-notes.md` 必须在沙箱根
- 用户 import 后跑 vite build · 通过才算完工
- 跑通后更新 PROGRESS.md 标记 T-B6 ✅

不要写代码 · 不要主动开下一屏 · 阶段 1 完成 → 停。
