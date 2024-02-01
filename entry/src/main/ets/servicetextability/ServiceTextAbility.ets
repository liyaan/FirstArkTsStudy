import formInfo from '@ohos.app.form.formInfo';
import formBindingData from '@ohos.app.form.formBindingData';
import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formProvider from '@ohos.app.form.formProvider';
import request from '@ohos.request';
import fs from '@ohos.file.fs';

export default class ServiceTextAbility extends FormExtensionAbility {
  onAddForm(want) {
    // Called to return a FormBindingData object.
    // 在入参want中可以取出卡片的唯一标识：formId
    let formId: string = want.parameters[formInfo.FormParam.IDENTITY_KEY];
    let formName: string = want.parameters[formInfo.FormParam.NAME_KEY];
    // 使用方创建卡片时触发，提供方需要返回卡片数据绑定类
    let obj = {
      'title': 'title',
      'detail': 'onAddForm'
    };
    console.log("UserData  onAddForm" + formId + "   " + formName + "  " + JSON.stringify(want))
    //在使用postCardAction接口的call事件时，需要在FormExtensionAbility中的onAddForm生命周期回调中更新formId。
    // let formId1 = want.parameters["ohos.extra.param.key.form_identity"];
    // let dataObj1 = {
    //   "formId": formId1
    // };
    // let obj1 = formBindingData.createFormBindingData(dataObj1);
    // return obj1;

    return formBindingData.createFormBindingData(obj);
  }

  onCastToNormalForm(formId) {
    // 使用方将临时卡片转换为常态卡片触发，提供方需要做相应的处理
    console.log("UserData  onCastToNormalForm formId:" + formId)
  }

  onUpdateForm(formId) {
    //若卡片支持定时更新/定点更新/卡片使用方主动请求更新功能，则提供方需要重写该方法以支持数据更新
    console.info('[EntryFormAbility] onUpdateForm');
    let obj = {
      'title': 'title',
      'detail': 'onUpdateForm'
    };
    let formData = formBindingData.createFormBindingData(obj);
    formProvider.updateForm(formId, formData).catch((err) => {
      if (err) {
        // 异常分支打印
        console.error(`[EntryFormAbility] Failed to updateForm. Code: ${err.code}, message: ${err.message}`);
        return;
      }
    });
  }

  onChangeFormVisibility(newStatus) {
    // 需要配置formVisibleNotify为true，且为系统应用才会回调
    console.log("UserData  onChangeFormVisibility")
  }

  onFormEvent(formId, message) {
    // 若卡片支持触发事件，则需要重写该方法并实现对事件的触发
    console.info(`UserData FormAbility onEvent, formId = ${formId}, message: ${JSON.stringify(message)}`);
    let params = JSON.parse(message);
    let info = params.info;
    if (info) {
      if (info == 'refreshImage') {
        // let formInfo = formBindingData.createFormBindingData({
        //   'text': '刷新中...'
        // })
        // formProvider.updateForm(formId, formInfo)
        // 注意：FormExtensionAbility在触发生命周期回调时被拉起，仅能在后台存在5秒
        // 建议下载能快速下载完成的小文件，如在5秒内未下载完成，则此次网络图片无法刷新至卡片页面上
        let netFile = 'https://res.vmallres.com/pimages//uomcdn/CN/pms/202309/gbom/6942103109621/428_428_9F0B82BD57F2C5853D61868D5486347Bmp.png'; // 需要在此处使用真实的网络图片下载链接
        let tempDir = this.context.getApplicationContext().tempDir;
        let tmpFile = tempDir + '/file' + Date.now();
        request.downloadFile(this.context, {
          url: netFile, filePath: tmpFile
        }).then((task) => {
          task.on('complete', function callback() {
            console.info('UserData ArkTSCard download complete:' + tmpFile);
            let file;
            try {
              file = fs.openSync(tmpFile);
            } catch (e) {
              console.error(`UserData openSync failed: ${JSON.stringify(e)}`);
            }
            let formData = {
              'shopImg': 'shopImgHttps',
              'shopTitle': 'HUAWEI Mate 60 RS',
              'shopContent': '双卫星通信，玄武钢化昆仑玻璃，传奇星钻设计',
              'formImages': {
                'shopImgHttps': file.fd
              },
            }
            let formInfo = formBindingData.createFormBindingData(formData)
            formProvider.updateForm(formId, formInfo).then((data) => {
              console.info('UserData FormAbility updateForm success.' + JSON.stringify(data));
            }).catch((error) => {
              console.error('UserData FormAbility updateForm failed: ' + JSON.stringify(error));
            })
          })
          task.on('fail', function callBack(err) {
            console.info('UserData ArkTSCard download task failed. Cause:' + err);
            // let formInfo = formBindingData.createFormBindingData({
            //   'text': '刷新失败'
            // })
            //formProvider.updateForm(formId, formInfo)
          });
        }).catch((err) => {
          console.error('UserData Failed to request the download. Cause: ' + JSON.stringify(err));
        });
      }
    } else {
      let formData = {
        'title': 'Title=', // 和卡片布局中对应
        'detail': 'Detail', // 和卡片布局中对应
      };
      let formInfo = formBindingData.createFormBindingData(formData)
      formProvider.updateForm(formId, formInfo).then((data) => {
        console.info('FormAbility updateForm success.' + JSON.stringify(data));
      }).catch((error) => {
        console.error('FormAbility updateForm failed: ' + JSON.stringify(error));
      })
    }


  }

  onRemoveForm(formId) {
    // 当对应的卡片删除时触发的回调，入参是被删除的卡片ID
    console.log("UserData  onRemoveForm")
  }

  onConfigurationUpdate(config) {
    // 当系统配置信息置更新时触发的回调
    console.info('[EntryFormAbility] configurationUpdate:' + JSON.stringify(config));
  }

  onAcquireFormState(want) {
    // Called to return a {@link FormState} object.
    // 卡片提供方接收查询卡片状态通知接口，默认返回卡片初始状态。
    return formInfo.FormState.READY;
  }
};