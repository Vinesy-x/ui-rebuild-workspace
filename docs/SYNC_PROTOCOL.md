# SYNC_PROTOCOL · 沙箱 ↔ GitHub 同步规约

> workspace 级文档(跨项目)。三方协作总规约见 `COLLABORATION_PROTOCOL.md`。本文件聚焦同步机制。

---

## 1 · 核心事实(给 design 看)

1. **沙箱状态 ≠ GitHub 真值**
   - design 你在沙箱里改 → 沙箱 snapshot tarball → 用户 `import-design.sh` rsync 到本地 → push GitHub
   - **反方向不自动**:GitHub 上有变动 → 你沙箱不会自动拉
   - 你能主动从 GitHub 拉(raw URL),**但必须 prompt 明确指令你拉**
   - 不拉就会用沙箱旧版 → 复制到新产出 → 用户 import 时 rsync --delete 覆盖本地 → canonical 漂移

2. **GitHub = 唯一真值**
   - 任何冲突以 GitHub main HEAD 为准
   - 沙箱里如果有跟 GitHub 不一致的文件 → **主动拉 GitHub 最新版覆盖沙箱**
   - 不要复制粘贴沙箱里的旧版到新产出

3. **canonical 演进**
   - canonical 文档(`projects/<name>/handoff/spec/*`)Claude 维护,push GitHub
   - 每次新 task **主动从 raw URL 拉 canonical 最新版**作为依据
   - 看到 ⚠️ "校正 / 作废 / 废弃" 严格遵循

---

## 2 · 给 design 的"开工前同步"指令(task prompt 顶部 inline)

⚠️ 这一段必须 **inline** 在每个 task prompt 文本里。不要写 "读 X.md" 让 design 自己找 —— 沙箱默认状态没拉就读不到。

```
开工前同步(必做):

repo = https://github.com/<owner>/<repo>  branch = main
raw URL 模板 = https://raw.githubusercontent.com/<owner>/<repo>/main/<path>

主动从 GitHub 拉下列文件最新版,覆盖你沙箱里对应文件:

  ⭐ 进度跟踪(每次必拉):
  - projects/<name>/handoff/PROGRESS.md

  canonical(项目级,design 沙箱视角根):
  - projects/<name>/handoff/spec/info-architecture.md
  - projects/<name>/handoff/spec/interaction-spec.md
  - projects/<name>/handoff/spec/screen-details.md
  - projects/<name>/handoff/spec/screen-details-extras.md
  - projects/<name>/handoff/spec/screen-details-extras2.md
  - projects/<name>/handoff/spec/topology.html

  HTML 真值(在 handoff/preview/,不要放沙箱根 / handoff/ 根):
  - projects/<name>/handoff/preview/(整个目录)

  Vue 工程层:
  - projects/<name>/handoff/final/(整个目录递归)

  workspace 级规约(可选,如需查约定):
  - docs/COLLABORATION_PROTOCOL.md
  - docs/SYNC_PROTOCOL.md
  - docs/DIRECTORY_CONVENTION.md

拉完 → 沙箱跟 GitHub 不一致的全部覆盖 → 以 GitHub 为准。

已知废弃项(每个项目独立维护) → 严格遵循,不要重新引入。
具体清单见 PROGRESS.md 顶部"已知废弃项"段。
```

---

## 3 · 给 Claude 的"import 后" 防漂移 checklist

每次 `./scripts/import-design.sh <link> <name>` 完后:

```bash
# 1. 看改动
git status -s
git diff --stat projects/<name>/

# 2. grep 已废清单(应该 0)
#    清单 = projects/<name>/handoff/PROGRESS.md 顶部的"已知废弃项"
#    具体 grep pattern 按当时清单调整

# 3. vite build 验工程
cd projects/<name>/handoff/final && npx vite build && cd -

# 4. 校对新增 view / component / data 跟 canonical 一致
```

漂移 → 立刻本地清 → commit 标 "fix(漂移): 沙箱旧版回滚" → 下次 task prompt 顶部强化提醒。

---

## 4 · 治本方案(长期)

`import-design.sh` 不再用 `rsync --delete`,改 3-way merge:
- design 沙箱产出 = "feature branch"
- 本地手改 = "main"
- merge 让用户决策冲突

目前 1-way rsync 仍是默认,**靠规约 + checklist 治标**。

---

## 5 · 历史回滚事故 log

| 日期 | commit | 事故 |
|---|---|---|
| 2026-05-20 | `3a81c3b` | 清 Phase A.html 4 处 NPC click |
| 2026-05-20 | T-B1 import (`68d7850`) | 4 处全回滚(沙箱 design 没修)|
| 2026-05-20 | `592b62c` | 再清 8 处(Phase A.html 4 + 大掌柜.html 4)|
| 2026-05-20 | `552bdfb` | SYNC_PROTOCOL 改"主动拉取" + raw URL |
| 2026-05-20 | T-B2 sync | ✅ design 主动拉 37 文件,无漂移 |
| 2026-05-20 | workspace 重构 | 单项目 → multi-project workspace 化,docs/scripts 通用化 |
