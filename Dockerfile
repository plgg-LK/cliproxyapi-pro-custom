# 基于官方 CLIProxyAPI-Pro 镜像
FROM sfun/cliproxyapi-pro:latest

# 下载最新的 Pro 管理面板（包含账号巡检功能）
# 使用 latest release 确保获取最新版本
RUN apk add --no-cache curl && \
    LATEST_VERSION=$(curl -s https://api.github.com/repos/ssfun/CLIProxyAPI-Pro/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/') && \
    echo "Downloading management.html version: $LATEST_VERSION" && \
    curl -L -o /CLIProxyAPI/management.html \
    "https://github.com/ssfun/CLIProxyAPI-Pro/releases/download/${LATEST_VERSION}/management.html" || \
    echo "Warning: Failed to download management.html"

# 创建自定义启动脚本
COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# 使用自定义启动脚本
ENTRYPOINT ["/custom-entrypoint.sh"]
