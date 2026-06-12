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
echo "下载最新的 Pro 管理面板..."
echo "=========================================="

# 下载最新的 Pro 管理面板（支持 GitHub Token 避免 429）
GITHUB_TOKEN="${GITSTORE_GIT_TOKEN:-${GITHUB_TOKEN:-}}"
MANAGEMENT_HTML_PATH="/CLIProxyAPI/management.html"

if [ -n "$GITHUB_TOKEN" ]; then
    echo "✓ 检测到 GitHub Token，使用认证下载"
    LATEST_VERSION=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" \
        https://api.github.com/repos/ssfun/CLIProxyAPI-Pro/releases/latest | \
        grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
else
    echo "⚠ 未配置 GitHub Token，可能遇到 API 限流"
    LATEST_VERSION=$(curl -s https://api.github.com/repos/ssfun/CLIProxyAPI-Pro/releases/latest | \
        grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
fi

if [ -n "$LATEST_VERSION" ] && [ "$LATEST_VERSION" != "null" ]; then
    echo "最新版本: $LATEST_VERSION"

    # 删除旧的 management.html（如果存在）
    rm -f "$MANAGEMENT_HTML_PATH"

    if [ -n "$GITHUB_TOKEN" ]; then
        curl -L -H "Authorization: Bearer $GITHUB_TOKEN" \
            -o "$MANAGEMENT_HTML_PATH" \
            "https://github.com/ssfun/CLIProxyAPI-Pro/releases/download/${LATEST_VERSION}/management.html" && \
        echo "✓ Pro 管理面板下载成功" || \
        echo "✗ 管理面板下载失败，将使用应用内置版本"
    else
        curl -L -o "$MANAGEMENT_HTML_PATH" \
            "https://github.com/ssfun/CLIProxyAPI-Pro/releases/download/${LATEST_VERSION}/management.html" && \
        echo "✓ Pro 管理面板下载成功" || \
        echo "✗ 管理面板下载失败，将使用应用内置版本"
    fi

    # 验证下载的文件
    if [ -f "$MANAGEMENT_HTML_PATH" ]; then
        FILE_SIZE=$(wc -c < "$MANAGEMENT_HTML_PATH")
        echo "✓ 管理面板文件大小: $FILE_SIZE bytes"

        # 检查是否包含 Pro 功能标识
        if grep -q "账号巡检\|account-inspection" "$MANAGEMENT_HTML_PATH"; then
            echo "✓ 确认：包含 Pro 功能（账号巡检）"
        else
            echo "⚠ 警告：未检测到账号巡检功能，可能是旧版本"
        fi
    else
        echo "✗ 管理面板文件不存在"
    fi
else
    echo "✗ 无法获取最新版本信息，将使用应用内置版本"
fi

echo "=========================================="
echo "启动 CLIProxyAPI-Pro..."
echo "=========================================="

# 调用原始的 entrypoint 脚本
exec /CLIProxyAPI/entrypoint.sh
