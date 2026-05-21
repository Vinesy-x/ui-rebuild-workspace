#!/usr/bin/env bash
#
# new-project.sh — 在 workspace 下新建项目脚手架(2026-05 refactor v2 · handoff/ 强隔离)
#
# 用法:
#   ./scripts/new-project.sh <project-name>
#
# 行为:
#   1. mkdir projects/<name>/{handoff/, _internal/, README.md}
#      handoff/   = design 边界 · spec/preview/final/tasks/PROGRESS/KICKOFF
#      _internal/ = user 内部 · bugs/input/frames/analysis · design 不碰
#   2. cp 2 个模板:KICKOFF / PROGRESS → handoff/(audit 协议合并入 PROGRESS 末尾段)
#   3. 占位符 sed 替换({{name}} → 实际项目名 · {{repo}} / {{owner}} 留给用户填)
#   4. 初始化 README.md(2 区结构说明) + handoff/preview/README.md
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

# Cross-platform sed -i wrapper(BSD vs GNU)
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)        # GNU sed
else
  SED_INPLACE=(sed -i '')     # BSD sed (macOS)
fi

# ---------- 1. mkdir 双区结构(一次 mkdir -p · brace expansion)----------
echo "==> 新建 projects/$NAME/(handoff + _internal 双区结构)"
mkdir -p "$PROJ_DIR"/{\
handoff/{spec,preview,final/src/{views,components,data,stores,styles,types,utils},tasks/archive},\
_internal/{analysis/{png,extras,style-reference},bugs/archive,frames/{raw,dedup,selected},input}\
}

# ---------- 2. cp 3 模板 ----------
echo "==> 初始化 KICKOFF / PROGRESS(audit 协议在 PROGRESS 末尾段)"
for tmpl_pair in \
  "KICKOFF_TEMPLATE.md:KICKOFF.md" \
  "PROGRESS_TEMPLATE.md:PROGRESS.md"
do
  src="${tmpl_pair%%:*}"
  dst="${tmpl_pair##*:}"
  if [ -f "$WORKSPACE_ROOT/docs/$src" ]; then
    cp "$WORKSPACE_ROOT/docs/$src" "$PROJ_DIR/handoff/$dst"
    # 把 {{name}} 替换成实际项目名(其他占位符 {{repo}} {{owner}} {{game}} 留给用户填)
    "${SED_INPLACE[@]}" "s|{{name}}|$NAME|g" "$PROJ_DIR/handoff/$dst"
  else
    echo "WARN: docs/$src 模板不存在,跳过" >&2
  fi
done

# ---------- 3. README ----------
cat > "$PROJ_DIR/README.md" << EOF
# $NAME

> UI 重建项目,在 ui-rebuild-workspace 下。

## 目录边界(handoff / _internal 强隔离)

\`\`\`
$NAME/
├── README.md                  ← 本文件
├── handoff/                   ⭐ design 唯一边界
│   ├── PROGRESS.md            ⭐ 每次必拉
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

cat > "$PROJ_DIR/handoff/preview/README.md" << 'EOF'
# handoff/preview/ · HTML 真值

design 沙箱产出的 HTML 真值放这里(在 `handoff/` 下)。

## link 相对路径

```html
<link rel="stylesheet" href="../final/src/styles/tokens.css" />
```

从 `handoff/preview/` 引用 `handoff/final/`,用 `../final/`(兄弟目录)。
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
echo "  5. 编辑 projects/$NAME/handoff/KICKOFF.md 填 {{repo}} / {{owner}} / {{游戏名}} 等"
echo "  6. 编辑 projects/$NAME/handoff/PROGRESS.md 填项目快照(末尾的 audit 协议段已通用,不用改)"
echo "  7. commit + push"
echo "  8. 给 design 沙箱复制粘贴 handoff/KICKOFF.md 的 \`\`\` 块整段"
