#!/bin/bash

echo "请输入应用名称: (默认值: ReactNativeApp)"
read appName
appName=${appName:-ReactNativeApp}

echo "是否需要安装 Yarn包管理器?（默认: y）"
read useYarn
useYarn=${useYarn:-y}

echo "是否立即安装依赖?（默认: y）"
read installDependencies
installDependencies=${installDependencies:-y}

# 更新 app.json
appJsonPath="./app.json"
if [ -f "$appJsonPath" ]; then
  echo "正在更新 app.json 文件..."
  # 使用 sed 仅替换 displayName 字段的值
  sed -i '' "s/\"displayName\": \".*\"/\"displayName\": \"$appName\"/" "$appJsonPath"
  echo "app.json 文件已更新"
else
  echo "未找到 app.json 文件，跳过更新步骤"
fi

# 安装 yarn 包管理器
if [ "$useYarn" == "y" ]; then
  echo "正在安装 Yarn..."
  npm install -g yarn
fi

# 安装项目依赖
if [ "$installDependencies" == "y" ]; then
  echo "正在安装项目所有依赖..."
  yarn install
fi

# 初始化 Android 和 iOS 项目
echo "正在初始化 Android 和 iOS 项目..."
npx react-native eject

echo "项目初始化完成！"
