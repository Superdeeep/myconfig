#!/bin/bash

# 更新包管理器
echo "更新包管理器..."
if ! apt update; then
    echo "更新包管理器失败，请检查网络连接或软件源设置。"
    exit 1
fi

# 安装 WireGuard 和 UFW
echo "安装 WireGuard 和 UFW..."
if ! apt install -y wireguard ufw; then
    echo "安装 WireGuard 或 UFW 失败，请检查安装日志。"
    exit 1
fi

# 配置防火墙规则
echo "配置防火墙规则..."


if ! ufw allow 22/tcp; then
    echo "允许 22/tcp 失败，请检查 UFW 设置。"
    exit 1
fi

if ! ufw allow 22/udp; then
    echo "允许 22/udp 失败，请检查 UFW 设置。"
    exit 1
fi

if ! ufw allow 51820/tcp; then
    echo "允许 51820/tcp 失败，请检查 UFW 设置。"
    exit 1
fi

if ! ufw allow 51820/udp; then
    echo "允许 51820/udp 失败，请检查 UFW 设置。"
    exit 1
fi


echo "请确认你的ssh端口是22。如果不是请退出此脚本..."
read -p "按 Enter 键继续..."

if ! ufw enable; then
    echo "启用 UFW 失败，请检查 UFW 设置。"
    exit 1
fi

# 提示用户编辑 WireGuard 配置文件
echo "请手动输入 WireGuard 配置文件内容。"
echo "按 Enter 键将打开VIM编辑器以编辑 /etc/wireguard/wg0.conf 文件。请在此文件输入你的conf配置"

read -p "按 Enter 键继续..."

if ! vi /etc/wireguard/wg0.conf; then
    echo "打开编辑器失败。"
    exit 1
fi

# 检查配置文件是否成功创建
if [ ! -f /etc/wireguard/wg0.conf ]; then
    echo "WireGuard 配置文件创建失败。"
    exit 1
fi

# 启动 WireGuard 接口
echo "启动 WireGuard 接口..."
if ! wg-quick up wg0; then
    echo "启动 WireGuard 接口失败，请检查配置文件或日志。"
    exit 1
fi

# 启用 WireGuard 服务
echo "启用 WireGuard 服务..."
if ! systemctl enable wg-quick@wg0.service; then
    echo "启用 WireGuard 服务失败，请检查 systemctl 日志。"
    exit 1
fi

echo "WireGuard 已配置并成功启动。"
