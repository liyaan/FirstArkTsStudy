import { ConsoleUtils } from '../model/ConsoleUtils'
import { HttpUtils } from '../model/HttpUtils'
import { ImageList } from '../model/ImageList'

@Component
export struct PhotoList {
  @State imageList: Array<ImageList> = new Array()

  aboutToAppear() {
    this.httpSend()
  }

  build() {
    Column() {
      List({ space: 5 }) {
        ForEach(this.imageList, (item, index) => {
          this.items(item)
        })
      }.onScrollIndex((firstIndex: number, lastIndex: number) => {
        ConsoleUtils.log("firstIndex:" + firstIndex + "," + "lastIndex:" + lastIndex)
        // if (lastIndex == this.imageList.length - 1) {
        //   this.httpSend()
        // }
      })
    }.width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
  }

  @Builder items(item: ImageList) {
    Column() {
      Image(item.url)
        .width('95%')
        .height(150)
        .borderRadius(10)
      Text(item.title + "   " + item.type)
        .fontColor('#222')
        .fontSize(16)
    }
    .width('100%')
    .height(180)
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(HorizontalAlign.Center)
  }

  httpSend() {
    HttpUtils.get('getImages', (json) => {
      this.imageList = json.result.list
    }, (err) => {
    })
  }
}