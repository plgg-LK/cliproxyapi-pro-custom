#!/bin/sh

echo "=========================================="
echo "CLIProxyAPI-Pro Custom Startup"
echo "=========================================="

# 创建必要的目录
mkdir -p /CLIProxyAPI

# 检查配置文件是否存在，不存在则创建默认配置
if [ ! -f /CLIProxyAPI/config.yaml ]; then
    echo "配置文件不存在，创建默认 config.yaml..."
    cat > /CLIProxyAPI/config.yaml << 'EOF'
# CLIProxyAPI-Pro 配置文件
server:
  port: 8317
  host: 0.0.0.0

# Usage statistics 必须启用（Pro 版本需要）
usage-statistics-enabled: true

# 远程管理面板仓库
remote-management:
  panel-github-repository: https://github.com/ssfun/CLIProxyAPI-Pro

# 日志配置
log:
  level: info

# 其他配置可以通过管理面板添加
EOF
    echo "✓ 默认配置文件已创建"
else
    echo "✓ 配置文件已存在，跳过创建"
fi

# 确保 usage 目录存在
mkdir -p /CLIProxyAPI/usage

echo "=========================================="
echo "启动 CLIProxyAPI-Pro..."
echo "=========================================="

# 调用原始的 entrypoint 脚本
exec /CLIProxyAPI/entrypoint.sh
