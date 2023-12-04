import { Header } from './header'
import router from '@ohos.router';

let name: string = router.getParams()['name'];

@Entry
@Component
struct SevenPasses {
  @State index: number = 1

  build() {

    Column() {

      Header({ title: '逢七过' + name, onLeftClick: () => {
        router.back()
      } }).padding({ left: 10 }).margin({ top: 10 })
      this.item('劝君莫惜金缕衣 劝君惜取少年时')
      this.item('二十四桥明月夜，玉人何处教吹箫？')
      Text(this.index % 7 == 0 ? "过" : this.index.toFixed(0))
        .margin({ top: 10, bottom: 10 })
        .fontColor("#f00")
        .fontWeight(FontWeight.Bold)
        .fontSize(18)
      Button('逢7过').onClick(() => {
        this.index++;
        console.log('index = ' + this.index.toFixed(0))
      }).styleButton()
    }.width('100%')
    .height('100%')
  }

  @Builder item(content: string) {
    Row() {
      Text(content)
        .fontSize(18)
    }.styleText()
  }
}

@Extend(Row) function styleText() {
  .width('100%')
  .height(50)
  .justifyContent(FlexAlign.Center)
  .margin({ top: 20 })
}

@Extend(Button) function styleButton() {
  .fontColor('#fff')
  .fontSize(16)
  .type(ButtonType.Normal)
  .borderRadius(10)
  .width(200)
  .height(40)
  .backgroundColor('#36D')

}
