# 基于官方 CLIProxyAPI-Pro 镜像
FROM sfun/cliproxyapi-pro:latest

# 创建自定义启动脚本
COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# 使用自定义启动脚本
ENTRYPOINT ["/custom-entrypoint.sh"]
