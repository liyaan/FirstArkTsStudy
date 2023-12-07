import { HttpUtils } from '../model/HttpUtils'
import { VideoListModel } from '../model/VideoListModel'
import router from '@ohos.router'
import { SECOND_PAGE } from '../common/constants/CommonConstants'

@Component
export struct VideoList {
  @State list: Array<VideoListModel> = new Array()

  aboutToAppear() {
    HttpUtils.get('getMiniVideo', (json) => {
      this.list = json.result.list
    }, () => {

    })
  }

  build() {
    List({ space: 5 }) {
      ForEach(this.list, (item, index) => {
        this.item(item)
      })
    }

  }

  @Builder item(item: VideoListModel) {
    Row() {
      Image(item.picurl)
        .width(90)
        .height(90)
      Column() {
        Text(item.title).fontColor('#202').fontSize(16)
        Text(item.alias).fontColor('#202').fontSize(14).margin({ top: 10, bottom: 10 })
        Text(item.sec).fontSize(14)
      }.alignItems(HorizontalAlign.Start)
      .margin({ left: 20 })
    }.width('100%').padding({ left: 15, right: 15 })
    .height(100).onClick(() => {
      router.pushUrl({
        url: SECOND_PAGE,
        params: { source: item.playurl }
      });
    })
  }
}