import router from '@ohos.router'

@Entry
@Component
struct Home {
  onPageShow() {
    setTimeout(() => {
      router.pushUrl({ url: 'pages/HomeTab' })
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