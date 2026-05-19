#!/usr/bin/env bash
#
# import-design.sh — 把 Claude Design 沙箱里的 final/ 工程同步到本地 projectB/final/
#
# 用法:
#   ./scripts/import-design.sh <design-link>
#
# 示例:
#   ./scripts/import-design.sh "https://api.anthropic.com/v1/design/h/g60YM4PxNTDNfIKFIWEllQ"
#
# 行为:
#   1. fetch design link → 拿到 tarball(design 沙箱整个工程的 snapshot)
#   2. 解到临时目录
#   3. 自动定位 tarball 里的 final/ 路径(通常是 projectb/project/final/)
#   4. rsync 同步到本地 final/(保留你本地的 node_modules / dist / package-lock.json)
#   5. 显示 git diff 概要,等你 review 后手动 commit

set -euo pipefail

# ---------- 参数检查 ----------
if [ $# -lt 1 ]; then
  echo "Usage: $0 <design-link>" >&2
  echo "Example: $0 \"https://api.anthropic.com/v1/design/h/XXXX\"" >&2
  exit 1
fi

DESIGN_URL="$1"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FINAL_DIR="$REPO_ROOT/final"
WORK_DIR="$(mktemp -d -t design-import.XXXXXX)"
TARBALL="$WORK_DIR/design.tar.gz"

# 清理临时目录 — 脚本退出时自动删
trap "rm -rf '$WORK_DIR'" EXIT

echo "==> Fetching design tarball"
echo "    URL: $DESIGN_URL"
echo "    Tmp: $WORK_DIR"

# ---------- 1. fetch ----------
# -L follow redirects, -f fail on HTTP errors, -sS silent but show errors
if ! curl -fLsS "$DESIGN_URL" -o "$TARBALL"; then
  echo "ERROR: curl failed to fetch design link" >&2
  exit 2
fi

# 校验是 gzip(design link 实际返回 gzip 二进制)
if ! file "$TARBALL" | grep -q "gzip compressed"; then
  echo "ERROR: downloaded file is not a gzip tarball" >&2
  echo "First 200 bytes:" >&2
  head -c 200 "$TARBALL" >&2
  echo "" >&2
  exit 3
fi

SIZE=$(du -h "$TARBALL" | cut -f1)
echo "    Got: $SIZE"

# ---------- 2. 解包 ----------
echo "==> Extracting"
tar -xzf "$TARBALL" -C "$WORK_DIR"

# ---------- 3. 定位 final/ ----------
# 已知路径(从我之前 webfetch 的 tarball 看到的)是 projectb/project/final/
# 用 find fallback 以防 design 改了打包结构
SRC_FINAL=""
for candidate in \
  "$WORK_DIR/projectb/project/final" \
  "$WORK_DIR/project/final" \
  "$WORK_DIR/final"
do
  if [ -d "$candidate" ]; then
    SRC_FINAL="$candidate"
    break
  fi
done

# fallback:深搜
if [ -z "$SRC_FINAL" ]; then
  SRC_FINAL=$(find "$WORK_DIR" -type d -name "final" -maxdepth 6 | head -1)
fi

if [ -z "$SRC_FINAL" ] || [ ! -d "$SRC_FINAL" ]; then
  echo "ERROR: could not find final/ directory in extracted tarball" >&2
  echo "Tarball structure:" >&2
  find "$WORK_DIR" -maxdepth 4 -type d >&2
  exit 4
fi

echo "    Found: ${SRC_FINAL#$WORK_DIR/}"

# ---------- 4. rsync 同步 ----------
# --delete:design 删的文件本地也删(让本地跟 design 完全一致)
# --exclude:保留本地的 node_modules / dist / package-lock.json(install 是本地行为)
echo "==> Syncing to $FINAL_DIR/"
mkdir -p "$FINAL_DIR"
rsync -a --delete \
  --exclude='node_modules/' \
  --exclude='dist/' \
  --exclude='.vite/' \
  --exclude='package-lock.json' \
  "$SRC_FINAL/" "$FINAL_DIR/"

# ---------- 5. 总结 + 提示 ----------
echo ""
echo "==> Done. Changes:"
cd "$REPO_ROOT"
if git diff --quiet final/ && git diff --cached --quiet final/ && [ -z "$(git status --porcelain final/)" ]; then
  echo "    (no changes — local final/ was already in sync)"
else
  git status --short final/ | head -30
  CHANGED=$(git status --porcelain final/ | wc -l | tr -d ' ')
  if [ "$CHANGED" -gt 30 ]; then
    echo "    ... +$((CHANGED - 30)) more"
  fi
fi

echo ""
echo "Next steps:"
echo "  1. Review:  git diff final/"
echo "  2. Run it:  cd final && npm install && npm run dev"
echo "  3. Commit:  git add final/ && git commit -m 'design: import <task>'"
