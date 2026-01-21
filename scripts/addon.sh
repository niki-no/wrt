#!/bin/bash  

# 用法: git_clone [-b 分支名（可选）] <仓库地址> <目标目录>
function git_clone() {
    local args=()
    
    if [[ "$1" == "-b" && -n "$2" ]]; then
        args=("-b" "$2" "$3" "$4")
    else
        args=("$1" "$2")
    fi
    
    git clone --depth 1 "${args[@]}" 
    
    if [[ $? -ne 0 ]]; then
        return 1
    fi
}

# 用法: git_sparse_clone [-b 分支名（可选）] <仓库地址> [-d 目标目录（可选）] <路径>
function git_sparse_clone() {
    local rootdir=$(pwd) branch='main' url targetdir='.' tmpdir paths=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -b) branch="$2"; shift 2 ;;
            -d) targetdir="$2"; shift 2 ;;
            *) 
                if [[ -z "$url" ]]; then
                    url="$1"
                else
                    paths+=("${1#./}")
                fi
                shift
                ;;
        esac
    done

    [[ -n "$url" ]] || { echo "缺少仓库地址" >&2; return 1; }
    [[ ${#paths[@]} -gt 0 ]] || { echo "缺少路径参数" >&2; return 1; }

    tmpdir=$(mktemp -d) || return 1
    trap 'rm -rf "$tmpdir"' EXIT INT TERM

    if [[ "$branch" =~ ^[0-9a-f]{7,40}$ ]]; then
        git clone --filter=blob:none --sparse "$url" "$tmpdir" &&
        (cd "$tmpdir" && git checkout --quiet "$branch") || return 1
    else
        git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$url" "$tmpdir" || return 1
    fi

    (cd "$tmpdir" && 
     git sparse-checkout init --cone &&
     git sparse-checkout set "${paths[@]}" &&
     mkdir -p "$rootdir/$targetdir" &&
     for p in "${paths[@]}"; do
         [[ -e "$p" ]] && cp -af -- "$p" "$rootdir/$targetdir/"
     done) || return 1
}

#用法: mvdir <源目录> [目标目录]
function mvdir() {
    local source_dir="$1"
    local target_dir="${2:-.}"
    
    for dir in "$source_dir"/*; do
        if [[ -d "$dir" ]]; then
            cp -af -- "$dir" "$target_dir"/ 2>/dev/null || true
        fi
    done

    rm -rf "$source_dir"
}

mkdir -p mypackages
git_clone https://github.com/xiaorouji/openwrt-passwall-packages passwall-packages && rm -rf passwall-packages/{.git,.github} && mvdir passwall-packages mypackages
git_clone https://github.com/kenzok8/small small && rm -rf small/{.git,.github} && mvdir small mypackages
git_clone https://github.com/sbwml/packages_lang_golang.git golang && rm -rf golang/{.git,.github} && mv golang mypackages
git_clone https://github.com/pymumu/openwrt-smartdns smartdns && rm -rf smartdns/{.git,.github} && mv smartdns mypackages
git_clone https://github.com/pymumu/luci-app-smartdns luci-app-smartdns && rm -rf luci-app-smartdns/{.git,.github} && mv luci-app-smartdns mypackages
git_clone https://github.com/destan19/OpenAppFilter OpenAppFilter && rm -rf OpenAppFilter/{.git,.github} && mvdir OpenAppFilter mypackages
git_clone https://github.com/sirpdboy/luci-app-eqosplus luci-app-eqosplus && rm -rf luci-app-eqosplus/{.git,.github} && mv luci-app-eqosplus mypackages
git_clone https://github.com/sirpdboy/luci-app-parentcontrol luci-app-parentcontrol && rm -rf luci-app-parentcontrol/{.git,.github} && mv luci-app-parentcontrol mypackages
git_clone https://github.com/sirpdboy/luci-app-netspeedtest luci-app-netspeedtest && rm -rf luci-app-netspeedtest/{.git,.github} && mvdir luci-app-netspeedtest mypackages
git_clone https://github.com/jerrykuku/luci-theme-argon luci-theme-argon && rm -rf luci-theme-argon/{.git,.github} && mv luci-theme-argon mypackages
git_clone https://github.com/jerrykuku/luci-app-argon-config luci-app-argon-config && rm -rf luci-app-argon-config/{.git,.github} && mv luci-app-argon-config mypackages
git_clone https://github.com/tty228/luci-app-wechatpush luci-app-wechatpush && rm -rf luci-app-wechatpush/{.git,.github} && mv luci-app-wechatpush mypackages
git_clone https://github.com/KFERMercer/luci-app-tcpdump luci-app-tcpdump && rm -rf luci-app-tcpdump/{.git,.github} && mv luci-app-tcpdump mypackages

git_sparse_clone https://github.com/Openwrt-Passwall/openwrt-passwall -d mypackages luci-app-passwall
git_sparse_clone https://github.com/Openwrt-Passwall/openwrt-passwall2 -d mypackages luci-app-passwall2
git_sparse_clone https://github.com/gdy666/luci-app-lucky -d mypackages luci-app-lucky lucky
git_sparse_clone https://github.com/sirpdboy/luci-app-netwizard -d mypackages luci-app-netwizard
git_sparse_clone https://github.com/sirpdboy/luci-app-timecontrol -d mypackages luci-app-nft-timecontrol
git_sparse_clone https://github.com/Lienol/openwrt-package -d mypackages luci-app-socat luci-app-control-weburl luci-app-control-webrestriction luci-app-timecontrol

# =============================================================================
# 分支特定配置（依赖环境变量 REPO_NAME）
# =============================================================================
if [ "$REPO_NAME" = "lede" ]; then
    echo "暂无"

elif [ "$REPO_NAME" = "immortalwrt" ]; then
    echo "暂无"

elif [ "$REPO_NAME" = "openwrt" ]; then
    git_sparse_clone https://github.com/immortalwrt/immortalwrt -d package/default-settings package/emortal/default-settings
fi

# 添加语言包zh_Hans或zh-cn
if ls -d mypackages/luci-app-*/po > /dev/null 2>&1; then
    for dir in mypackages/luci-app-*/po; do
        ls -d "$dir"/*/ | grep -v '/zh-cn/' | grep -v '/zh_Hans/' | xargs rm -rf
done
fi
for I in $(find mypackages -type d -name "zh-cn"); do
    [ -d "${I/zh-cn/zh_Hans}" ] && continue
    cp -rf "$I" "${I/zh-cn/zh_Hans}"
done
for I in $(find mypackages -type d -name "zh_Hans"); do
    [ -d "${I/zh_Hans/zh-cn}" ] && continue
    cp -rf "$I" "${I/zh_Hans/zh-cn}"
done

# 替换 Makefile 中的 include 路径
replace_include() {
    local filepath="$1"
    if grep -q 'include ../../luci.mk' "$filepath"; then
        sed -i 's|include ../../luci.mk|include $(TOPDIR)/feeds/luci/luci.mk|' "$filepath"
        echo "Replaced in: $filepath"
    fi
}

export -f replace_include
find mypackages -name "Makefile" -exec bash -c 'replace_include "$0"' {} \;

# 替换feeds里面同名文件
find mypackages -maxdepth 1 -type d \( -name ".github" -o -name ".git" \) -prune -o \
    -type d ! -name "mypackages" -print0 | while IFS= read -r -d '' dir; do
    
    [[ ! -d "$dir" ]] && continue
    
    base_dir=$(basename "$dir")
    [[ -z "$base_dir" ]] && continue
    
    found_dir=$(find feeds -maxdepth 3 -type d -name "$base_dir" 2>/dev/null | head -1)
    
    if [[ -n "$found_dir" && -d "$found_dir" && -w "$found_dir" ]]; then
        echo "覆盖 feeds 目录: $base_dir -> $found_dir"
        find "$found_dir" -mindepth 1 -maxdepth 1 ! -name ".*" -exec rm -rf {} + 2>/dev/null || true
        cp -rf "$dir"/* "$found_dir"/
        rm -rf "$dir"
    else
        echo "移动到 applications: $base_dir"
        cp -rf "$dir" "feeds/luci/applications/"
        rm -rf "$dir"
    fi
done
rm -rf mypackages
echo "##############添加结束#################"
