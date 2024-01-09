// 使用web组件加载网页
import webview from '@ohos.web.webview'
import { Header } from './header'
import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import { ConsoleUtils } from '../model/ConsoleUtils'

@Entry
@Component
struct WebListPage {
  controll: WebviewController = new webview.WebviewController()
  fileAccess: boolean = true
  @State progress: number = 0
  @State hideProgress: boolean = true
  @State webResult: string = ''
  private type: number = (router.getParams() as Record<string, number>)['type']
  private url: string = (router.getParams() as Record<string, string>)['url']
  jsBridge = {
    jumpSystemPicture() {
      ConsoleUtils.log("closePage")
      let context = getContext(this) as common.UIAbilityContext;
      let want = {
        "deviceId": "",
        "bundleName": "",
        "abilityName": "",
        "uri": "",
        "type": "image/*",
        "action": "android.intent.action.GET_CONTENT",
        "parameters": {},
        "entities": []
      };
      context.startAbility(want);
    },
    closePage() {
      ConsoleUtils.log("closePage")
      router.back()
    }
  }

  build() {
    Column() {
      Header({ title: 'webH5', onLeftClick: () => {
        router.back()
      } }).padding({ left: 10, top: 5, bottom: 5 })
      Progress({ total: 100, value: this.progress })
        .color('#ff5cea20')
        .visibility(this.hideProgress ? Visibility.None : Visibility.Visible)
      Web({
        src: this.type == 1 ? this.url : $rawfile(this.url),
        controller: this.controll
      })
        .javaScriptAccess(true)
          // 设置文件访问权限和脚本执行权限
        .domStorageAccess(true)
        .fileAccess(this.fileAccess)

        .javaScriptProxy({
          object: this.jsBridge,
          name: "jsBridge",
          methodList: ["closePage", "jumpSystemPicture"],
          controller: this.controll
        })
        .onConsole((event) => {
          ConsoleUtils.log('getMessage:' + event.message.getMessage());
          ConsoleUtils.log('getSourceId:' + event.message.getSourceId());
          ConsoleUtils.log('getLineNumber:' + event.message.getLineNumber());
          ConsoleUtils.log('getMessageLevel:' + event.message.getMessageLevel());
          return false;
        })
        .onProgressChange(pro => {
          this.progress = pro.newProgress
          if (this.progress == 100) {
            this.hideProgress = true
          } else {
            this.hideProgress = false
          }
        })

        .onPageEnd(e => {

          // test()在index.html中定义

          this.controll.runJavaScript('test()', (error, result) => {
            if (error) {
              ConsoleUtils.info(`run JavaScript error: ` + JSON.stringify(error))
              return;
            }
            if (result) {
              this.webResult = result
              ConsoleUtils.info(`The test() return value is: ${result}`)
            }
          });

          ConsoleUtils.info('url: ' + e.url);

        })
        .layoutWeight(1)

    }.width('100%').height('100%')

  }
}