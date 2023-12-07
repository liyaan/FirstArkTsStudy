import { HttpUtils } from '../model/HttpUtils'
import MyModel from '../model/MyModel'
import { UserData } from '../model/UserData'
import router from '@ohos.router'

@Component
export struct My {
  @State name: string = ''
  @State imageUrl: string = ''
  @State info: string = ''
  // @State modelData: MyModel = new MyModel()
  aboutToAppear() {
    UserData.getPrefer("id", (id) => {
      HttpUtils.get('getUserInfoForId/' + id, (json) => {
        let result = json.result;
        this.name = result.name
        this.info = result.blurb
        this.imageUrl = result.head_url
      }, () => {

      })
    }, () => {
    })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.app_icon'))
          .width(100)
          .height(100)
          .borderRadius(50)
        Column() {
          Text(this.name).fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 10 })
          Text(this.info).fontSize(14).fontColor('#666')
        }
        .height('100%').alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .margin({ left: 20 })
      }.width('100%')
      .height(150).padding({ left: 25 }).backgroundColor('#ffffff')

      this.item($r('app.media.avocado'), '服务', 15)
      this.item($r('app.media.blueberry'), '发送邮件', 15, () => {
        router.pushUrl({
          url: 'pages/SendEmail'
        })
      })
      this.item($r('app.media.icecream'), '朋友圈', 0)
      this.item($r('app.media.kiwi'), '表情', 0)
      Button('学习Demo')
        .width('100%')
        .height(40)
        .type(ButtonType.Normal)
        .backgroundColor('#ffffff')
        .fontColor('#222')
        .margin({ top: 10, left: 10, right: 10 })
        .onClick(() => {
          router.pushUrl({
            url: "pages/Index"
          })
        })
      Button('退出')
        .width('100%')
        .height(40)
        .type(ButtonType.Normal)
        .margin({ top: 30, left: 15, right: 15 })
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login"
          })
          UserData.clear()
        })
    }.width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
  }

  @Builder item(icon: string | Resource, content: string, top: number, onClickView: () => void = null) {
    Row() {
      Image(icon)
        .width(40)
        .height(40)
      Text(content).fontColor('#222')
        .fontSize(16)
      Blank()
      Image($r('app.media.right_jiantou_one')).width(10).height(20)
    }
    .width('100%')
    .height(50)
    .padding({ left: 15, right: 15 })
    .backgroundColor('#ffffff')
    .margin({ top: top })
    .borderRadius(5)
    .onClick(() => {
      onClickView()
    })

  }
}