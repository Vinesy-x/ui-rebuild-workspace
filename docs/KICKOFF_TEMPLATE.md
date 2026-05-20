# KICKOFF 模板 · 新项目首次启动 prompt

> 复制此文件到 `projects/<new-name>/KICKOFF.md`,改 `{{...}}` 占位符。
> 用户首次给 design 沙箱发的就是这一份(整段复制粘贴)。

---

```
{{游戏名}} · 视频 UI 重建任务

【目录约定 — ⚠️ 必读 ⚠️】

你的沙箱项目根 = GitHub repo 的 projects/{{name}}/

raw URL 模板:
https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/projects/{{name}}/<path>

⭐ HTML 真值产出位置:统一放 preview/(不要放沙箱根)
   link 相对路径: <link href="../final/src/styles/tokens.css">

⭐ Vue 工程位置:final/src/

⭐ canonical 必读:design-brief/flows/*(屏映射 / 交互 / 拓扑 / 逐屏 spec)

⭐ 进度跟踪:PROGRESS.md(每次开工前必拉,了解当前阶段 + 已废清单)

详细目录约定:docs/DIRECTORY_CONVENTION.md(workspace 级)
raw URL: https://raw.githubusercontent.com/{{owner}}/{{repo}}/main/docs/DIRECTORY_CONVENTION.md


【项目背景】

- 游戏名: {{游戏名}}
- 类型: {{类型}}(例:模拟养成 / 卡牌战斗 / 等)
- 核心机制: {{机制描述}}
- 布局参考: {{N}} 帧视频抽帧(在 design-brief/analysis/)
- 视觉目标: {{风格}}(参考图在 design-brief/style-reference/)

⚠️ 双重源约定:
- 布局结构 + 交互行为 来自现代视频抽帧 + flows canonical
- 美术风格 来自参考图
- 文字内容 改成 {{语境}}(对照见 Style Lock 古风对照表)


【工程格式】

Vite + Vue 3(`<script setup>` + TS)+ Pinia + Vue Router。

产出目录结构(放在 projects/{{name}}/ 下):
- final/src/styles/tokens.css       全局 token
- final/src/components/*.vue         共享组件
- final/src/views/*.vue              屏组件
- final/src/data/*.json              真实数据
- final/src/stores/useModalStore.ts  Pinia store 管 modal
- final/src/router.ts                Vue Router

Modal 模式:
- 全部 modal 走 Pinia store(open(name, props) / close())
- ModalShell 组件挂根 layout,按 currentModal 渲染
- router.afterEach 切屏自动 reset modal
- modal 底板:scrim rgba(0,0,0,.65) + backdrop-filter blur(8px)


【Phase A 任务】

T-A1:{{锁定屏帧号}} 主屏 + 风格定档

输入:
1. design-brief/analysis/{{锁定屏 PNG}}
2. design-brief/style-reference/*.png
3. design-brief/flows/*(canonical)

要做:
- 布局 = {{锁定屏}}(描述关键元素)
- 视觉 = {{风格}}(从 style-reference 提炼)
- 文字 = {{语境化}}

同时交付 Style Lock(锁定后 Phase B 不再变):
- 色板 / 字号 / 字体 / 货币 icon / 角标系统 / 共享组件清单

产出:
- preview/Phase A · {{锁定屏名}}.html(HTML 视觉真值)
- preview/Style Lock · 风格定档.html(规约文档)
- final/src/* 完整骨架(views + components + stores + router + data)
- PROGRESS.md 初始化


【强约束】

1. tokens.css = 唯一颜色 / 字号源
2. 共享 modal 走 useModalStore(避免各屏自己写)
3. 图标用 SVG / PNG(禁 emoji / unicode)
4. modal scrim 锁定 rgba(0,0,0,.65) + blur(8px)
5. 中文正文 ≥ 18px(v3.1 锁定)
6. canonical 跟 PNG 冲突时以 PNG 为准,然后更新 canonical
7. HTML 真值放 preview/(不要放沙箱根)


【完成后告诉用户】

- 5 个风格关键词
- T-A1 产出的所有文件清单
- 文字怎么 {{语境化}}(具体对照)
- 共享组件命名清单
- 资产清单(SVG / PNG 待出)

完成停下等用户验收。
```

---

## 用法

1. 用户执行 `./scripts/new-project.sh <project-name>` 生成新项目骨架
2. 编辑 `projects/<project-name>/KICKOFF.md` 填 `{{...}}` 占位符
3. 上传 input/视频 + design-brief/style-reference/参考图 + 跑 ffmpeg 抽帧
4. commit + push
5. 在 design 沙箱里整段复制粘贴 KICKOFF.md 的 ``` 块内容
6. design 拉 raw URL,出 link
7. 用户跑 `./scripts/import-design.sh <link>` 拉本地
