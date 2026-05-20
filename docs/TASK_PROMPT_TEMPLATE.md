# task prompt 模板 · Phase B 每屏

> 复制此文件到 `projects/<name>/tasks/T-B{{n}}.md`,改 `{{...}}` 占位符。
> 跟 KICKOFF 不同 — 这是 Phase B 各屏推进的标准 task。

---

```
{{游戏名}} · Phase B T-B{{n}}
fps_{{帧号}} {{短描述}}


⚠️⚠️⚠️ 开工前同步(必做)— 避免 canonical 漂移 ⚠️⚠️⚠️

你的沙箱状态 ≠ GitHub 真值。你能主动从 GitHub 拉任何文件,但不会自动
拉。请你主动从 GitHub 拉下列文件最新版,覆盖你沙箱里对应文件:

repo = https://github.com/{{owner}}/{{repo}}  branch = main
raw URL 模板 = https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/<path>

必拉清单:

  进度跟踪(每次必拉):
  - projects/{{name}}/PROGRESS.md

  canonical 演进:
  - projects/{{name}}/design-brief/SYNC_PROTOCOL.md
  - projects/{{name}}/design-brief/flows/info-architecture.md
  - projects/{{name}}/design-brief/flows/interaction-spec.md
  - projects/{{name}}/design-brief/flows/screen-details.md
  - projects/{{name}}/design-brief/flows/screen-details-extras.md
  - projects/{{name}}/design-brief/flows/screen-details-extras2.md
  - projects/{{name}}/design-brief/flows/topology.html

  HTML 真值(在 preview/):
  - projects/{{name}}/preview/{{所有 .html}}

  Vue 工程层:
  - projects/{{name}}/final/(整个目录递归)

  workspace 级目录约定(可选):
  - docs/DIRECTORY_CONVENTION.md
  - docs/COLLABORATION_PROTOCOL.md

拉取完成 → 沙箱跟 GitHub 不一致的全部覆盖 → 以 GitHub 为准。

⚠️ 已知废弃项(每个项目维护自己的 PROGRESS.md 里有完整列表,
开工前必看):
{{从 PROGRESS.md 复制当前的 5 条已废清单}}


【任务范围】

N 帧 + inline state:
- fps_{{帧号}} = {{描述}}
- ...


【产出 N 件】

1. final/src/views/{{XxxView}}.vue   填实/新增
2. final/src/components/{{XxxModal}}.vue   新增(挂到 ModalShell map)
3. final/src/data/{{xxx}}.json   新增
4. router.ts 加路由 / BottomTabBar 跳转验证
5. preview/ 顺手补 HTML 真值(如 design 有用量)


【先读这些(canonical = 唯一真值,看,不复制)】

- PNG 真值: design-brief/analysis/projectE_fps_{{帧号}}.png
- canonical 文档: design-brief/flows/*(具体段落)
- 视觉参考: preview/*.html + final/src 既有结构


【强约束(继承,不重写)】

1. tokens.css 唯一源
2. 共享 modal 走 useModalStore
3. 印章+汉字 = 货币 icon 标准
4. modal scrim 锁定
5. 中文正文 ≥18px
6. canonical 跟 PNG 冲突时 PNG 优先,然后更新 canonical
7. 已废弃项不要重新引入


【完成后告诉用户】

- 关键命名 / 视觉 / 实现策略问题清单
- 顺便更新 PROGRESS.md 标记 T-B{{n}} ✅

完成停下等用户验收。
```

---

## 用法

1. 复制本模板到 `projects/<name>/tasks/T-B{{n}}.md`
2. 填 `{{...}}` 占位符(帧号 / 任务范围 / 产出清单)
3. commit + push
4. 用户发短指令给 design:
   ```
   继续做 T-B{{n}}。任务详情拉:
   https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/tasks/T-B{{n}}.md
   完成出 link。
   ```
5. design 出 link → 用户 import → Claude verify

或者两种触发方式 — 用户**直接复制粘贴整段** prompt(稳)。
