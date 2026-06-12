# 基于官方 CLIProxyAPI-Pro 镜像
FROM sfun/cliproxyapi-pro:latest

# 下载最新的管理面板
ARG MANAGEMENT_VERSION=v7.1.68-pro
RUN wget -O /CLIProxyAPI/management.html \
    "https://github.com/ssfun/CLIProxyAPI-Pro/releases/download/${MANAGEMENT_VERSION}/management.html" || \
    echo "Warning: Failed to download management.html"

# 创建自定义启动脚本
COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# 使用自定义启动脚本
ENTRYPOINT ["/custom-entrypoint.sh"]
