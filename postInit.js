const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const inquirer = require('inquirer');

async function customizeProject() {
  try {
    // 提示用户输入应用名称和其他自定义选项
    const answers = await inquirer.prompt([
      {
        type: 'input',
        name: 'appName',
        message: '请输入应用名称:',
        default: 'ReactNativeApp',
      },
      {
        type: 'confirm',
        name: 'useYarn',
        message: '是否需要安装 Yarn包管理器?',
        default: true,
      },
      {
        type: 'confirm',
        name: 'installDependencies',
        message: '是否立即安装依赖?',
        default: true,
      },
    ]);

    // 更新 app.json
    const appJsonPath = path.join(process.cwd(), 'app.json');
    if (fs.existsSync(appJsonPath)) {
      const appJson = JSON.parse(fs.readFileSync(appJsonPath, 'utf-8'));
      appJson.displayName = answers.appName;
      fs.writeFileSync(appJsonPath, JSON.stringify(appJson, null, 2));
      console.log('已更新 app.json 文件');
    } else {
      console.warn('未找到 app.json 文件，跳过更新步骤');
    }

    // 根据用户选择安装额外的依赖
    if (answers.useYarn) {
      console.log('正在安装 Yarn...');
      execSync('npm install yarn -g', { stdio: 'inherit' });
    }

    // 安装所有依赖
    if (answers.installDependencies) {
      console.log('正在安装项目所有依赖...');
      execSync('yarn', { stdio: 'inherit' });
    }
    console.log('正在初始化Android及iOS项目');
    execSync("npx react-native eject", { stdio: "inherit" }); // 生成android和ios文件夹
    console.log('项目初始化完成！');
  } catch (error) {
    console.error('项目初始化过程中出现错误:', error);
  }
}

customizeProject();
