#!/usr/bin/env bash
#
# new-project.sh — 在 workspace 下新建项目脚手架(2026-05 refactor v2 · handoff/ 强隔离)
#
# 用法:
#   ./scripts/new-project.sh <project-name>
#
# 行为:
#   1. mkdir projects/<name>/{handoff/, _internal/, README.md}
#      handoff/   = design 边界 · spec/preview/final/tasks/PROGRESS/AUDIT_PROTOCOL/KICKOFF
#      _internal/ = user 内部 · bugs/input/frames/analysis · design 不碰
#   2. cp 模板:KICKOFF → handoff/ · PROGRESS → handoff/
#   3. AUDIT_PROTOCOL.md 从 projectE 拷贝(跨项目通用)
#   4. 初始化 README.md(projectE-style 2 区结构说明)+ handoff/preview/README.md
#   5. 输出下一步 checklist

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <project-name>" >&2
  echo "Example: $0 projectF" >&2
  exit 1
fi

NAME="$1"
WORKSPACE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJ_DIR="$WORKSPACE_ROOT/projects/$NAME"

if [ -d "$PROJ_DIR" ]; then
  echo "ERROR: projects/$NAME already exists" >&2
  exit 2
fi

echo "==> 新建 projects/$NAME/(handoff + _internal 双区结构)"
mkdir -p \
  "$PROJ_DIR/handoff/spec" \
  "$PROJ_DIR/handoff/preview" \
  "$PROJ_DIR/handoff/final/src/views" \
  "$PROJ_DIR/handoff/final/src/components" \
  "$PROJ_DIR/handoff/final/src/data" \
  "$PROJ_DIR/handoff/final/src/stores" \
  "$PROJ_DIR/handoff/final/src/styles" \
  "$PROJ_DIR/handoff/final/src/types" \
  "$PROJ_DIR/handoff/final/src/utils" \
  "$PROJ_DIR/handoff/tasks/archive" \
  "$PROJ_DIR/_internal/analysis/style-reference" \
  "$PROJ_DIR/_internal/bugs/archive" \
  "$PROJ_DIR/_internal/frames/raw" \
  "$PROJ_DIR/_internal/frames/dedup" \
  "$PROJ_DIR/_internal/frames/selected" \
  "$PROJ_DIR/_internal/input"

# 复制模板
echo "==> 初始化 KICKOFF / PROGRESS / AUDIT_PROTOCOL / README"
cp "$WORKSPACE_ROOT/docs/KICKOFF_TEMPLATE.md" "$PROJ_DIR/handoff/KICKOFF.md"
cp "$WORKSPACE_ROOT/docs/PROGRESS_TEMPLATE.md" "$PROJ_DIR/handoff/PROGRESS.md"

# AUDIT_PROTOCOL 跨项目通用 · 从 projectE 引用模板(若不存在则跳过)
if [ -f "$WORKSPACE_ROOT/projects/projectE/handoff/AUDIT_PROTOCOL.md" ]; then
  cp "$WORKSPACE_ROOT/projects/projectE/handoff/AUDIT_PROTOCOL.md" "$PROJ_DIR/handoff/AUDIT_PROTOCOL.md"
  # 替换 projectE → $NAME
  sed -i '' "s|projectE|$NAME|g" "$PROJ_DIR/handoff/AUDIT_PROTOCOL.md" 2>/dev/null || \
    sed -i "s|projectE|$NAME|g" "$PROJ_DIR/handoff/AUDIT_PROTOCOL.md"
fi

cat > "$PROJ_DIR/README.md" << EOF
# $NAME

> UI 重建项目,在 ui-rebuild-workspace 下。

## 目录边界(handoff / _internal 强隔离)

\`\`\`
$NAME/
├── README.md                  ← 本文件
├── handoff/                   ⭐ design 唯一边界
│   ├── PROGRESS.md            ⭐ 每次必拉
│   ├── AUDIT_PROTOCOL.md      ⭐ 每次必拉
│   ├── KICKOFF.md             首次启动
│   ├── spec/                  canonical 真值
│   ├── tasks/                 各屏 task prompt
│   ├── preview/               HTML 真值
│   └── final/                 Vite + Vue 3 工程
└── _internal/                 ⬅ design 不碰
    ├── analysis/              Claude 分析用 PNG
    ├── bugs/                  bug 报告
    ├── frames/                ffmpeg 抽帧三层
    └── input/                 视频原料
\`\`\`

## 当前阶段
看 \`handoff/PROGRESS.md\`

## 给 design
首次:整段复制粘贴 \`handoff/KICKOFF.md\`
后续:发短指令 + \`handoff/tasks/T-B<N>.md\` raw URL

## 跑工程
\`\`\`bash
cd handoff/final && npm install && npm run dev
\`\`\`
EOF

cat > "$PROJ_DIR/handoff/preview/README.md" << EOF
# handoff/preview/ · HTML 真值

design 沙箱产出的 HTML 真值放这里(在 \`handoff/\` 下)。

link 相对路径:
\`\`\`html
<link rel="stylesheet" href="../final/src/styles/tokens.css" />
\`\`\`
EOF

echo ""
echo "==> ✅ projects/$NAME 脚手架完成"
echo ""
echo "目录结构:"
find "$PROJ_DIR" -maxdepth 3 -type d | sed "s|$PROJ_DIR|.|" | sort
echo ""
echo "下一步:"
echo "  1. 把视频 cp 到 projects/$NAME/_internal/input/"
echo "  2. 跑 ffmpeg 抽帧到 projects/$NAME/_internal/frames/raw/"
echo "  3. 用户筛选 / dedup 到 _internal/frames/selected/ + 拷高清到 _internal/analysis/png/"
echo "  4. 用户传风格参考图到 projects/$NAME/_internal/analysis/style-reference/"
echo "  5. 编辑 projects/$NAME/handoff/KICKOFF.md 填 {{...}} 占位符"
echo "  6. commit + push"
echo "  7. 给 design 沙箱复制粘贴 handoff/KICKOFF.md 的 \`\`\` 块整段"
