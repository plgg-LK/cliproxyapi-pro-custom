# 🔧 配置 GitHub Token 避免 429 限流

## 问题说明

Render 使用共享 IP，访问 GitHub API 容易遇到 429 限流，导致 management.html 下载失败，回退到 upstream 原始版本（缺少账号巡检功能）。

## ✅ 解决方案

在 Render 的 Environment Variables 中添加 GitHub Token：

### 1. 创建 GitHub Personal Access Token

1. 访问 https://github.com/settings/tokens
2. 点击 **Generate new token** → **Generate new token (classic)**
3. 设置：
   - **Note**: `CLIProxyAPI Management Download`
   - **Expiration**: 选择过期时间（建议 No expiration）
   - **Select scopes**: **只需勾选 `public_repo`**（读取公开仓库）
4. 点击 **Generate token**
5. **立即复制 token**（只显示一次）

### 2. 在 Render 配置环境变量

在你的 Render Web Service → **Environment** 标签添加：

```
GITSTORE_GIT_TOKEN=ghp_your_token_here
```

或者也可以使用：
```
GITHUB_TOKEN=ghp_your_token_here
```

**两个变量都支持**，优先使用 `GITSTORE_GIT_TOKEN`（这样既能用于 Git 存储，也能用于下载管理面板）。

### 3. 重新部署

1. 保存环境变量后
2. 点击 **Manual Deploy** → **Deploy latest commit**
3. 查看部署日志，应该看到：
   ```
   ✓ 检测到 GitHub Token，使用认证下载
   最新版本: v7.1.68-pro
   ✓ Pro 管理面板下载成功
   ```

## 🔍 验证

部署成功后，访问管理面板：
- 左侧菜单应该会出现 **"账号巡检"** 选项
- 点击进入应该能看到账号巡检配置界面

## 📝 完整的 Render 环境变量配置

```bash
# GitHub Token（避免 API 限流）
GITSTORE_GIT_TOKEN=ghp_your_token_here

# Git 存储配置
GITSTORE_GIT_REPO=https://github.com/你的用户名/你的配置仓库.git
GITSTORE_GIT_BRANCH=main
GITSTORE_GIT_USERNAME=你的GitHub用户名

# 管理面板密码
MANAGEMENT_PASSWORD=你的管理密码

# 端口配置
PORT=8317
```

## ⚠️ 注意事项

1. **Token 权限最小化**：只勾选 `public_repo`，不需要其他权限
2. **Token 安全**：不要在公开场合分享你的 token
3. **Token 过期**：建议设置较长的过期时间或 No expiration，避免频繁更新
4. **API 限流**：使用 Token 后，GitHub API 限流从 60 次/小时提升到 5000 次/小时

## 🚀 其他优化

如果仍然遇到问题，可以考虑：
1. 使用 Cloudflare Workers 代理 GitHub API
2. 在构建镜像时预先下载 management.html（已在 Dockerfile 中实现）
3. 使用国内镜像源（如 ghproxy）

但最简单有效的方案就是配置 `GITSTORE_GIT_TOKEN`。
