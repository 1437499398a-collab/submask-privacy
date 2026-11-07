#!/usr/bin/env bash
# SubMask 隐私政策 -> GitHub Pages 一键发布
# 凭证仅从环境变量 GITHUB_TOKEN 读取，绝不写入任何文件；用完请在 GitHub 后台 revoke。
# 用法：GITHUB_TOKEN='ghp_xxx' bash publish.sh
# 依赖：git + curl（本机/Git Bash 自带，无需 gh CLI）
set -euo pipefail

REPO_NAME="${REPO_NAME:-submask-privacy}"
BRANCH="main"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

# 令牌优先用环境变量；其次复用已登录的 gh CLI
if [ -z "${GITHUB_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
  GITHUB_TOKEN="$(gh auth token 2>/dev/null || true)"
fi
if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "X 缺少令牌。请设置环境变量 GITHUB_TOKEN（GitHub classic PAT，勾选 repo 权限）"
  echo "  Git Bash : export GITHUB_TOKEN='ghp_xxx' && bash publish.sh"
  echo "  PowerShell: \$env:GITHUB_TOKEN='ghp_xxx'; bash .\\publish.sh"
  exit 1
fi

api() {
  curl -sS -H "Authorization: Bearer ${GITHUB_TOKEN}" \
       -H "Accept: application/vnd.github+json" \
       -H "X-GitHub-Api-Version: 2022-11-28" "$@"
}

# 1) 校验令牌并取用户名
USER_LOGIN="$(api https://api.github.com/user | tr -d '\n' \
  | sed -n 's/.*"login"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
if [ -z "$USER_LOGIN" ]; then
  echo "X 令牌无效或权限不足，请检查 GITHUB_TOKEN（需 repo 权限）"; exit 1
fi
echo "OK GitHub 用户: ${USER_LOGIN}"

# 2) 建公开仓库（已存在返回 422，沿用即可）
echo "-> 创建仓库 ${USER_LOGIN}/${REPO_NAME} ..."
CODE="$(api -o /dev/null -w '%{http_code}' -X POST https://api.github.com/user/repos \
  -d "{\"name\":\"${REPO_NAME}\",\"private\":false,\"description\":\"SubMask privacy policy\"}" || true)"
case "$CODE" in
  201) echo "   已创建" ;;
  422) echo "   已存在，沿用" ;;
  *)   echo "   ! 建库返回 HTTP ${CODE}，继续尝试推送" ;;
esac

# 3) 推送（令牌只在本次命令内展开，不写入 .git/config）
echo "-> 推送内容 ..."
git branch -M "$BRANCH"
git remote remove origin 2>/dev/null || true
git push -f "https://${USER_LOGIN}:${GITHUB_TOKEN}@github.com/${USER_LOGIN}/${REPO_NAME}.git" "${BRANCH}:${BRANCH}"

# 4) 开启 Pages（main 分支 / 根目录）
echo "-> 开启 GitHub Pages ..."
PCODE="$(api -o /dev/null -w '%{http_code}' -X POST \
  "https://api.github.com/repos/${USER_LOGIN}/${REPO_NAME}/pages" \
  -d "{\"source\":{\"branch\":\"${BRANCH}\",\"path\":\"/\"}}" || true)"
if [ "$PCODE" = "201" ] || [ "$PCODE" = "204" ] || [ "$PCODE" = "409" ]; then
  echo "   Pages 已启用（409 = 先前已开启，正常）"
else
  echo "   ! Pages 返回 HTTP ${PCODE}，可到仓库 Settings -> Pages 手动选 main / (root)"
fi

URL="https://${USER_LOGIN}.github.io/${REPO_NAME}/"
echo ""
echo "完成！隐私政策链接："
echo "   ${URL}"
echo "（首次构建约 1-2 分钟，稍后浏览器打开确认）"
