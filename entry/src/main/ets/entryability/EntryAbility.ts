import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import formBindingData from '@ohos.app.form.formBindingData';
import formProvider from '@ohos.app.form.formProvider';
import formInfo from '@ohos.app.form.formInfo';


let selectPage = "";
let currentWindowStage = null;
let newTypeDetail = null;

function FunACall(data) {
  // 获取call事件中传递的所有参数
  console.log('onCreate FunACall param:' + JSON.stringify(data.readString()));
  return null;
}

function FunBCall(data) {
  console.log('onCreate FunACall param:' + JSON.stringify(data.readString()));
  return null;
}

export default class EntryAbility extends UIAbility {
  storage: LocalStorage

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 获取router事件中传递的targetPage参数
    try {
      // 监听call事件所需的方法
      this.callee.on('funA', FunACall);
      this.callee.on('funB', FunBCall);
    } catch (error) {
      console.log('onCreate  register failed with error. Cause: ' + JSON.stringify(error));
    }
    console.info("onCreate want:" + JSON.stringify(want));
    if (want.parameters.params !== undefined) {
      let params = JSON.parse(want.parameters.params);
      console.info("onCreate router targetPage:" + params.targetPage);
      console.info("onCreate router targetPage:" + params.detail);
      selectPage = params.targetPage;
      newTypeDetail = params.detail;
      let message = JSON.parse(want.parameters.params).detail;
      let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
      console.info(`onCreate UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData = {
        "detail": message + ': onCreate UIAbility.', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData)
      formProvider.updateForm(curFormId, formMsg).then((data) => {
        console.info('onCreate updateForm success.' + JSON.stringify(data));
      }).catch((error) => {
        console.error('onCreate updateForm failed:' + JSON.stringify(error));
      })
    }
  }

  onDestroy() {
    try {
      this.callee.off('funA');
      this.callee.off('funB');
    } catch (error) {
      console.log('register failed with error. Cause: ' + JSON.stringify(error));
    }
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    let targetPage
    // 根据传递的targetPage不同，选择拉起不同的页面
    switch (selectPage) {
      case 'funA':
        this.storage = new LocalStorage()
        targetPage = 'pages/NewList';
        this.storage.setOrCreate('newTypeDetail', newTypeDetail)
        break;
      case 'funB':
        targetPage = 'pages/shopList';
        this.storage = new LocalStorage()
        this.storage.setOrCreate('newTypeDetail', newTypeDetail)
        break;
      case 'funC':
        targetPage = 'pages/Index';
        break;
      default:
        targetPage = 'pages/Home';
    }

    windowStage.loadContent(targetPage, this.storage, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
  onNewWant(want, launchParam) {
    console.info("onNewWant want:" + JSON.stringify(want));
    if (want.parameters.params !== undefined) {
      let params = JSON.parse(want.parameters.params);
      console.info("onNewWant router targetPage:" + params.targetPage);
      console.info("onCreate router targetPage:" + params.detail);
      selectPage = params.targetPage;
      newTypeDetail = params.detail;
      let message = JSON.parse(want.parameters.params).detail;
      let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
      console.info(`onNewWant UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData = {
        "detail": message + ': onCreate UIAbility.', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData)
      formProvider.updateForm(curFormId, formMsg).then((data) => {
        console.info('onNewWant updateForm success.' + JSON.stringify(data));
      }).catch((error) => {
        console.error('onNewWant updateForm failed:' + JSON.stringify(error));
      })
    }
    if (currentWindowStage != null) {
      this.onWindowStageCreate(currentWindowStage);
    }
  }
}
