import router from '@ohos.router'
import { StringUtils } from '../common/utils/StringUtils'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { UserData } from '../model/UserData'

@Entry
@Component
struct Home {
  @State rotateAngle: number = 0
  @State itemAlign: FlexAlign = FlexAlign.Start;
  allAlign: FlexAlign[] = [FlexAlign.Start, FlexAlign.Center];
  @State mWidth: number = 100
  @State mHeight: number = 100
  @State scale1: number = 1
  @State opacity1: number = 1

  onPageShow() {
    animateTo({ duration: 1500, curve: Curve.EaseInOut, onFinish: () => {

      UserData.getPrefer('token', (token) => {
        ConsoleUtils.log("UserData " + token)
        if (token) {
          StringUtils.TOKEN_STRING = token
          router.pushUrl({ url: 'pages/HomeTab' })
        } else {
          router.pushUrl({ url: 'pages/Login' })
        }
      }, () => {
        router.pushUrl({ url: 'pages/Login' })
      })
    } }, () => {
      this.rotateAngle = 720
      this.itemAlign = FlexAlign.Center
      this.mWidth = 150
      this.mHeight = 150
    })
    // setTimeout(async () => {
    //
    //
    // }, 1000)
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: this.itemAlign
    }) {
      Image($r('app.media.logo'))
        .width(this.mWidth)
        .height(this.mHeight)
        .rotate({
          y: 1,
          angle: this.rotateAngle
        })
      Text('健康饮食')
        .fontSize(18)
        .fontColor(Color.White)
        .margin({ top: 30 })
      Text('健康的生活来自均衡的饮食')
        .fontSize(16)
        .fontColor(Color.White)
        .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#99ff99')
    .scale({ x: this.scale1 })
    .opacity(this.opacity1)
  }

  pageTransition() {
    // progress动效的归一化进度
    PageTransitionEnter({}).onEnter((type: RouteType, progress: number) => {
      this.scale1 = 1
      this.opacity1 = progress
    })
    // progress动效的归一化进度
    PageTransitionExit({}).onExit((type: RouteType, progress: number) => {
      this.scale1 = 1 - progress
      this.opacity1 = 1 - progress
    })
  }
}