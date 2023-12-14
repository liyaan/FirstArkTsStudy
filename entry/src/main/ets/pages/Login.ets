import { HttpUtils } from '../model/HttpUtils'
import { ToastUtils } from '../model/ToastUtils'
import router from '@ohos.router'
import { UserData } from '../model/UserData'
import { StringUtils } from '../common/utils/StringUtils'

@Entry
@Component
struct Login {
  @State loginAccount: string = ''
  @State loginPassword: string = ''
  @State scale1: number = 1
  @State opacity1: number = 1

  build() {
    Column() {
      Image($r('app.media.app_icon'))
        .width(100)
        .height(100)
        .borderRadius(20)
        .margin({ top: 100 })
      Row() {
        Text('账号')
          .textTextCommon()
        TextInput({ placeholder: '请输入邮箱账号' })
          .maxLength(11)
          .onChange(value => {
            this.loginAccount = value
          }).textInputCommon().type(InputType.Email)
      }.textRowCommon()

      Row() {
        Text('密码')
          .textTextCommon()
        TextInput({ placeholder: '请输入密码' })
          .onChange(value => {
            this.loginPassword = value
          }).textInputCommon()
          .type(InputType.Password)
      }.textRowCommon()

      Button('登 录')
        .buttonStyle()
        .onClick(() => {
          if (!this.loginAccount) {
            // console.log('账号不能为空')
            // return
            this.loginAccount = '309324904@qq.com'
          }
          if (!this.loginPassword) {
            // console.log('密码不能为空')
            // return
            this.loginPassword = '123456'
          }
          HttpUtils.post({ 'account': this.loginAccount,
            'password': this.loginPassword },
            'login', (str) => {
              console.info('Result str:' + str);
              let id: number = str.result.id
              let account = str.result.account
              let token = str.result.token
              UserData.putPrefer("id", id.toFixed(0))
              UserData.putPrefer("account", account)
              UserData.putPrefer("token", token)
              StringUtils.TOKEN_STRING = token
              router.pushUrl(
                { url: 'pages/HomeTab' }
              )
            }, (str) => {
              console.info('Result Error str:' + str);
            })
        })
      Button('注册')
        .buttonStyle()
        .onClick(() => {
          router.pushUrl(
            { url: 'pages/Register' }
          )
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
    .alignItems(HorizontalAlign.Center)
    .scale({ y: this.scale1 })
    .opacity(this.opacity1)
  }

  onBackPress() {
    router.clear()
  }

  pageTransition() {
    // progress动效的归一化进度
    PageTransitionEnter({}).onEnter((type: RouteType, progress: number) => {
      this.scale1 = progress
      this.opacity1 = progress
    })

    PageTransitionExit({}).onExit((type: RouteType, progress: number) => {
      this.scale1 = 1 - progress
      this.opacity1 = 1 - progress
    })
  }
}

@Extend(TextInput) function textInputCommon() {
  .backgroundColor('#fff')
  .textAlign(TextAlign.Center)
  .type(InputType.Normal)
  .padding({ left: 10, right: 15 })
  .width('85%')
  .margin({ left: 10 })
}

@Extend(Text) function textTextCommon() {
  .fontColor('#000')
  .fontSize(18)
}

@Extend(Row) function textRowCommon() {
  .width('90%').margin({ top: 20 })
}

@Extend(Button) function buttonStyle() {
  .width('90%')
  .margin({ top: 20 })
  .height(40)
  .type(ButtonType.Normal)
  .backgroundColor('#36D')
  .borderRadius(10)
}