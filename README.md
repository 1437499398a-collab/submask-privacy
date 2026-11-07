# SubMask 隐私政策 · GitHub Pages 源文件

> ✅ **正式线上链接（2026-11-07 起）**：`https://1437499398a-collab.github.io/submask-privacy/`
> 仓库：`github.com/1437499398a-collab/submask-privacy` · 已验证 HTTP 200
> WorkBuddy 临时托管链接已下线，勿再使用。

本目录是 GitHub Pages 的源仓库，生成可供
**Google Play** 与 **国内应用商店（应用宝 / 华为 / 小米 / OPPO / vivo）**
填写的隐私政策链接。

## 文件
- `index.html` — 隐私政策页面（即 `store-listing/privacy_policy.html` 的发布版）
- `.nojekyll` — 关闭 Jekyll 处理，确保原样静态托管
- `publish.sh` — 一键发布脚本（建仓库 → 推送 → 开 Pages），**无需 gh CLI**

## 前置：生成一次访问令牌（PAT）
GitHub 网页右上角头像 → **Settings** → 左侧最底 **Developer settings** →
**Personal access tokens** → **Tokens (classic)** → **Generate new token (classic)**：
- Note 随便填，如 `submask-pages`
- Expiration 建议 `7 days`（够用即可）
- 勾选 **`repo`**（建仓库+推送必需，`public_repo` 不够）
- 生成后复制 `ghp_xxx...`，**用完立刻在后台 revoke**

> 令牌只通过环境变量传入脚本，不写入任何文件。本机当前未安装 `gh`、也未存任何凭证。

## 方式 A：一键脚本（推荐）
```bash
cd store-listing/github-pages
export GITHUB_TOKEN='ghp_你的令牌'
bash publish.sh
```
脚本自动：校验令牌 → 建公开仓库 `submask-privacy` → 推送 `main` → 开启 Pages → 回显链接。
最终地址：`https://<你的GitHub用户名>.github.io/submask-privacy/`

## 方式 B：纯网页操作（完全不碰令牌）
1. GitHub 网页新建公开仓库 `submask-privacy`（不要勾选初始化任何文件）
2. 进入仓库 → **Add file → Upload files**，上传 `index.html`（`.nojekyll` 可一并传）
3. **Settings → Pages** → Source 选 `main` / `(root)` → Save
4. 等 1–2 分钟访问 `https://<用户名>.github.io/submask-privacy/`

## 方式 C：纯 git（已装 gh 或已配凭证时）
```bash
gh repo create submask-privacy --public --source=. --remote=origin --push
gh api -X POST /repos/<用户名>/submask-privacy/pages -f 'source[branch]=main' -f 'source[path]=/'
```

## 注意
- 包名：`com.submask.floating`
- 联系邮箱：`1437499398@qq.com`
- 政策主张：不申请 INTERNET 权限、零数据采集、无第三方 SDK
