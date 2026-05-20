#!/usr/bin/env bash
#
# new-project.sh — 在 workspace 下新建项目脚手架
#
# 用法:
#   ./scripts/new-project.sh <project-name>
#
# 示例:
#   ./scripts/new-project.sh projectF
#
# 行为:
#   1. mkdir projects/<name>/ + 8 个标准子目录
#   2. cp docs/KICKOFF_TEMPLATE.md → projects/<name>/KICKOFF.md
#   3. cp docs/PROGRESS_TEMPLATE.md → projects/<name>/PROGRESS.md
#   4. 初始化 projects/<name>/README.md + preview/README.md
#      (SYNC_PROTOCOL 不复制到 design-brief 下,design 直接拉 workspace docs/SYNC_PROTOCOL.md)
#   5. 输出下一步操作 checklist

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

echo "==> 新建 projects/$NAME/"
mkdir -p "$PROJ_DIR"/{design-brief/{analysis,analysis-extras,flows,style-reference},preview,final/src/{views,components,data,stores,styles},frames/{raw,dedup,selected},input,tasks,bugs}

# 复制模板
echo "==> 初始化 KICKOFF / PROGRESS / README"
cp "$WORKSPACE_ROOT/docs/KICKOFF_TEMPLATE.md" "$PROJ_DIR/KICKOFF.md"
cp "$WORKSPACE_ROOT/docs/PROGRESS_TEMPLATE.md" "$PROJ_DIR/PROGRESS.md"

cat > "$PROJ_DIR/README.md" << EOF
# $NAME

> UI 重建项目,在 ui-rebuild-workspace 下。

## 当前阶段
看 PROGRESS.md

## 给 design
看 KICKOFF.md(首次启动)+ tasks/T-*.md(每屏 task)

## 跑工程
\`\`\`bash
cd final && npm install && npm run dev
\`\`\`
EOF

cat > "$PROJ_DIR/preview/README.md" << EOF
# preview/ · HTML 真值

design 沙箱产出的 HTML 真值放这里(不要放沙箱根 / 项目根)。

link 相对路径:
\`\`\`html
<link rel="stylesheet" href="../final/src/styles/tokens.css" />
\`\`\`
EOF

# SYNC_PROTOCOL 不放 design-brief 下,design 直接拉 workspace 级 docs/SYNC_PROTOCOL.md

echo ""
echo "==> ✅ projects/$NAME 脚手架完成"
echo ""
echo "目录结构:"
find "$PROJ_DIR" -maxdepth 3 -type d | sed "s|$PROJ_DIR|.|" | sort
echo ""
echo "下一步:"
echo "  1. 把视频 cp 到 projects/$NAME/input/"
echo "  2. 跑 ffmpeg 抽帧到 projects/$NAME/frames/raw/"
echo "  3. 用户筛选 / dedup 到 frames/selected/ + 拷高清到 design-brief/analysis/"
echo "  4. 用户传风格参考图到 projects/$NAME/design-brief/style-reference/"
echo "  5. 编辑 projects/$NAME/KICKOFF.md 填 {{...}} 占位符"
echo "  6. commit + push"
echo "  7. 给 design 沙箱复制粘贴 KICKOFF.md 的 \`\`\` 块整段"
