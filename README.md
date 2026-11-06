# SubMask 隐私政策 · GitHub Pages 源文件

本仓库用于把 SubMask 的隐私政策托管到 GitHub Pages，生成可供
**Google Play** 与 **国内应用商店（应用宝 / 华为 / 小米 / OPPO / vivo）**
填写的隐私政策链接。

## 文件
- `index.html` — 隐私政策页面（即 `store-listing/privacy_policy.html` 的发布版）
- `.nojekyll` — 关闭 Jekyll 处理，确保原样静态托管

## 方式 A：在本机用 gh 一键发布（需已 `gh auth login`）
```bash
cd store-listing/github-pages
gh repo create submask-privacy --public --source=. --remote=origin --push
gh api -X POST /repos/<你的GitHub用户名>/submask-privacy/pages \
  -f 'source[branch]=main' -f 'source[path]=/'
```
发布后约 1 分钟即可访问：
`https://<你的GitHub用户名>.github.io/submask-privacy/`

## 方式 B：纯 git 命令
```bash
git remote add origin https://github.com/<你的GitHub用户名>/submask-privacy.git
git branch -M main
git push -u origin main
# 然后到仓库 Settings → Pages，Source 选「main / (root)」保存
```

## 注意
- 包名：`com.submask.floating`
- 联系邮箱：`1437499398@qq.com`
- 政策主张：不申请 INTERNET 权限、零数据采集、无第三方 SDK
