# 目录约定 · 给 design 沙箱看

> ⚠️ 每个 KICKOFF / task prompt 顶部都会 ref 这个文件,或者直接 inline 关键部分。

---

## design 沙箱视角

你的沙箱"项目根" = GitHub repo 的 `projects/<project-name>/`(workspace 子项目)。

raw URL 模板:
```
https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/<path>
```

例(项目名 = `projectE`,repo = `ui-rebuild-workspace`):
```
https://raw.githubusercontent.com/<owner>/ui-rebuild-workspace/main/projects/projectE/handoff/spec/info-architecture.md
https://raw.githubusercontent.com/<owner>/ui-rebuild-workspace/main/projects/projectE/handoff/preview/Phase A · 主菜单 大掌柜.html
```

---

## 子目录用途

| 子目录 | 谁产出 | 谁读 | 内容 |
|---|---|---|---|
| `design-brief/` | 用户 + Claude 维护 | design 必读 | PNG 抽帧 / canonical 屏映射 / 风格参考 |
| `design-brief/analysis/` | ffmpeg 抽帧 + 筛选 | — | 50+ 张高清 PNG |
| `design-brief/flows/` | Claude 维护 | design 必读 | canonical(info-architecture / interaction-spec / screen-details / topology)|
| `design-brief/style-reference/` | 用户上传 | design 必读 | 风格参考图(色板 / UI / 字体)|
| `preview/` | ⭐ **design 沙箱产出 HTML 真值放这里**(不要放沙箱根)| design 读 + 用户看 | Style Lock.html / Phase A 主菜单.html / 合并预演.html / 等 |
| `final/` | design 沙箱产出 + Claude verify | npm install 直接跑 | Vite Vue 3 工程(src/data/components/views/...)|
| `tasks/` | Claude 起草 | design 拉(可选) | 一次性 task prompt(T-B1.md / T-B2.md ...)|
| `bugs/` | Claude 起草 | design 中转(可选) | 一次性 bug 报告 |
| `frames/` | ffmpeg 抽帧产出 | — | raw 131 / dedup 83 / selected 50 三层 |
| `input/` | 用户上传 | — | 原始视频文件 |
| `PROGRESS.md` | Claude 维护 + 每次更新 | ⭐ design 必拉 | 实时进度(当前阶段 / canonical 版本 / 已废清单 / 9 共享 modal 状态)|
| `KICKOFF.md` | 用户 + Claude | design 必读 | 本项目首次启动指令 |
| `README.md` | Claude | — | 项目说明 |

---

## ⭐ 关键约定:HTML 真值放 `preview/`

design 沙箱**不要把 HTML 真值放沙箱根**,统一放 `preview/`:

```html
<!-- preview/Phase A · 主菜单 大掌柜.html -->
<link rel="stylesheet" href="../final/src/styles/tokens.css" />
                              ^^^ 注意相对路径:从 preview/ 引 final/ 用 "../"
```

理由:
- 沙箱根 = 项目根(很多杂物),不要堆 HTML
- preview/ 跟 final/ 同级,一眼看出"真值 vs 工程"对应关系
- 本地 / GitHub / 沙箱目录结构 1:1 对齐(无 sed 后处理)

---

## ⭐ 关键约定:PROGRESS.md 必拉

每个 task / 每次开工:
1. 主动 fetch `https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/handoff/PROGRESS.md`
2. 看"当前阶段 / 已完成 / canonical 版本 / 5 条已废清单 / 待办"
3. 不要凭沙箱里的旧版猜进度

---

## ⭐ 关键约定:不要复制粘贴沙箱旧版到新产出

design 沙箱状态默认不同步 GitHub。开工前**必须主动拉**(KICKOFF / task prompt 顶部会列必拉清单):
- `design-brief/flows/*`(canonical)
- `design-brief/SYNC_PROTOCOL.md`
- `preview/*.html`(HTML 真值,可能 Claude 改过)
- `final/src/*`(Vue 工程,T-B1 已有)
- `PROGRESS.md`

拉完以 GitHub 为准覆盖沙箱旧版。

---

## 跨项目共享(workspace 级,不在 design 沙箱视角内)

workspace 根的 `docs/` + `scripts/` 是**跨项目通用**(给用户 + Claude 用),design 沙箱看不到也不需要拉:

```
ui-rebuild-workspace/         # workspace 根
├── docs/                     # 通用规约 / 模板 / LESSONS
├── scripts/                  # 通用工具
└── projects/
    └── projectE/             # ← design 沙箱视角到这一层
        └── ...               # ← design 拉 raw URL 都加这层前缀
```
