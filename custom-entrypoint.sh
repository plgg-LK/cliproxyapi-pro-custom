#!/bin/sh
set -e

echo "=========================================="
echo "CLIProxyAPI-Pro Custom Startup"
echo "=========================================="

# 打印调试信息
echo "当前用户: $(whoami)"
echo "当前目录: $(pwd)"
echo "检查 /CLIProxyAPI 目录..."

# 创建必要的目录
mkdir -p /CLIProxyAPI
echo "✓ /CLIProxyAPI 目录已创建"

# 检查目录权限
ls -la /CLIProxyAPI || echo "无法列出目录"

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

# 远程管理面板仓库（重要：必须指向 Pro 仓库才能获取完整功能）
remote-management:
  panel-github-repository: https://github.com/ssfun/CLIProxyAPI-Pro
  auto-update: true

# 日志配置
log:
  level: info

# 其他配置可以通过管理面板添加
EOF
    echo "✓ 默认配置文件已创建"

    # 验证文件是否真的创建成功
    if [ -f /CLIProxyAPI/config.yaml ]; then
        echo "✓ 配置文件验证成功"
        echo "文件大小: $(wc -c < /CLIProxyAPI/config.yaml) bytes"
        echo "文件权限: $(ls -l /CLIProxyAPI/config.yaml)"
    else
        echo "✗ 错误：配置文件创建失败！"
        exit 1
    fi
else
    echo "✓ 配置文件已存在，跳过创建"
    echo "文件大小: $(wc -c < /CLIProxyAPI/config.yaml) bytes"
fi

# 确保 usage 目录存在
mkdir -p /CLIProxyAPI/usage
echo "✓ /CLIProxyAPI/usage 目录已创建"

echo "=========================================="
echo "启动 CLIProxyAPI-Pro..."
echo "=========================================="

# 调用原始的 entrypoint 脚本
exec /CLIProxyAPI/entrypoint.sh
