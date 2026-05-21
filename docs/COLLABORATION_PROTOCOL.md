# COLLABORATION_PROTOCOL · 三方协作通用规约

> workspace 级文档(跨项目复用)。三方:**用户** · **Claude**(canonical 维护 + import 验)· **design**(沙箱视觉/Vue 产出)。

---

## 1 · 三方角色 + 能力边界

### 用户
- 决策(走 design 还是 Claude 直接做 / 验视觉 / 取舍优先级)
- **中转 prompt 文本**:Claude 起草 → 用户复制粘贴整段给 design(沙箱接受指令的唯一可靠入口)
- 给 design 短指令 + raw URL(让 design 拉 task prompt)
- 跑 `./scripts/import-design.sh <link> [project-name]` 拉 design 沙箱产出
- 审视 import 后的产出
- 跑 `./scripts/new-project.sh <name>` 开新项目

### Claude
- 维护 canonical(`projects/<name>/handoff/spec/*.md`)— GitHub 唯一真值
- 维护 `projects/<name>/handoff/PROGRESS.md`(实时进度,design 必拉)
- 起草 task prompt(`projects/<name>/handoff/tasks/T-B*.md`,瘦身 + 自包含)
- import 后跑 grep checklist 防漂移 + `vite build` 验工程
- 起 bug 报告(`projects/<name>/_internal/bugs/*.md`)
- Phase B 工程填充可直接做(不走 design,节省 4 回合 ceremony)

### design(沙箱独立 AI 实例)
- 沙箱项目根 = `projects/<name>/`(workspace 子项目)
- 风格视觉判断(色板/字号/印章/古风元素)极强
- 在沙箱里改 `design-brief/` + `final/` + `preview/`
- 出 link(tarball)
- **不会自动同步 GitHub**,必须 prompt 明确指令主动拉

---

## 2 · 沙箱 ↔ GitHub 同步模型

详见 `docs/SYNC_PROTOCOL.md`。关键点:

1. **沙箱 ≠ GitHub 真值**(两套独立状态)
2. **design 能拉但不自动拉** — task prompt 顶部必须 inline 必拉清单 + raw URL
3. **`import-design.sh` 单向覆盖**(本地手改可能被 rsync --delete 回滚)
4. **修复模式**:每次 task prompt 顶部 inline 必拉清单 + 已废清单(design 拉到 GitHub 最新版覆盖沙箱旧版)

---

## 3 · task prompt 模板

详见 `docs/TASK_PROMPT_TEMPLATE.md`(权威模板,新 task 复制改 `{{name}}` 占位符)。

骨架:
1. 开工前同步指令(inline 必拉清单 + raw URL + 已废清单)
2. 任务范围(N 帧)
3. 产出 N 件(具体文件名)
4. 先读 canonical(只 ref 路径,不复制内容)
5. 强约束(继承,不重写)
6. 完成后告知用户

### 触发方式
- **A** — 整段复制粘贴(稳,prompt 长)
- **B** — 短指令 + raw URL,design 自己拉 prompt:
  ```
  继续做 T-Bx。拉:
  https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/handoff/tasks/T-Bx.md
  完成出 link
  ```

---

## 4 · workspace 文档分层

| 层 | 位置 | 维护者 | 给谁 |
|---|---|---|---|
| 通用规约 | `docs/` | Claude | 用户 + Claude + design 拉到沙箱 |
| 通用工具 | `scripts/` | Claude | 用户跑 |
| canonical | `projects/<name>/handoff/spec/*` | Claude | design 必读 |
| 工程产出 | `projects/<name>/handoff/final/` | design + Claude verify | `npm install` 跑 |
| HTML 真值 | `projects/<name>/handoff/preview/` | design 产出 | design 看 + 用户预览 |
| 实时进度 | `projects/<name>/handoff/PROGRESS.md` | Claude 每 task 更新 | design 每次必拉 |
| 任务 prompt | `projects/<name>/handoff/tasks/T-B*.md` | Claude | design 拉(可选)|
| bug 报告 | `projects/<name>/_internal/bugs/*.md` | Claude | 用户中转给 design |
| 视频原料 | `projects/<name>/_internal/input/` | 用户 | — |
| 抽帧 | `projects/<name>/_internal/frames/` | ffmpeg + 用户筛 | — |

⭐ design 沙箱视角 = `projects/<name>/` 是它的项目根。raw URL 模板:
```
https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/<path>
```

workspace 级 `docs/` 也能拉:
```
https://raw.githubusercontent.com/<owner>/<repo>/main/docs/<file>
```

---

## 5 · import 后防漂移 checklist(Claude 我执行)

每次 `./scripts/import-design.sh <link> <name>` 完后:

```bash
# 1. 看 design 改了什么
git status -s
git diff --stat projects/<name>/

# 2. grep 已废清单(应该全 0,只允许"作废注释")
#    具体废弃清单 = projects/<name>/handoff/PROGRESS.md 里的"已知废弃项"段
#    每个项目独立维护,Claude 按当时清单 grep

# 3. vite build 验工程能跑
cd projects/<name>/handoff/final && npx vite build && cd -

# 4. 看新增 view / component / json,对照 canonical 验证数据
```

有漂移 → 本地清 → commit 标 "fix(漂移): 沙箱旧版回滚" → 下次 task prompt 顶部加强已废提醒。

---

## 6 · 沟通节奏(每屏 1 task)

```
1. Claude 起草 projects/<name>/handoff/tasks/T-Bx.md(瘦身 + 自包含)
2. Claude 更新 projects/<name>/handoff/PROGRESS.md(标记当前 task)
3. Claude commit + push GitHub
4. 用户发短指令 + raw URL 给 design(或整段复制 prompt)
5. design 主动拉 GitHub canonical + PROGRESS + 必拉清单
6. design 在沙箱里做产出
7. design 出 link
8. 用户给 Claude link
9. Claude 跑 ./scripts/import-design.sh <link> <name>
10. Claude 跑 §5 防漂移 checklist
11. Claude 更新 PROGRESS.md 标 T-Bx ✅
12. Claude commit 验收
13. 有 bug → Claude 起 bugs/*.md → 用户中转给 design
14. 全部通过 → 进下一屏
```

---

## 7 · 何时不走 design 沙箱(Claude 直接做)

| 类型 | 走 design? | 理由 |
|---|---|---|
| 风格定档 | ✅ 走 | design 视觉判断强 |
| Phase B 工程填充 | 可选 | Claude 直接做更快不漂移 |
| canonical 维护 | ❌ Claude | canonical 是 Claude 的职责 |
| workspace `docs/` + `scripts/` | ❌ Claude | 给用户 + Claude 用 |
| 修小漂移 | ⚠️ 优先 bug 报告 | 本地手改会被覆盖 |

---

## 8 · 已知反模式(吸取教训)

1. **prompt 里复制粘贴 canonical** → 双源漂移
2. **prompt 写"读 X.md"不指令拉** → design 不会自动拉
3. **本地手改沙箱产出** → rsync --delete 覆盖回滚
4. **canonical 没标 ⚠️ 校正** → design 复制旧代码到新产出
5. **走 design 做纯代码** → 4 回合 ceremony 慢
6. **多 task 并发改同一 view** → 合并冲突
7. **不在 commit message 记录漂移源** → 事故难追踪

---

## 9 · TL;DR 速查

1. 每个 task **套 §3 模板**,不复制 canonical 内容,只 ref 路径
2. **prompt 顶部必 inline** 同步指令 + 必拉清单 + 已废清单(已废清单从 PROGRESS.md 复制)
3. **触发 design** 用户发短指令 + raw URL → design 拉 prompt → 出 link
4. **import 后** 跑 §5 防漂移 checklist + `vite build` → 有漂移立刻清
5. **canonical 维护** Claude 直接改 push,不走 design
6. **下次 prompt** 已废清单可能要更新(随 canonical 演进)
7. **Phase B 工程填充** 可让 Claude 直接做(节省 4 回合)
