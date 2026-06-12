# CLIProxyAPI-Pro 自定义镜像

这是一个基于 `sfun/cliproxyapi-pro:latest` 的自定义 Docker 镜像，解决了首次部署时缺少 `config.yaml` 配置文件的问题。

## 功能

- 自动检测并创建默认的 `config.yaml` 配置文件
- 保留原始镜像的所有功能
- 适合在 Render、Railway 等 PaaS 平台部署

## 构建镜像

```bash
cd ~/cliproxyapi-custom
docker build -t cliproxyapi-pro-custom .
```

## 推送到 Docker Hub（可选）

```bash
# 登录 Docker Hub
docker login

# 标记镜像
docker tag cliproxyapi-pro-custom your-dockerhub-username/cliproxyapi-pro-custom:latest

# 推送镜像
docker push your-dockerhub-username/cliproxyapi-pro-custom:latest
```

## 本地测试

```bash
docker run -d -p 8317:8317 --name cliproxyapi-test cliproxyapi-pro-custom
```

访问 http://localhost:8317 查看管理面板。

## 在 Render 上部署

1. 推送镜像到 Docker Hub（或其他容器仓库）
2. 在 Render 创建 Web Service
3. **Image URL** 填写：`your-dockerhub-username/cliproxyapi-pro-custom:latest`
4. **Docker Command** 留空（使用默认 ENTRYPOINT）
5. **Environment Variables**（可选）：
   - `MANAGEMENT_PASSWORD`: 管理面板密码
6. **Health Check Path**: `/healthz`

## 环境变量配置

可以通过环境变量进一步配置：

- `MANAGEMENT_PASSWORD`: 管理面板密码
- `USAGE_SERVICE_ENABLED`: 启用 usage 统计服务（默认：true）
- `WEBDAV_URL`: WebDAV 备份地址
- `WEBDAV_USERNAME`: WebDAV 用户名
- `WEBDAV_PASSWORD`: WebDAV 密码
- `KOMARI_SERVER`: Komari agent 服务器地址
- `KOMARI_SECRET`: Komari agent 密钥

## 目录结构

```
cliproxyapi-custom/
├── Dockerfile              # Docker 镜像构建文件
├── custom-entrypoint.sh    # 自定义启动脚本
└── README.md              # 说明文档
```

## 默认配置

启动时会自动创建以下默认配置：

```yaml
server:
  port: 8317
  host: 0.0.0.0

usage-statistics-enabled: true

remote-management:
  panel-github-repository: https://github.com/ssfun/CLIProxyAPI-Pro

log:
  level: info
```

## 数据持久化

建议在生产环境中挂载 `/CLIProxyAPI` 目录以持久化：
- 配置文件
- Usage 统计数据
- 账号巡检记录
- 配额缓存

Docker 命令示例：
```bash
docker run -d \
  -p 8317:8317 \
  -v /path/to/data:/CLIProxyAPI \
  --name cliproxyapi \
  cliproxyapi-pro-custom
```

## 故障排查

查看日志：
```bash
docker logs cliproxyapi-test
```

进入容器：
```bash
docker exec -it cliproxyapi-test sh
```

检查配置文件：
```bash
docker exec cliproxyapi-test cat /CLIProxyAPI/config.yaml
```

## 许可证

本自定义镜像基于 [ssfun/CLIProxyAPI-Pro](https://github.com/ssfun/CLIProxyAPI-Pro) 项目构建。
