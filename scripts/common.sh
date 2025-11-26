#!/bin/bash

# =============================================================================
# OpenWrt 固件自定义脚本 —— Build By ViS0N
# 功能：修改默认 IP、Banner、语言、主题、菜单项、翻译等
# =============================================================================

# --- 基础系统定制 ---
sed -i "s/tty\(0\|1\)::askfirst/tty\1::respawn/g" "target/linux/*/base-files/etc/inittab"
sed -i 's/192.168.1.1/192.168.10.1/g' "package/base-files/files/bin/config_generate"
sed -i '/export ENV=\/etc\/shinit/a\LANG=zh_CN.UTF-8\nLC_ALL=zh_CN.UTF-8' "package/base-files/files/etc/profile"

# --- LuCI 基础模块翻译优化 ---
modules=feeds/luci/modules
base_po="${modules}/luci-base/po/zh_Hans/base.po"

sed -i '$a\\nmsgid "VPN"\nmsgstr "酷软"' "${base_po}"
sed -i '/msgid "Hostnames"/{n;s/主机名/主机映射/;}' "${base_po}"
sed -i '/msgid "Administration"/{n;s/管理权/权限管理/;}' "${base_po}"
sed -i '/msgid "Software"/{n;s/软件包/软件管理/;}' "${base_po}"
sed -i '/msgid "Startup"/{n;s/启动项/启动管理/;}' "${base_po}"
sed -i '/msgid "Mount Points"/{n;s/挂载点/挂载路径/;}' "${base_po}"
sed -i '/msgid "Reboot"/{n;s/重启/立即重启/;}' "${base_po}"
sed -i 's/msgstr "备份与升级"/msgstr "备份\/升级"/g' "${base_po}"
sed -i 's/msgstr "DHCP\/DNS"/msgstr "DHCP服务"/g' "${base_po}"

# --- 主题美化 ---
themes=feeds/luci/themes

# Bootstrap 主题：禁用斜体
[ -d "${themes}/luci-theme-bootstrap" ] && sed -i '/\/\* Typography\.less/i em, i {font-style: normal !important;}\n' "${themes}/luci-theme-bootstrap/htdocs/luci-static/bootstrap/cascade.css"

# Argon 主题：禁用斜体 + 添加页脚信息
[ -d "${themes}/luci-theme-argon" ] && sed -i 's/b,strong{font-weight:bolder}/b,strong{font-weight:bolder}em, i {font-style: normal !important;}/' "${themes}/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css"
[ -d "${themes}/luci-theme-argon" ] && sed -i '/Powered by {{ version.luciname }}.*<\/a>/a\				<span class="footer-separator">|<\/span>\n\n				<a href="https:\/\/github.com\/fuckactions\/OpenWrt" target="_blank"> LEDE Build By ViS0N<\/a>' "${themes}/luci-theme-argon/ucode/template/themes/argon/footer.ut"
[ -d "${themes}/luci-theme-argon" ] && sed -i 's#({{ version.luciversion }})</a>#&\n\t\t<a href="https://github.com/fuckactions/OpenWrt" target="_blank">LEDE Build By ViS0N</a>#' "${themes}/luci-theme-argon/ucode/template/themes/argon/footer_login.ut"

# --- 应用插件翻译与菜单调整 ---
applications=feeds/luci/applications

# 通用应用
[ -d "${applications}/luci-app-diag-core" ] && sed -i 's/msgstr "诊断"/msgstr "网络诊断"/g' "${applications}/luci-app-diag-core/po/zh_Hans/diag_core.po"
[ -d "${applications}/luci-app-socat" ] && sed -i 's/msgstr "Socat"/msgstr "端口转发"/g' "${applications}/luci-app-socat/po/zh_Hans/socat.po"
[ -d "${applications}/luci-app-upnp" ] && sed -i '/msgid "UPnP"/{n;s/UPnP/UPnP服务/;}' "${applications}/luci-app-upnp/po/zh_Hans/upnp.po"
[ -d "${applications}/luci-app-vlmcsd" ] && sed -i 's/KMS 服务器/KMS 服务/g' "${applications}/luci-app-vlmcsd/po/zh_Hans/vlmcsd.po"
[ -d "${applications}/luci-app-mwan3" ] && sed -i 's/msgstr "MultiWAN 管理器"/msgstr "负载均衡"/g' "${applications}/luci-app-mwan3/po/zh_Hans/mwan3.po"
[ -d "${applications}/luci-app-opkg" ] && sed -i 's/msgstr "软件包"/msgstr "软件管理"/g' "${applications}/luci-app-opkg/po/zh_Hans/opkg.po"
[ -d "${applications}/luci-app-turboacc" ] && sed -i 's/msgstr "Turbo ACC 网络加速"/msgstr "网络加速"/g' "${applications}/luci-app-turboacc/po/zh_Hans/turboacc.po"
[ -d "${applications}/luci-app-ttyd" ] && sed -i 's/msgstr "命令"/msgstr "命令终端"/g' "${applications}/luci-app-ttyd/po/zh_Hans/ttyd.po"
[ -d "${applications}/luci-app-tcpdump" ] && sed -i 's/Tcpdump 流量监控/流量截取/g' "${applications}/luci-app-tcpdump/po/zh_Hans/tcpdump.po"
[ -d "${applications}/luci-app-argon-config" ] && sed -i 's/"Argon 主题设置"/"主题设置"/g' "${applications}/luci-app-argon-config/po/zh_Hans/argon-config.po"

# 调整菜单顺序（避免冲突）
[ -d "${applications}/luci-app-filetransfer" ] && sed -i 's/89/88/g' "${applications}/luci-app-filetransfer/luasrc/controller/filetransfer.lua"
[ -d "${applications}/luci-app-autoreboot" ] && sed -i 's/88/89/g' "${applications}/luci-app-autoreboot/luasrc/controller/autoreboot.lua"

# miniDLNA
[ -d "${applications}/luci-app-minidlna" ] && sed -i "s/'miniDLNA Settings'/'DLNA设置'/" "${applications}/luci-app-minidlna/htdocs/luci-static/resources/view/minidlna.js"
[ -d "${applications}/luci-app-minidlna" ] && sed -i '/msgid "miniDLNA"/{n;s/miniDLNA/DLNA服务/;}' "${applications}/luci-app-minidlna/po/zh_Hans/minidlna.po"
[ -d "${applications}/luci-app-minidlna" ] && echo -e "\nmsgid \"miniDLNA Settings\"\nmsgstr \"DLNA设置\"" >> "${applications}/luci-app-minidlna/po/zh_Hans/minidlna.po"

# ARP绑定
[ -d "${applications}/luci-app-arpbind" ] && sed -i 's/msgstr "IP\/MAC绑定"/msgstr "地址绑定"/g' "${applications}/luci-app-arpbind/po/zh_Hans/arpbind.po"
[ -d "${applications}/luci-app-arpbind" ] && echo -e "\nmsgid \"Rules\"\nmsgstr \"规则\"" >> "${applications}/luci-app-arpbind/po/zh_Hans/arpbind.po"

# USB 打印服务
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/44/43/g' "${applications}/luci-app-usb-printer/luasrc/controller/usb_printer.lua"
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/nas/services/g' "${applications}/luci-app-usb-printer/luasrc/controller/usb_printer.lua"
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/NAS/Services/g' "${applications}/luci-app-usb-printer/luasrc/controller/usb_printer.lua"
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/USB 打印服务器/打印服务/g' "${applications}/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po"
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/网络存储/存储/g' "${applications}/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po"

# 带宽监控
[ -d "${applications}/luci-app-nlbwmon" ] && sed -i 's/带宽监控/监控/g' "${applications}/luci-app-nlbwmon/po/zh_Hans/nlbwmon.po"
[ -d "${applications}/luci-app-nlbwmon" ] && sed -i 's/admin\/services\/nlbw/admin\/nlbw/g' "${applications}/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json"

# 菜单分类调整（批量替换 services 路径）
[ -d "${applications}/luci-app-oaf" ] && sed -i 's/services/control/g' $(grep -rl 'services' "${applications}/luci-app-oaf")
[ -d "${applications}/luci-app-wechatpush" ] && sed -i 's/services/vpn/g' $(grep -rl 'services' "${applications}/luci-app-wechatpush")

[ -d "${applications}/luci-app-cifs-mount" ] && sed -i 's/nas/services/g' $(grep -rl 'nas' "${applications}/luci-app-cifs-mount")
[ -d "${applications}/luci-app-cifs-mount" ] && sed -i 's/"挂载 SMB 网络共享"/"挂载 SMB"/g' "${applications}/luci-app-cifs-mount/po/zh_Hans/cifs.po"

[ -d "${applications}/luci-app-zerotier" ] && sed -i 's/msgstr "ZeroTier"/msgstr "内网穿透"/g' "${applications}/luci-app-zerotier/po/zh_Hans/zerotier.po"
[ -d "${applications}/luci-app-zerotier" ] && sed -i 's/services/vpn/g' $(grep -rl 'services' "${applications}/luci-app-zerotier")

[ -d "${applications}/luci-app-accesscontrol" ] && sed -i 's/上网时间控制/时间控制/g' "${applications}/luci-app-accesscontrol/po/zh_Hans/mia.po"
[ -d "${applications}/luci-app-accesscontrol" ] && sed -i 's/services/control/g' $(grep -rl 'services' "${applications}/luci-app-accesscontrol")

[ -d "${applications}/luci-app-unblockneteasemusic" ] && sed -i 's/解除网易云音乐播放限制/网易音乐/g' "${applications}/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json"
[ -d "${applications}/luci-app-unblockneteasemusic" ] && sed -i 's/services/vpn/g' $(grep -rl 'services' "${applications}/luci-app-unblockneteasemusic")

[ -d "${applications}/luci-app-watchcat" ] && sed -i 's/services/system/g' $(grep -rl 'services' "${applications}/luci-app-watchcat")
[ -d "${applications}/luci-app-watchcat" ] && sed -i 's/msgstr "Watchcat"/msgstr "智能重启"/g' "${applications}/luci-app-watchcat/po/zh_Hans/watchcat.po"

# PassWall
[ -d "${applications}/luci-app-passwall" ] && sed -i '/msgid "Pass Wall"/{n;s/PassWall/翻越长城/;}' "${applications}/luci-app-passwall/po/zh_Hans/passwall.po"
[ -d "${applications}/luci-app-passwall" ] && sed -i '/Pass Wall/s/-1/4/g' "${applications}/luci-app-passwall/luasrc/controller/passwall.lua"
[ -d "${applications}/luci-app-passwall" ] && sed -i 's/services/vpn/g' $(grep -rl 'services' "${applications}/luci-app-passwall")

# SmartDNS
[ -d "${applications}/luci-app-smartdns" ] && sed -i '/msgid "SmartDNS"/{n;s/SmartDNS/DNS 加速/;}' "${applications}/luci-app-smartdns/po/zh_Hans/smartdns.po"
[ -d "${applications}/luci-app-smartdns" ] && sed -i 's/services/vpn/g' $(grep -rl 'services' "${applications}/luci-app-smartdns")

# Lucky
[ -d "${applications}/luci-app-lucky" ] && sed -i 's/msgstr "Lucky"/msgstr "反向代理"/g' "${applications}/luci-app-lucky/po/zh_Hans/lucky.po"
[ -d "${applications}/luci-app-lucky" ] && sed -i 's/services/vpn/g' $(grep -rl 'services' "${applications}/luci-app-lucky")

# Time/WOL 控制
[ -d "${applications}/luci-app-control-timewol" ] && sed -i 's/"control"/"services"/g' $(grep -rl 'control' "${applications}/luci-app-control-timewol")

# 实时流量
[ -d "${applications}/luci-app-wrtbwmon" ] && sed -i 's/msgstr "流量监控"/msgstr "实时流量"/g' "${applications}/luci-app-wrtbwmon/po/zh-cn/wrtbwmon.po"


# =============================================================================
# 分支特定配置（依赖环境变量 BRANCH）
# =============================================================================
if [ "$REPO_NAME" = "lede" ]; then
    defaultsettings=package/lean/default-settings
    package_etc=package/base-files/files/etc
    sed -i '/aria2.lua/,/samba4.json/d' "${defaultsettings}/files/zzz-default-settings"
    sed -i 's/LEDE /LEDE Build By ViS0N /' "${defaultsettings}/files/zzz-default-settings"
    sed -i 's/%D %V, %C/%D %V, %C, Build By ViS0N/g' "${package_etc}/banner"

elif [ "$REPO_NAME" = "immortalwrt" ]; then
    package_etc=package/base-files/files/etc
    sed -i "s/[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\}/$(date +%Y.%m.%d)/g" "${package_etc}/banner"
    sed -i "s/%D %V %C/%D Build By ViS0N R%V/g" "${package_etc}/openwrt_release"

elif [ "$REPO_NAME" = "openwrt" ]; then
    echo "暂无"
fi

echo "############## 自定义结束 #################"
