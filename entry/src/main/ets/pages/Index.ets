// @ts-nocheck
// 导入router模块
import router from '@ohos.router';
import { Header } from './header';


@Extend(Button) function styleButton() {
  .fontColor('#fff')
  .fontSize(16)
  .type(ButtonType.Normal)
  .borderRadius(10)
  .width(200)
  .height(40)
  .backgroundColor('#36D')
}

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State imageWidth: number = 100

  build() {

    Column() {
      Header({ title: '学习', onLeftClick: () => {
        router.back()
      } }).padding({ left: 10, top: 5, bottom: 5 })
      Text(this.message)
        .fontSize(10)
        .fontWeight(FontWeight.Bold)
        .visibility(Visibility.Visible)

      Row() {
        Image($r("app.media.icon"))
          .width(this.imageWidth)
          .interpolation(ImageInterpolation.High)
      }.width('80%')
      .height(300)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      Row() {
        Text($r('app.string.Photo_width'))
          .fontColor("#001")
          .fontSize(20)
          .padding({ left: 15 })
        TextInput({ placeholder: '请输入图片的宽度', text: this.imageWidth.toFixed(0) })
          .width(200)
          .backgroundColor('#fff')
          .textAlign(TextAlign.Center)
          .type(InputType.Normal)
          .maxLength(3)
          .onChange(value => {
            if (value == "") {
              value = "0"
            }
            this.imageWidth = parseInt(value)
          })
          .padding({ left: 10, right: 15 })
      }.width('90%')
      .justifyContent(FlexAlign.SpaceBetween)

      Divider().width('90%')

      Row() {
        Button("缩小").onClick(ev => {
          if (this.imageWidth >= 10) {
            this.imageWidth -= 10
          }
        }).width(100).backgroundColor("#09f").fontColor("#fff")

        Button("放大")
          .onClick(ev => {
            if (this.imageWidth <= 300) {
              this.imageWidth += 10
            }
          })
          .width(100)
          .backgroundColor("#09f")
          .fontColor("#fff")
          .type(ButtonType.Normal)
          .margin(10)
      }.width('90%')
      .justifyContent(FlexAlign.SpaceEvenly).margin({ top: 10, bottom: 10 })

      Slider(
        { min: 100, max: 300, value: this.imageWidth, step: 10 }
      )
        .blockColor('#36D')
        .width('90%')
        .trackThickness(7)
        .showTips(true)
        .showSteps(false)
        .onChange(value => {
          this.imageWidth = value
        })
      Button("商品列表")
        .fontColor('#fff')
        .type(ButtonType.Normal)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/shopList'
          })
        })
      Button("视频播放页面")
        .fontColor('#fff')
        .type(ButtonType.Normal)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/SimpleVideoIndex'
          })
        }).margin({ top: 10 })
      Button("逢七过")
        .styleButton()
        .margin({ top: 10 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/sevenPasses',
            params: {
              name: '逢七过'
            }
          })
        })
      Button("ArkTS调用Native函数")
        .styleButton()
        .margin({ top: 10 })
        .onClick(() => {
          router.pushUrl({
            url: "pages/ArkTsNative",
          })
        })
    }
    .width('100%')
    .height('100%')
  }
}



