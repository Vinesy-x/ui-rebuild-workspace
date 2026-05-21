#!/usr/bin/env bash
#
# import-design.sh — 把 Claude Design 沙箱产出同步到本地 projects/<name>/
#
# 用法:
#   ./scripts/import-design.sh <design-link> [project-name]
#
# 示例:
#   ./scripts/import-design.sh "https://api.anthropic.com/v1/design/h/XXXX"
#   ./scripts/import-design.sh "https://api.anthropic.com/v1/design/h/XXXX" projectF
#
# 不传 project-name 时,优先用 projects/ 下唯一的项目;有多个则报错让用户指定。
#
# 行为:
#   1. fetch design link → 拿到 tarball
#   2. 解到临时目录
#   3. 自动定位 tarball 里的 final/ 路径(支持 projecte/projectb/通用)
#   4. rsync final/ → projects/<name>/final/(保留 node_modules / dist / package-lock.json)
#   4.5. rsync 沙箱 preview/*.html → projects/<name>/preview/(HTML 真值)
#        如果沙箱根有 *.html(老版习惯)→ 也搬到 preview/ + sed 修 link 路径
#   5. 显示 git diff 概要,等用户 review 后手动 commit

set -euo pipefail

# ---------- 参数检查 ----------
if [ $# -lt 1 ]; then
  echo "Usage: $0 <design-link> [project-name]" >&2
  echo "Example: $0 \"https://api.anthropic.com/v1/design/h/XXXX\" projectE" >&2
  exit 1
fi

DESIGN_URL="$1"
PROJ_HINT="${2:-}"
WORKSPACE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORK_DIR="$(mktemp -d -t design-import.XXXXXX)"
TARBALL="$WORK_DIR/design.tar.gz"

# 清理临时目录
trap "rm -rf '$WORK_DIR'" EXIT

# ---------- 0. 定位本地项目 ----------
if [ -n "$PROJ_HINT" ]; then
  PROJ_DIR="$WORKSPACE_ROOT/projects/$PROJ_HINT"
else
  # 找 projects/ 下唯一项目
  PROJECTS=$(find "$WORKSPACE_ROOT/projects" -maxdepth 1 -mindepth 1 -type d 2>/dev/null)
  COUNT=$(echo "$PROJECTS" | grep -c . || true)
  if [ "$COUNT" -eq 1 ]; then
    PROJ_DIR="$PROJECTS"
  elif [ "$COUNT" -eq 0 ]; then
    echo "ERROR: 没有 projects/<name>/ 子目录。先跑 ./scripts/new-project.sh <name>" >&2
    exit 5
  else
    echo "ERROR: projects/ 下有多个项目,请指定:" >&2
    echo "$PROJECTS" | sed 's|.*/|  |' >&2
    echo "用法: $0 <design-link> <project-name>" >&2
    exit 6
  fi
fi

if [ ! -d "$PROJ_DIR" ]; then
  echo "ERROR: $PROJ_DIR 不存在" >&2
  exit 5
fi

PROJ_NAME="$(basename "$PROJ_DIR")"
# 2026-05 refactor v2:工程层 + HTML 真值都在 handoff/ 下(design 边界)
FINAL_DIR="$PROJ_DIR/handoff/final"
PREVIEW_DIR="$PROJ_DIR/handoff/preview"
mkdir -p "$PREVIEW_DIR"

echo "==> Fetching design tarball"
echo "    URL:     $DESIGN_URL"
echo "    Project: $PROJ_NAME"
echo "    Tmp:     $WORK_DIR"

# ---------- 1. fetch ----------
if ! curl -fLsS "$DESIGN_URL" -o "$TARBALL"; then
  echo "ERROR: curl failed to fetch design link" >&2
  exit 2
fi

if ! file "$TARBALL" | grep -q "gzip compressed"; then
  echo "ERROR: downloaded file is not a gzip tarball" >&2
  head -c 200 "$TARBALL" >&2
  exit 3
fi

SIZE=$(du -h "$TARBALL" | cut -f1)
echo "    Got: $SIZE"

# ---------- 2. 解包 ----------
echo "==> Extracting"
tar -xzf "$TARBALL" -C "$WORK_DIR"

# ---------- 3. 定位 final/(2026-05 refactor v2:design 沙箱端 handoff/final/)----------
SRC_FINAL=""
for candidate in \
  "$WORK_DIR/$PROJ_NAME/project/handoff/final" \
  "$WORK_DIR/$PROJ_NAME/project/final" \
  "$WORK_DIR/project/handoff/final" \
  "$WORK_DIR/project/final" \
  "$WORK_DIR/projects/$PROJ_NAME/handoff/final" \
  "$WORK_DIR/handoff/final" \
  "$WORK_DIR/final"
do
  if [ -d "$candidate" ]; then
    SRC_FINAL="$candidate"
    break
  fi
done

if [ -z "$SRC_FINAL" ]; then
  SRC_FINAL=$(find "$WORK_DIR" -type d -name "final" -maxdepth 6 | head -1)
fi

if [ -z "$SRC_FINAL" ] || [ ! -d "$SRC_FINAL" ]; then
  echo "ERROR: 沙箱 tarball 里找不到 final/ 目录" >&2
  find "$WORK_DIR" -maxdepth 4 -type d >&2
  exit 4
fi

echo "    Found final/: ${SRC_FINAL#$WORK_DIR/}"

# ---------- 4. rsync final/ ----------
# 注意:design 沙箱通常只动 src/ 下的 .vue/.ts/.json,不带 Vite scaffold。
# rsync --delete 会把 final/ 根的 package.json / tsconfig.json / vite.config.ts /
# index.html / README.md 全部 wipe(已踩坑 1 次,2026-05-21)。
# 解法:--exclude 把 Vite scaffold 全列上,设计沙箱即使没带这些文件也不会误删。
echo "==> Syncing final/ to $FINAL_DIR/"
mkdir -p "$FINAL_DIR"
rsync -a --delete \
  --exclude='node_modules/' \
  --exclude='dist/' \
  --exclude='.vite/' \
  --exclude='package-lock.json' \
  --exclude='package.json' \
  --exclude='tsconfig.json' \
  --exclude='tsconfig.*.json' \
  --exclude='vite.config.ts' \
  --exclude='vite.config.js' \
  --exclude='index.html' \
  --exclude='README.md' \
  --exclude='.gitignore' \
  --exclude='env.d.ts' \
  "$SRC_FINAL/" "$FINAL_DIR/"

# ---------- 4.5. rsync HTML 真值 to preview/ ----------
SRC_PROJECT_ROOT="$(dirname "$SRC_FINAL")"
SRC_PREVIEW="$SRC_PROJECT_ROOT/preview"

# 优先用沙箱 preview/(新约定)
if [ -d "$SRC_PREVIEW" ]; then
  echo "==> Syncing preview/ to $PREVIEW_DIR/ (new convention)"
  rsync -a --delete \
    --exclude='node_modules/' \
    "$SRC_PREVIEW/" "$PREVIEW_DIR/"
fi

# 兼容老版习惯:沙箱根 *.html → preview/ + 修 link 路径
if ls "$SRC_PROJECT_ROOT"/*.html >/dev/null 2>&1; then
  HTML_COUNT=$(ls "$SRC_PROJECT_ROOT"/*.html | wc -l | tr -d ' ')
  echo "==> 兼容老版:沙箱根 $HTML_COUNT 个 *.html 搬到 preview/"
  rsync -a "$SRC_PROJECT_ROOT"/*.html "$PREVIEW_DIR/"
  # 修相对路径:href="final/..." → href="../final/..."
  # idempotent:先把过深的兜底回滚,再加 ../
  for html in "$PREVIEW_DIR"/*.html; do
    sed -i.bak -E '
      s|href="\.\./\.\./final/|href="../final/|g
      s|href="final/|href="../final/|g
      s|src="\.\./\.\./final/|src="../final/|g
      s|src="final/|src="../final/|g
    ' "$html"
    rm -f "$html.bak"
  done
fi

# ---------- 5. 总结 ----------
echo ""
echo "==> Done. Changes:"
cd "$WORKSPACE_ROOT"
CHANGED_FILES=$(git status --porcelain "projects/$PROJ_NAME/" 2>/dev/null || true)
if [ -z "$CHANGED_FILES" ]; then
  echo "    (no changes — local already in sync)"
else
  echo "$CHANGED_FILES" | head -30
  CHANGED=$(echo "$CHANGED_FILES" | wc -l | tr -d ' ')
  if [ "$CHANGED" -gt 30 ]; then
    echo "    ... +$((CHANGED - 30)) more"
  fi
fi

echo ""
echo "Next steps:"
echo "  1. Review:  git diff projects/$PROJ_NAME/"
echo "  2. Run it:  cd projects/$PROJ_NAME/handoff/final && npm install && npm run dev"
echo "  3. Commit:  git add projects/$PROJ_NAME/ && git commit -m 'design: import <task>'"
