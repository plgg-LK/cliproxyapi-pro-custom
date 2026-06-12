# 🚀 部署指南

## 步骤 1：在 GitHub 创建仓库

1. 访问 https://github.com/new
2. **Repository name**: `cliproxyapi-pro-custom`
3. **Description**: `Custom CLIProxyAPI-Pro Docker image with auto-config`
4. 选择 **Public**
5. **不要**初始化 README、.gitignore 或 license（因为我们已经有了）
6. 点击 **Create repository**

## 步骤 2：推送代码到 GitHub

在终端执行以下命令：

```bash
cd ~/cliproxyapi-custom

# 添加远程仓库（替换 YOUR_GITHUB_USERNAME）
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/cliproxyapi-pro-custom.git

# 推送代码
git push -u origin main
```

## 步骤 3：配置 Docker Hub Secrets

1. 访问 https://hub.docker.com/settings/security
2. 点击 **New Access Token**
3. Description: `GitHub Actions`
4. Access permissions: `Read, Write, Delete`
5. 生成并**复制 token**

然后在 GitHub 仓库设置 Secrets：

1. 访问你的仓库 `https://github.com/YOUR_GITHUB_USERNAME/cliproxyapi-pro-custom`
2. 点击 **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret**，添加两个 secrets：
   - Name: `DOCKERHUB_USERNAME`，Value: 你的 Docker Hub 用户名
   - Name: `DOCKERHUB_TOKEN`，Value: 刚才生成的 access token

## 步骤 4：触发自动构建

推送代码后，GitHub Actions 会自动构建镜像。你也可以手动触发：

1. 在 GitHub 仓库点击 **Actions** 标签
2. 选择 **Build and Push Docker Image**
3. 点击 **Run workflow** → **Run workflow**

## 步骤 5：在 Render 使用自定义镜像

构建完成后（大约 5-10 分钟），在 Render 的 Web Service 配置：

- **Image URL**: `YOUR_DOCKERHUB_USERNAME/cliproxyapi-pro-custom:latest`
- **Docker Command**: **留空**
- **Health Check Path**: `/healthz`
- **Environment Variables**（可选）:
  - `MANAGEMENT_PASSWORD`: 你的管理面板密码

## 📦 本地命令汇总

```bash
# 1. 进入项目目录
cd ~/cliproxyapi-custom

# 2. 添加远程仓库（替换 YOUR_GITHUB_USERNAME）
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/cliproxyapi-pro-custom.git

# 3. 推送到 GitHub
git push -u origin main
```

## 🔍 查看构建状态

- **GitHub Actions**: `https://github.com/YOUR_GITHUB_USERNAME/cliproxyapi-pro-custom/actions`
- **Docker Hub**: `https://hub.docker.com/r/YOUR_DOCKERHUB_USERNAME/cliproxyapi-pro-custom`

## ✅ 验证部署

构建完成后，可以本地测试：

```bash
docker pull YOUR_DOCKERHUB_USERNAME/cliproxyapi-pro-custom:latest
docker run -d -p 8317:8317 --name test YOUR_DOCKERHUB_USERNAME/cliproxyapi-pro-custom:latest
```

访问 http://localhost:8317 应该能看到管理面板。

## 🛠️ 故障排查

### GitHub Actions 构建失败

检查 Actions 日志，常见问题：
- Docker Hub credentials 配置错误
- Secrets 名称拼写错误

### Render 部署失败

- 确保 Docker Hub 镜像是 public 或 Render 有访问权限
- 检查 Image URL 是否正确
- 查看 Render 部署日志

## 📝 后续更新

修改代码后：

```bash
cd ~/cliproxyapi-custom
git add .
git commit -m "描述你的更改"
git push
```

GitHub Actions 会自动构建并推送新镜像。
