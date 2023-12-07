import router from '@ohos.router'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { UserData } from '../model/UserData'

@Entry
@Component
struct Home {
  onPageShow() {
    setTimeout(async () => {
      UserData.getPrefer('token', (token) => {
        ConsoleUtils.log("UserData " + token)
        if (token) {
          ConsoleUtils.log("UserData " + "aaaaaaaaaaaaaaaaaaaaaaaaaaaa")
          router.pushUrl({ url: 'pages/HomeTab' })
        } else {
          ConsoleUtils.log("UserData " + "bbbbbbbbbbbbbbbbbbbbbbbbbb")
          router.pushUrl({ url: 'pages/Login' })
        }
      }, () => {
        ConsoleUtils.log("UserData " + "ccccccccccccccccccccccccccc")
        router.pushUrl({ url: 'pages/Login' })
      })

    }, 1000)
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Image($r('app.media.logo'))
        .width(100)
        .height(100)
      Text('健康饮食')
        .fontSize(18)
        .fontColor(Color.White)
        .margin({ top: 30 })
      Text('健康的生活来自均衡的饮食')
        .fontSize(16)
        .fontColor(Color.White)
        .margin({ top: 10 })
    }.width('100%')
    .height('100%')
    .backgroundColor('#99ff99')
  }
}