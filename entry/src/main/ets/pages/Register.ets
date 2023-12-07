import { HttpUtils } from '../model/HttpUtils'
import { ToastUtils } from '../model/ToastUtils'
import router from '@ohos.router'

@Entry
@Component
struct Register {
  @State registerAccount: string = '309324904@qq.com'
  @State registerPassword: string = '123456'
  @State registerCodeContent: string = '获取验证码'
  @State registerCode: string = '167568'
  @State send: boolean = true
  @State timeId: number = 0
  @State timeCount: number = 60

  build() {
    Column() {
      Image($r('app.media.app_icon'))
        .width(100)
        .height(100)
        .borderRadius(20)
        .margin({ top: 100 })
      Row() {
        TextInput({ placeholder: '请输入注册邮箱' })
          .maxLength(11)
          .onChange(value => {
            this.registerAccount = value
          }).textInputCommon().type(InputType.Email)
      }.textRowCommon()

      Row() {
        TextInput({ placeholder: '请输入验证码' })
          .maxLength(11)
          .onChange(value => {
            this.registerCode = value
          }).textInputYZMCommon().type(InputType.Number)
        Button(this.registerCodeContent)
          .fontSize(12)
          .width(100)
          .height(40)
          .margin({ left: 10 })
          .onClick(() => {
            if (this.send) {
              HttpUtils.post({ 'mail': this.registerAccount },
                'sendVerificationCode', (value) => {
                  ToastUtils.prototype.show(value.message)
                  this.send = false
                  this.timeId = setInterval(() => {
                    if (this.timeCount != 0) {
                      this.timeCount -= 1
                      this.registerCodeContent = this.timeCount.toFixed(0) + "s"
                      console.log("ccccccccccccccccccccccccccccc" + this.timeCount)
                    } else {
                      this.timeCount = 60
                      clearInterval(this.timeId)
                      this.send = true
                      this.registerCodeContent = '重新发送'
                    }
                  }, 1000)
                }, (err) => {

                })

            } else {
              console.log("aaaaaaaaaaaaaa")
            }

          })

      }.textRowCommon()

      Row() {
        TextInput({ placeholder: '请输入密码' })
          .onChange(value => {
            this.registerPassword = value
          }).textInputCommon()
          .type(InputType.Password)
      }.textRowCommon()

      Button('注册')
        .buttonStyle()
        .onClick(() => {
          if (!this.registerAccount) {
            // console.log('账号不能为空')
            // return
            this.registerAccount = '309324904@qq.com'
          }
          if (!this.registerPassword) {
            // console.log('密码不能为空')
            // return
            this.registerPassword = '123456'
          }
          if (!this.registerCode) {
            // console.log('密码不能为空')
            // return
            this.registerCode = '167568'
          }
          HttpUtils.post({ 'account': this.registerAccount,
            'code': this.registerCode, 'password': this.registerPassword },
            'register', (value) => {
              router.back()
            }, (err) => {
              if (err) {
                let code = err.code
                if (code != 200) {
                  router.back()
                  console.log("aaaaaaaaaaaaaa")
                }
              }

            })
        })
    }.width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
    .alignItems(HorizontalAlign.Center)
  }
}

@Extend(TextInput) function textInputCommon() {
  .backgroundColor('#fff')
  .textAlign(TextAlign.Center)
  .type(InputType.Normal)
  .padding({ left: 10, right: 15 })
  .width('100%')
  .height(40)
}

@Extend(TextInput) function textInputYZMCommon() {
  .backgroundColor('#fff')
  .textAlign(TextAlign.Center)
  .type(InputType.Normal)
  .height(40)
  .padding({ left: 10, right: 15 })
  .width('65%')
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