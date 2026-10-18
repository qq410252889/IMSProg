#!/usr/bin/env bash
# IMSProg Windows x64 打包脚本（GitHub Actions / MSYS2 环境）
# 用法：在仓库根目录执行  bash .github/scripts/package-win.sh
# 产物：dist/IMSProg_win-amd64.zip
set -euo pipefail

DIST_ROOT="$(pwd)/dist"
STAGE="$DIST_ROOT/IMSProg"
mkdir -p "$STAGE/share/imsprog"

echo "==> 1/5 复制可执行文件"
cp build/IMSProg_programmer/IMSProg.exe "$STAGE/"
cp build/IMSProg_editor/IMSProg_editor.exe "$STAGE/"
cp build/IMSProg_database_update/IMSProg_database_update.exe "$STAGE/"

echo "==> 2/5 递归收集并复制运行时 DLL（ldd 式）"
collect_deps() {
  local queue=("$1")
  local bin deps d
  while [ ${#queue[@]} -gt 0 ]; do
    bin="${queue[0]}"; queue=("${queue[@]:1}")
    deps="$(objdump -p "$bin" 2>/dev/null | awk '/DLL Name/{print $3}' | grep -Ei '\.dll$' || true)"
    for d in $deps; do
      if [ -f "/ucrt64/bin/$d" ] && [ ! -f "$STAGE/$d" ]; then
        cp "/ucrt64/bin/$d" "$STAGE/"
        queue+=("$STAGE/$d")
      fi
    done
  done
}
collect_deps "build/IMSProg_programmer/IMSProg.exe"
collect_deps "build/IMSProg_editor/IMSProg_editor.exe"
collect_deps "build/IMSProg_database_update/IMSProg_database_update.exe"

echo "==> 3/5 复制 Qt 插件"
PLUGIN_SRC="/ucrt64/share/qt6/plugins"
for sub in platforms styles imageformats iconengines tls generic networkinformation; do
  if [ -d "$PLUGIN_SRC/$sub" ]; then
    cp -r "$PLUGIN_SRC/$sub" "$STAGE/"
  fi
done

echo "==> 4/5 复制数据库与翻译"
cp IMSProg_programmer/database/IMSProg.Dat "$STAGE/share/imsprog/"
find build -name "*.qm" -exec cp {} "$STAGE/share/imsprog/" \;

echo "==> 5/5 收集驱动（官方 CH341a/CH347T 一键驱动安装包）"
mkdir -p /tmp/ofc && curl -sL -o /tmp/ofc/official.zip \
  "https://github.com/Anime4000/IMSProg/releases/download/v1.9.1%2B6dd0a0f/IMSProg_win-amd64.zip" \
  || true
if [ -s /tmp/ofc/official.zip ]; then
  ( cd /tmp/ofc && 7z x -y official.zip "IMSProg_win-amd64/driver/*" > /dev/null 2>&1 || true )
  if [ -d /tmp/ofc/IMSProg_win-amd64/driver ]; then
    cp -r /tmp/ofc/IMSProg_win-amd64/driver "$STAGE/drivers"
  fi
fi

echo "==> 生成 README 说明"
cat > "$STAGE/README.txt" <<'EOF'
IMSProg 1.9.1 (Windows x64) - GitHub Actions 云编译版
=====================================================
支持 CH341A / CH347T / CH347F / FT232H。
CH347T (PID 0x55db) 与 CH347F (PID 0x55de) 启动时自动探测。

使用方法：
1. 解压整个 IMSProg 文件夹，双击 IMSProg.exe（不要单独拖 exe）。
2. 驱动：
   - CH347T：可双击 drivers/CH347T_SPI_I2C_EEPROM_Programmer/InstallDriver.exe 一键安装；
     或使用 Zadig 给 Interface 2 安装 WinUSB。
   - CH347F：使用 Zadig 给 Interface 4 安装 WinUSB (USB ID 1A86:55DE)。
   - 安装前先卸载沁恒 CH341PAR 官方驱动（两者互斥）。

来源：https://github.com/qq410252889/IMSProg （GitHub Actions 自动构建）
EOF

echo "==> 打包 zip"
( cd "$DIST_ROOT" && 7z a -tzip IMSProg_win-amd64.zip IMSProg -bso0 -bsp0 > /dev/null )
echo "==> 完成：$(ls -lh "$DIST_ROOT/IMSProg_win-amd64.zip" | awk '{print $5, $9}')"
