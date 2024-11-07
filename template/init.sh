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

# 获取当前文件夹名称
currentDirName=$(basename "$PWD")

# 更新 package.json 中的 appProject 字段为当前文件夹名称
packageJsonPath="./package.json"
if [ -f "$packageJsonPath" ]; then
  echo "正在更新 package.json 文件..."
  # 使用 sed 替换 appProject 字段
  sed -i '' "s/\"name\": \".*\"/\"appProject\": \"$currentDirName\"/" "$packageJsonPath" 2>/dev/null
fi

# 更新 app.json 中的 name 字段为当前文件夹名称
appJsonPath="./app.json"
if [ -f "$appJsonPath" ]; then
  echo "正在更新 app.json 文件..."
  # 使用 sed 替换 appProject 字段
  sed -i '' "s/\"name\": \".*\"/\"appProject\": \"$currentDirName\"/" "$packageJsonPath" 2>/dev/null
fi

# 更新 app.json
if [ -f "$appJsonPath" ]; then
  echo "正在更新 app.json 文件..."
  # 使用 sed 替换 displayName 字段的值
  sed -i '' "s/\"displayName\": \".*\"/\"displayName\": \"$appName\"/" "$appJsonPath" 2>/dev/null
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
  yarn
fi

# 替换 android 和 ios 目录中的 ReduxTemplate 为当前文件夹名
echo "正在更新 android 和 ios 目录..."
echo "tips: 如果出现"

# 替换 android 目录
find ./android -type f -exec sed -i '' "s/ReduxTemplate/$currentDirName/g" {} \; 2>/dev/null
find ./android -type f -exec sed -i '' "s/reduxtemplate/$currentDirName/g" {} \; 2>/dev/null
find ./android -type d -name "*ReduxTemplate*" -exec bash -c 'mv "$0" "${0//ReduxTemplate/'"$currentDirName"'}"' {} \; 2>/dev/null
find ./android -type d -name "*reduxtemplate*" -exec bash -c 'mv "$0" "${0//reduxtemplate/'"$currentDirName"'}"' {} \; 2>/dev/null

# 替换 ios 目录
find ./ios -type f -exec sed -i '' "s/ReduxTemplate/$currentDirName/g" {} \; 2>/dev/null
find ./ios -type d -name "*ReduxTemplate*" -exec bash -c 'mv "$0" "${0//ReduxTemplate/'"$currentDirName"'}"' {} \; 2>/dev/null

echo "项目初始化完成！"
