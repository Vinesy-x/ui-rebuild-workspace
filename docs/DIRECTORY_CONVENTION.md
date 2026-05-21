# 目录约定 · 给 design 沙箱看

> ⚠️ 每个 KICKOFF / task prompt 顶部都会 ref 这个文件,或者直接 inline 关键部分。

---

## design 沙箱视角(2026-05 refactor v2 · handoff/ 强隔离)

你的沙箱"工作边界" = GitHub repo 的 `projects/<project-name>/handoff/`。

raw URL 模板:
```
https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/handoff/<path>
```

例(项目名 = `projectE`,repo = `ui-rebuild-workspace`):
```
https://raw.githubusercontent.com/<owner>/ui-rebuild-workspace/main/projects/projectE/handoff/spec/info-architecture.md
https://raw.githubusercontent.com/<owner>/ui-rebuild-workspace/main/projects/projectE/handoff/preview/大掌柜.html
```

> ⚠️ `projects/<name>/_internal/`(bugs / input / frames / analysis)= user/Claude 内部 · **design 不拉、不读、不碰**。

---

## handoff/ 内部子目录(design 边界)

| 子目录 / 文件 | 谁产出 | 谁读 | 内容 |
|---|---|---|---|
| `handoff/PROGRESS.md` | Claude 维护 + 每次更新 | ⭐ design 每次必拉 | 实时进度(当前阶段 / canonical 版本 / 已废清单 / 共享 modal 状态)|
| `handoff/KICKOFF.md` | 用户 + Claude | design 首次必读 | 本项目首次启动指令 |
| `handoff/spec/` | Claude 维护 | ⭐ design 必读 | canonical(info-architecture / interaction-spec / screen-details / topology / extras)|
| `handoff/tasks/` | Claude 起草 | design 拉本 task | 一次性 task prompt(T-B<N>.md + archive)|
| `handoff/preview/` | ⭐ **design 沙箱产出 HTML 真值放这里** | design 改 + 用户看 | 大掌柜.html / Style Lock.html / 等 |
| `handoff/final/` | design 沙箱产出 + Claude verify | npm install 直接跑 | Vite Vue 3 工程(src/data/components/views/...)|

## _internal/ 内部子目录(user 内部 · design 不碰)

| 子目录 | 谁产出 | 内容 |
|---|---|---|
| `_internal/analysis/png/` | ffmpeg 抽帧 + 用户筛 | 50+ 张高清 PNG(Claude 分析用)|
| `_internal/analysis/extras/` | 同上 | 备份抽帧 |
| `_internal/analysis/style-reference/` | 用户上传 | Phase A 风格参考底图(归档)|
| `_internal/bugs/` | Claude 起草 | bug 报告 + archive |
| `_internal/frames/` | ffmpeg 抽帧产出 | raw / dedup / selected 三层 |
| `_internal/input/` | 用户上传 | 原始视频文件 |

---

## ⭐ 关键约定:HTML 真值放 `handoff/preview/`

design 沙箱**不要把 HTML 真值放沙箱根 / handoff/ 根**,统一放 `handoff/preview/`:

```html
<!-- handoff/preview/大掌柜.html -->
<link rel="stylesheet" href="../final/src/styles/tokens.css" />
                              ^^^ 从 handoff/preview/ 引 handoff/final/ 用 "../"
```

理由:
- 沙箱根 / handoff/ 根 = 杂物多,不堆 HTML
- `handoff/preview/` 跟 `handoff/final/` 同级,一眼看出"真值 vs 工程"对应关系
- 本地 / GitHub / 沙箱目录结构 1:1 对齐(无 sed 后处理)

---

## ⭐ 关键约定:PROGRESS.md 必拉(每个 task 都要)

每个 task / 每次开工:
1. 主动 fetch `https://raw.githubusercontent.com/<owner>/<repo>/main/projects/<name>/handoff/PROGRESS.md`
2. 文档含:项目快照 / 当前阶段 / canonical 版本 / 已废清单 / 13 共享 modal 状态 / 待办
3. **末尾的 audit-pre-design 段** = 设计前必跑的 audit 协议(每个 task 阶段 1 用)
4. 不要凭沙箱里的旧版猜进度

---

## ⭐ 关键约定:不要复制粘贴沙箱旧版到新产出

design 沙箱状态默认不同步 GitHub。开工前**主动把 `projects/<name>/handoff/` 整个目录递归拉下来**:
- 用 GitHub tree API 一次列所有 path
- 过滤 `projects/<name>/handoff/` 开头的 blob
- 每份 raw URL fetch

工作集 ≈ 50 文件 / ~800KB / ~195K tokens。
拉完以 GitHub 为准覆盖沙箱旧版。⚠️ 不要拉 `_internal/`。

---

## 跨项目共享(workspace 级,不在 design 沙箱视角内)

workspace 根的 `docs/` + `scripts/` 是**跨项目通用**(给用户 + Claude 用),design 沙箱看不到也不需要拉:

```
ui-rebuild-workspace/             # workspace 根
├── docs/                         # 通用规约 / 模板 / LESSONS
├── scripts/                      # 通用工具
└── projects/
    └── projectE/                 # ← project 根
        ├── handoff/              # ← ⭐ design 沙箱视角到这一层
        │   └── ...               # ← design 拉 raw URL 都加这层前缀
        └── _internal/            # ← design 不碰
```
