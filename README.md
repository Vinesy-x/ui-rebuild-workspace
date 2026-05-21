# ui-rebuild-workspace

> 用户 ↔ Claude ↔ design 三方协作的 **UI 重建 workspace**。
>
> 适用场景:把现代版 / 现成游戏视频抽帧 → 风格换皮(古风 / 复古 / 其他)→ Vite Vue 3 工程实现。

---

## 当前项目

| 项目 | 状态 | 风格 | 说明 |
|---|---|---|---|
| [projects/projectE/](projects/projectE/) | Phase B T-B1~T-B5 ✅ / T-B6 待启动 | 宋朝古风(江南水乡水墨彩绘)| 大掌柜 — BitLife 类放置养成,448×960 |

## workspace 结构

```
ui-rebuild-workspace/
├── README.md                # 本文件,workspace 索引
├── METHODOLOGY.md           # 11 步通用方法论
│
├── docs/                    # ⭐ 通用协作规约 + 模板(跨项目复用)
│   ├── COLLABORATION_PROTOCOL.md  # 三方协作规约
│   ├── SYNC_PROTOCOL.md           # 沙箱 ↔ GitHub 同步规约
│   ├── DIRECTORY_CONVENTION.md    # 目录约定(给 design 看)
│   ├── KICKOFF_TEMPLATE.md        # 新项目 KICKOFF 模板
│   ├── TASK_PROMPT_TEMPLATE.md    # Phase B task 模板
│   ├── PROGRESS_TEMPLATE.md       # PROGRESS.md 模板
│   └── LESSONS.md                 # 跨项目经验沉淀
│
├── scripts/                 # ⭐ 通用工具(跨项目复用)
│   ├── new-project.sh       # 一键新建项目脚手架
│   ├── import-design.sh     # 从 design 沙箱 link 拉产出到本地
│   ├── extract_palette.py   # 提取色板
│   ├── dedup.py             # phash 抽帧去重
│   ├── make_grid.py         # 抽帧 grid 缩略图
│   └── preview.sh           # 跑本地 dev server
│
└── projects/                # 具体项目(可多个 · 2026-05 refactor v2:handoff/_internal 双区)
    └── projectE/            # 当前项目
        ├── README.md
        ├── handoff/             ⭐ design 唯一边界
        │   ├── PROGRESS.md           # ⭐ 实时进度(design 每次 task 必拉)
        │   ├── KICKOFF.md            # 首次启动 prompt
        │   ├── spec/                 # canonical 屏映射 / 交互 / 拓扑(design 必拉)
        │   ├── tasks/                # 各屏一次性 task prompt + archive
        │   ├── preview/              # design HTML 真值产出
        │   └── final/                # Vite Vue 3 工程层
        └── _internal/          # ⬅ design 不碰(user/Claude 内部)
            ├── analysis/             # Claude 分析用 PNG(png/extras/style-reference)
            ├── bugs/                 # bug 报告 + archive
            ├── frames/               # ffmpeg 抽帧三层(raw/dedup/selected)
            └── input/                # 视频原料
```

## 入口文档(读这些)

1. **新人**(刚接触本 workspace):`METHODOLOGY.md` 看 11 步方法论
2. **新项目**:跑 `./scripts/new-project.sh <name>` → 编辑 `projects/<name>/handoff/KICKOFF.md`
3. **复用经验**:`docs/LESSONS.md`(跨项目踩坑教训)
4. **三方协作**:`docs/COLLABORATION_PROTOCOL.md` + `docs/SYNC_PROTOCOL.md`

## 新项目开工(5 步)

```bash
# 1. 脚手架
./scripts/new-project.sh projectF

# 2. 上传素材(原料在 _internal/ · design 不碰)
cp ~/Downloads/视频.mp4 projects/projectF/_internal/input/
# 用户传风格参考图到 projects/projectF/_internal/analysis/style-reference/

# 3. 抽帧 + 筛选
ffmpeg -i projects/projectF/_internal/input/视频.mp4 -vf "fps=1/2" projects/projectF/_internal/frames/raw/projectF_fps_%04d.png
python3 scripts/dedup.py projects/projectF/_internal/frames/raw projects/projectF/_internal/frames/dedup
# 用户筛 50 张关键屏到 _internal/frames/selected/ + cp 高清到 _internal/analysis/png/

# 4. 编辑 KICKOFF(在 handoff/ 下 · design 必拉)
$EDITOR projects/projectF/handoff/KICKOFF.md   # 填 {{游戏名}} / {{风格}} / 等占位符

# 5. commit + push + 给 design 发 KICKOFF
git add projects/projectF/ && git commit -m "feat(projectF): 新项目脚手架" && git push
# 在 design 沙箱整段复制粘贴 KICKOFF.md 的 ``` 块
```

## Phase B 各屏推进(每屏 1 task · v2 两阶段强约束)

```bash
# 1. 复制 v2 task 模板(两阶段 + 白名单 + _design-notes.md 强约束)
cp docs/TASK_PROMPT_TEMPLATE.md projects/projectE/handoff/tasks/T-B<N>.md
$EDITOR projects/projectE/handoff/tasks/T-B<N>.md   # 填 {{...}}

# 2. commit + push
git add -A && git commit -m "feat(projectE): T-B<N> task prompt" && git push

# 3. 给 design 发短指令(只需 1 个 raw URL,task prompt 里已含 PROGRESS pull list)
# 阶段 1: design 出 audit 报告 → 停 → 用户验收
# 阶段 2: design 出 design link + 沙箱根 _design-notes.md → 用户 import

# 4. 拉本地 + verify
./scripts/import-design.sh "https://api.anthropic.com/v1/design/h/XXX"
# Claude verify(对照 _design-notes.md · grep 已废清单 · vite build)→ commit

# 参考实例:projects/projectE/handoff/tasks/T-B6.md(v2 最新落地版)
```
