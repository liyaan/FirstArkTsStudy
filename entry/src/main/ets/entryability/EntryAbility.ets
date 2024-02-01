import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import formBindingData from '@ohos.app.form.formBindingData';
import formProvider from '@ohos.app.form.formProvider';
import formInfo from '@ohos.app.form.formInfo';

import { MediaService } from '../common/utils/MediaService';
import { ConsoleUtils } from '../model/ConsoleUtils';
import { Logger } from '../common/utils/Logger';
import CardControlUtil from '../common/utils/CardControlUtil';
import { MusicMessageAble } from '../model/MusicMessageAble';
import rpc from '@ohos.rpc';

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

function sendMsgCallbackForm(data: rpc.MessageSequence): rpc.Parcelable {
  if (data === null) {
    Logger.error('sendMsgCallback data is null');
  }
  let msgObj: Record<string, Object> = JSON.parse(data.readString());
  CardControlUtil.controlByMessage(msgObj.message as string, msgObj.musicIndex as number);
  return new MusicMessageAble();
}

const MSG_SEND_FORM_METHOD: string = 'CallSendMsgForm';

export default class EntryAbility extends UIAbility {
  storage: LocalStorage

  onCreate(want, launchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    // 获取router事件中传递的targetPage参数
    try {
      // 监听call事件所需的方法
      this.callee.on('funA', FunACall);
      this.callee.on('funB', FunBCall);
      this.callee.on(MSG_SEND_FORM_METHOD, sendMsgCallbackForm);
    } catch (error) {
      ConsoleUtils.log('onCreate  register failed with error. Cause: ' + JSON.stringify(error));
    }
    ConsoleUtils.info("onCreate want:" + JSON.stringify(want));
    if (want.parameters.params !== undefined) {
      let params = JSON.parse(want.parameters.params);
      ConsoleUtils.info("onCreate router targetPage:" + params.targetPage);
      ConsoleUtils.info("onCreate router targetPage:" + params.detail);
      selectPage = params.targetPage;
      newTypeDetail = params.detail;
      let message = JSON.parse(want.parameters.params).detail;
      let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
      ConsoleUtils.info(`onCreate UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData = {
        "detail": message + ': onCreate UIAbility.', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData)
      formProvider.updateForm(curFormId, formMsg).then((data) => {
        ConsoleUtils.info('onCreate updateForm success.' + JSON.stringify(data));
      }).catch((error) => {
        ConsoleUtils.error('onCreate updateForm failed:' + JSON.stringify(error));
      })
    }
    AppStorage.SetOrCreate('context', this.context);
    MediaService.getInstance();
  }

  async onDestroy() {
    try {
      this.callee.off('funA');
      this.callee.off('funB');
      this.callee.off(MSG_SEND_FORM_METHOD);
    } catch (error) {
      ConsoleUtils.log('register failed with error. Cause: ' + JSON.stringify(error));
    }
    hilog.info(0x0000, 'UserData', '%{public}s', 'Ability onDestroy');
    await MediaService.getInstance().updateOnDestroy();
    MediaService.getInstance().release();
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'UserData', '%{public}s', 'Ability onWindowStageCreate ' + selectPage);
    ConsoleUtils.info("onWindowStageCreate selectPage:" + selectPage);
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
      case 'play':
      case 'pause':
        targetPage = 'pages/MusicMainPage';
        break;

      default:
        targetPage = 'pages/Home';
    }

    windowStage.loadContent(targetPage, this.storage, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'UserData', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'UserData', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'UserData', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'UserData', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'UserData', '%{public}s', 'Ability onBackground');
  }

  // 如果UIAbility已在后台运行，在收到Router事件后会触发onNewWant生命周期回调
  onNewWant(want, launchParam) {
    ConsoleUtils.info("onNewWant want:" + JSON.stringify(want));
    if (want.parameters.params !== undefined) {
      let params = JSON.parse(want.parameters.params);
      ConsoleUtils.info("onNewWant router targetPage:" + params.targetPage);
      ConsoleUtils.info("onCreate router targetPage:" + params.detail);
      selectPage = params.targetPage;
      newTypeDetail = params.detail;
      let message = JSON.parse(want.parameters.params).detail;
      let curFormId = want.parameters[formInfo.FormParam.IDENTITY_KEY];
      ConsoleUtils.info(`onNewWant UpdateForm formId: ${curFormId}, message: ${message}`);
      let formData = {
        "detail": message + ': onCreate UIAbility.', // 和卡片布局中对应
      };
      let formMsg = formBindingData.createFormBindingData(formData)
      formProvider.updateForm(curFormId, formMsg).then((data) => {
        ConsoleUtils.info('onNewWant updateForm success.' + JSON.stringify(data));
      }).catch((error) => {
        ConsoleUtils.error('onNewWant updateForm failed:' + JSON.stringify(error));
      })
    }
    if (currentWindowStage != null) {
      this.onWindowStageCreate(currentWindowStage);
    }
  }
}
