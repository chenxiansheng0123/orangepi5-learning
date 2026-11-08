#!/bin/bash
# sysinfo.sh - Orange Pi 5 系统体检脚本
# 用法: ./sysinfo.sh        普通信息
#       sudo ./sysinfo.sh   包含 NPU 信息

echo "========================================"
echo " Orange Pi 5 系统体检"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

echo ""
echo "[ 系统 ]"
echo "  发行版  : $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
echo "  内核    : $(uname -r)"
echo "  架构    : $(uname -m)"
echo "  已运行  : $(uptime -p)"

echo ""
echo "[ CPU 频率与调度策略 ]"
for policy in /sys/devices/system/cpu/cpufreq/policy*; do
    cpus=$(cat "$policy/affected_cpus")
    freq=$(cat "$policy/scaling_cur_freq")
    gov=$(cat "$policy/scaling_governor")
    printf "  CPU %-7s : %4d MHz   (%s)\n" "$cpus" "$((freq / 1000))" "$gov"
done

echo ""
echo "[ 温度 ]"
for zone in /sys/class/thermal/thermal_zone*; do
    name=$(cat "$zone/type")
    temp=$(cat "$zone/temp")
    printf "  %-20s : %d°C\n" "$name" "$((temp / 1000))"
done

echo ""
echo "[ 内存 ]"
free -h | sed 's/^/  /'

echo ""
echo "[ 存储 ]"
df -h / | sed 's/^/  /'

echo ""
echo "[ NPU ]"
if [ -r /sys/kernel/debug/rknpu/version ]; then
    echo "  $(cat /sys/kernel/debug/rknpu/version)"
    echo "  $(cat /sys/kernel/debug/rknpu/load)"
else
    echo "  需要 root 权限，请用 sudo ./sysinfo.sh 运行"
fi

echo ""
echo "[ 网络 ]"
ip -4 -o addr show scope global | awk '{printf "  %-8s : %s\n", $2, $4}'

echo ""
echo "========================================"
