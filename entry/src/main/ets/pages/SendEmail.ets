import { Header } from './header'
import router from '@ohos.router'
import { StringUtils } from '../common/utils/StringUtils'
import { ToastUtils } from '../model/ToastUtils'
import { HttpUtils } from '../model/HttpUtils'

@Entry
@Component
struct SendEmail {
  private title: string
  private content: string
  private emailAddress: string

  build() {
    Column() {
      Header({ title: '发送邮件', onLeftClick: () => {
        router.back()
      } })
        .padding({ left: 5, top: 10, bottom: 10 })
      TextInput({ placeholder: '请输入邮箱地址' })
        .type(InputType.Email)
        .TextInputStyle()
        .onChange((value) => {
          this.emailAddress = value
        })
      TextInput({ placeholder: '请输入邮件标题(最长为10个字符)' })
        .TextInputStyle()
        .maxLength(10)
        .onChange((value) => {
          this.title = value
        })
      TextArea({ placeholder: '请输入邮件内容(100个字以内)' })
        .height(150)
        .textAlign(TextAlign.Start)
        .fontSize(18)
        .fontColor('#222')
        .borderRadius(10)
        .margin({ top: 15 })
        .onChange((value) => {
          this.content = value
        })
      Button('发送')
        .width('100%')
        .height(45)
        .type(ButtonType.Normal)
        .borderRadius(10)
        .margin({ top: 15 })
        .onClick(() => {
          if (!StringUtils.isNotNullOrEmptyLength(this.title, 11)) {
            ToastUtils.showOne("请输入正确的标题10个字以内")
            return
          }
          if (!StringUtils.isNotNullOrEmptyLength(this.content, 101)) {
            ToastUtils.showOne("请输入正确的内容100字以内")
            return
          }
          HttpUtils.post(
            { 'content': this.content, 'mail': this.emailAddress, 'title': this.title },
            'sendMail',
            (json) => {
              let code = json.code
              if (code == 200) {
                ToastUtils.showOne(json.message)
                router.back()
              }
            }, (err) => {

          }
          )
        })
    }.width('100%')
    .height('100%').backgroundColor('#f0f0f0')
    .padding({ left: 10, right: 10 })
  }
}

@Extend(TextInput) function TextInputStyle() {
  .fontSize(18)
  .fontColor('#222')
  .borderRadius(10)
  .margin({ top: 15 })
}