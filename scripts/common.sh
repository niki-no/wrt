#!/bin/bash

# =============================================================================
# OpenWrt 固件自定义脚本 —— Build By ViS0N
# 功能：修改默认 IP、Banner、语言、主题、菜单项、翻译等
# =============================================================================

# --- 基础系统定制 ---
sed -i "s/tty\(0\|1\)::askfirst/tty\1::respawn/g" target/linux/*/base-files/etc/inittab
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
sed -i '/export ENV=\/etc\/shinit/a\LANG=zh_CN.UTF-8\nLC_ALL=zh_CN.UTF-8' package/base-files/files/etc/profile

# --- LuCI 基础模块翻译优化 ---
base_po=feeds/luci/modules/luci-base/po/zh_Hans/base.po

sed -i '$a\\nmsgid "VPN"\nmsgstr "酷软"' ${base_po}
sed -i '$a\\nmsgid "NAS"\nmsgstr "存储"' ${base_po}
sed -i 's/msgstr "主机名映射"/msgstr "主机映射"/g' ${base_po}
sed -i 's/msgstr "管理权"/msgstr "权限管理"/g' ${base_po}
sed -i 's/msgstr "软件包"/msgstr "软件管理"/g' ${base_po}
sed -i 's/msgstr "启动项"/msgstr "启动管理"/g' ${base_po}
sed -i 's/msgstr "挂载点"/msgstr "挂载路径"/g' ${base_po}
sed -i 's/msgstr "重启"/msgstr "立即重启"/g' ${base_po}
sed -i 's/msgstr "备份与升级"/msgstr "备份\/升级"/g' ${base_po}
sed -i 's/msgstr "DHCP\/DNS"/msgstr "DHCP服务"/g' ${base_po}

# --- 主题美化 ---
themes=feeds/luci/themes

# Bootstrap 主题：禁用斜体
[ -d "${themes}/luci-theme-bootstrap" ] && sed -i '/\/\* Typography\.less/i em, i {font-style: normal !important;}\n' ${themes}/luci-theme-bootstrap/htdocs/luci-static/bootstrap/cascade.css

# --- 应用插件翻译与菜单调整 ---
applications=feeds/luci/applications

# 通用应用
[ -d "${applications}/luci-app-diag-core" ] && sed -i 's/msgstr "诊断"/msgstr "网络诊断"/g' ${applications}/luci-app-diag-core/po/zh_Hans/diag_core.po
[ -d "${applications}/luci-app-socat" ] && sed -i 's/msgstr "Socat"/msgstr "端口转发"/g' ${applications}/luci-app-socat/po/zh_Hans/socat.po
[ -d "${applications}/luci-app-mwan3" ] && sed -i 's/msgstr "MultiWAN 管理器"/msgstr "负载均衡"/g' ${applications}/luci-app-mwan3/po/zh_Hans/mwan3.po
[ -d "${applications}/luci-app-opkg" ] && sed -i 's/msgstr "软件包"/msgstr "软件管理"/g' ${applications}/luci-app-opkg/po/zh_Hans/opkg.po
[ -d "${applications}/luci-app-turboacc" ] && sed -i 's/msgstr "Turbo ACC 网络加速"/msgstr "网络加速"/g' ${applications}/luci-app-turboacc/po/zh_Hans/turboacc.po
[ -d "${applications}/luci-app-ttyd" ] && sed -i 's/msgstr "命令"/msgstr "命令终端"/g' ${applications}/luci-app-ttyd/po/zh_Hans/ttyd.po
[ -d "${applications}/luci-app-tcpdump" ] && sed -i 's/msgstr "Tcpdump 流量监控"/msgstr "流量截取"/g' ${applications}/luci-app-tcpdump/po/zh_Hans/tcpdump.po
[ -d "${applications}/luci-app-argon-config" ] && sed -i 's/msgstr "Argon 主题设置"/msgstr "主题设置"/g' ${applications}/luci-app-argon-config/po/zh_Hans/argon-config.po

# 调整菜单顺序（避免冲突）
[ -d "${applications}/luci-app-filetransfer" ] && sed -i 's/89/88/g' ${applications}/luci-app-filetransfer/luasrc/controller/filetransfer.lua

# 软件管理
[ -d "${applications}/luci-app-package-manager" ] && sed -i 's/msgstr "软件包"/msgstr "软件管理"/g' ${applications}/luci-app-package-manager/po/zh_Hans/package-manager.po

# miniDLNA
[ -d "${applications}/luci-app-minidlna" ] && sed -i 's/miniDLNA Settings/DLNA设置/' ${applications}/luci-app-minidlna/htdocs/luci-static/resources/view/minidlna.js
[ -d "${applications}/luci-app-minidlna" ] && sed -i 's/msgstr "miniDLNA"/msgstr "DLNA服务"/g' ${applications}/luci-app-minidlna/po/zh_Hans/minidlna.po
[ -d "${applications}/luci-app-minidlna" ] && echo -e "\nmsgid \"miniDLNA Settings\"\nmsgstr \"DLNA设置\"" >> ${applications}/luci-app-minidlna/po/zh_Hans/minidlna.po

# ARP绑定
[ -d "${applications}/luci-app-arpbind" ] && sed -i 's/msgstr "IP\/MAC绑定"/msgstr "地址绑定"/g' ${applications}/luci-app-arpbind/po/zh_Hans/arpbind.po
[ -d "${applications}/luci-app-arpbind" ] && echo -e "\nmsgid \"Rules\"\nmsgstr \"规则\"" >> ${applications}/luci-app-arpbind/po/zh_Hans/arpbind.po

# USB 打印服务
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/44/43/g' ${applications}/luci-app-usb-printer/luasrc/controller/usb_printer.lua
[ -d "${applications}/luci-app-usb-printer" ] && grep -rl 'nas' ${applications}/luci-app-usb-printer | xargs -r sed -i 's/nas/services/g'
[ -d "${applications}/luci-app-usb-printer" ] && grep -rl 'NAS' ${applications}/luci-app-usb-printer | xargs -r sed -i 's/NAS/Services/g'
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/msgstr "USB 打印服务器"/msgstr "打印服务"/g' ${applications}/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po
[ -d "${applications}/luci-app-usb-printer" ] && sed -i 's/msgstr "网络存储"/msgstr "存储"/g' ${applications}/luci-app-usb-printer/po/zh_Hans/luci-app-usb-printer.po

# 带宽监控
[ -d "${applications}/luci-app-nlbwmon" ] && sed -i 's/msgstr "带宽监控"/msgstr "监控"/g' ${applications}/luci-app-nlbwmon/po/zh_Hans/nlbwmon.po
[ -d "${applications}/luci-app-nlbwmon" ] && sed -i 's/admin\/services\/nlbw/admin\/nlbw/g' ${applications}/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json

# 菜单分类调整（批量替换 services 路径）
[ -d "${applications}/luci-app-oaf" ] && grep -rl 'services' ${applications}/luci-app-oaf | xargs -r sed -i 's/services/control/g'

[ -d "${applications}/luci-app-wechatpush" ] && grep -rl 'services' ${applications}/luci-app-wechatpush | xargs -r sed -i 's/services/vpn/g'

[ -d "${applications}/luci-app-cifs-mount" ] && grep -rl 'nas' ${applications}/luci-app-cifs-mount | xargs -r sed -i 's/nas/services/g'

[ -d "${applications}/luci-app-zerotier" ] && sed -i 's/msgstr "ZeroTier"/msgstr "内网穿透"/g' ${applications}/luci-app-zerotier/po/zh_Hans/zerotier.po
[ -d "${applications}/luci-app-zerotier" ] && grep -rl 'services' ${applications}/luci-app-zerotier | xargs -r sed -i 's/services/vpn/g'

[ -d "${applications}/luci-app-accesscontrol" ] && sed -i 's/msgstr "上网时间控制"/msgstr "时间控制"/g' ${applications}/luci-app-accesscontrol/po/zh_Hans/mia.po
[ -d "${applications}/luci-app-accesscontrol" ] && grep -rl 'services' ${applications}/luci-app-accesscontrol | xargs -r sed -i 's/services/control/g'

[ -d "${applications}/luci-app-unblockneteasemusic" ] && sed -i 's/解除网易云音乐播放限制/网易音乐/g' ${applications}/luci-app-unblockneteasemusic/root/usr/share/luci/menu.d/luci-app-unblockneteasemusic.json
[ -d "${applications}/luci-app-unblockneteasemusic" ] && grep -rl 'services' ${applications}/luci-app-unblockneteasemusic | xargs -r sed -i 's/services/vpn/g'

[ -d "${applications}/luci-app-watchcat" ] && grep -rl 'services' ${applications}/luci-app-watchcat | xargs -r sed -i 's/services/system/g'
[ -d "${applications}/luci-app-watchcat" ] && sed -i 's/msgstr "Watchcat"/msgstr "智能重启"/g' ${applications}/luci-app-watchcat/po/zh_Hans/watchcat.po

# PassWall
[ -d "${applications}/luci-app-passwall" ] && sed -i 's/msgstr "PassWall"/msgstr "翻越长城"/g' ${applications}/luci-app-passwall/po/zh_Hans/passwall.po
[ -d "${applications}/luci-app-passwall" ] && sed -i '/Pass Wall/s/-1/4/g' ${applications}/luci-app-passwall/luasrc/controller/passwall.lua
[ -d "${applications}/luci-app-passwall" ] && grep -rl 'services' ${applications}/luci-app-passwall | xargs -r sed -i 's/services/vpn/g'

# SmartDNS
[ -d "${applications}/luci-app-smartdns" ] && sed -i 's/msgstr "SmartDNS"/msgstr "DNS 加速"/g' ${applications}/luci-app-smartdns/po/zh_Hans/smartdns.po
[ -d "${applications}/luci-app-smartdns" ] && grep -rl 'services' ${applications}/luci-app-smartdns | xargs -r sed -i 's/services/vpn/g'

# Lucky
[ -d "${applications}/luci-app-lucky" ] && sed -i 's/msgstr "Lucky"/msgstr "反向代理"/g' ${applications}/luci-app-lucky/po/zh_Hans/lucky.po
[ -d "${applications}/luci-app-lucky" ] && grep -rl 'services' ${applications}/luci-app-lucky | xargs -r sed -i 's/services/vpn/g'

# Time/WOL 控制
[ -d "${applications}/luci-app-control-timewol" ] && grep -rl 'control' ${applications}/luci-app-control-timewol | xargs -r sed -i 's/control/services/g'

# 实时流量
[ -d "${applications}/luci-app-wrtbwmon" ] && sed -i 's/msgstr "流量监控"/msgstr "实时流量"/g' ${applications}/luci-app-wrtbwmon/po/zh_Hans/wrtbwmon.po

# =============================================================================
# 分支特定配置（依赖环境变量 REPO_NAME）
# =============================================================================
if [ "$REPO_NAME" = "lede" ]; then
    defaultsettings=package/lean/default-settings
    package_files=package/base-files/files
    
    sed -i '/aria2.lua/,/samba4.json/d' ${defaultsettings}/files/zzz-default-settings
    sed -i 's/LEDE /LEDE Build By ViS0N /' ${defaultsettings}/files/zzz-default-settings
    sed -i 's/%D %V, %C/%D %V, %C, Build By ViS0N/g' ${package_files}/etc/banner

    # Argon 主题：禁用斜体 + 添加页脚信息
    [ -d "${themes}/luci-theme-argon" ] && sed -i 's/b,strong{font-weight:bolder}/b,strong{font-weight:bolder}em, i {font-style: normal !important;}/' ${themes}/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
    [ -d "${themes}/luci-theme-argon" ] && sed -i '/Powered by {{ version.luciname }}.*<\/a>/a\				<span class="footer-separator">|<\/span>\n\n				<a href="https:\/\/github.com\/niki-no\/wrt" target="_blank"> LEDE Build By ViS0N<\/a>' ${themes}/luci-theme-argon/ucode/template/themes/argon/footer.ut
    [ -d "${themes}/luci-theme-argon" ] && sed -i 's#({{ version.luciversion }})</a>#&\n\t\t<a href="https://github.com/niki-no/wrt" target="_blank">LEDE Build By ViS0N</a>#' ${themes}/luci-theme-argon/ucode/template/themes/argon/footer_login.ut

    [ -d "${applications}/luci-app-cifs-mount" ] && sed -i 's/msgstr "挂载 SMB 网络共享"/msgstr "挂载 SMB"/g' ${applications}/luci-app-cifs-mount/po/zh_Hans/cifs.po
    [ -d "${applications}/luci-app-autoreboot" ] && sed -i 's/88/89/g' ${applications}/luci-app-autoreboot/luasrc/controller/autoreboot.lua
    [ -d "${applications}/luci-app-vlmcsd" ] && sed -i 's/msgstr "KMS 服务器"/msgstr "KMS 服务"/g' ${applications}/luci-app-vlmcsd/po/zh_Hans/vlmcsd.po
    [ -d "${applications}/luci-app-upnp" ] && sed -i 's/msgstr "UPnP"/msgstr "UPnP服务"/g' ${applications}/luci-app-upnp/po/zh_Hans/upnp.po

elif [ "$REPO_NAME" = "immortalwrt" ]; then
    package_files=package/base-files/files
    
    sed -i "s/[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\}/$(date +%Y.%m.%d)/g" ${package_files}/etc/banner
    sed -i "s/%D %V %C/%D Build By ViS0N R%V/g" ${package_files}/etc/openwrt_release
    sed -i '/OPENWRT_RELEASE/d' ${package_files}/usr/lib/os-release
    echo "OPENWRT_RELEASE=\"ImmortalWrt Build By ViS0N R$(date +%y.%m.%d)\"" >> ${package_files}/usr/lib/os-release

    # Argon 主题：禁用斜体 + 添加页脚信息
    [ -d "${themes}/luci-theme-argon" ] && sed -i 's/b,strong{font-weight:bolder}/b,strong{font-weight:bolder}em, i {font-style: normal !important;}/' ${themes}/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
    [ -d "${themes}/luci-theme-argon" ] && sed -i '/Powered by {{ version.luciname }}.*<\/a>/a\				<span class="footer-separator">|<\/span>\n\n				<a href="https:\/\/github.com\/niki-no\/wrt" target="_blank"> ImmortalWrt Build By ViS0N<\/a>' ${themes}/luci-theme-argon/ucode/template/themes/argon/footer.ut
    [ -d "${themes}/luci-theme-argon" ] && sed -i 's#({{ version.luciversion }})</a>#&\n\t\t<a href="https://github.com/niki-no/wrt" target="_blank">ImmortalWrt Build By ViS0N</a>#' ${themes}/luci-theme-argon/ucode/template/themes/argon/footer_login.ut

    [ -d "${applications}/luci-app-cifs-mount" ] && sed -i 's/msgstr "挂载 SMB 网络共享"/msgstr "挂载 SMB"/g' ${applications}/luci-app-cifs-mount/po/zh_Hans/cifs-mount.po
    [ -d "${applications}/luci-app-autoreboot" ] && sed -i 's/88/89/g' ${applications}/luci-app-autoreboot/root/usr/share/luci/menu.d/luci-app-autoreboot.json
    [ -d "${applications}/luci-app-vlmcsd" ] && sed -i 's/msgstr "Vlmcsd KMS 服务器"/msgstr "KMS 服务"/g' ${applications}/luci-app-vlmcsd/po/zh_Hans/vlmcsd.po
    [ -d "${applications}/luci-app-upnp" ] && sed -i 's/msgstr "UPnP IGD 和 PCP"/msgstr "UPnP服务"/g' ${applications}/luci-app-upnp/po/zh_Hans/upnp.po
    [ -d "${applications}/luci-app-hd-idle" ] && grep -rl 'nas' ${applications}/luci-app-hd-idle | xargs -r sed -i 's/nas/services/g'
    [ -d "${applications}/luci-app-minidlna" ] && grep -rl 'nas' ${applications}/luci-app-minidlna | xargs -r sed -i 's/nas/services/g'

elif [ "$REPO_NAME" = "openwrt" ]; then
    echo "暂无"
fi

echo "############## 自定义结束 #################"
