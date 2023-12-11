import { HttpUtils } from '../model/HttpUtils'
import { VideoListModel } from '../model/VideoListModel'
import router from '@ohos.router'
import { SECOND_PAGE } from '../common/constants/CommonConstants'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { ToastUtils } from '../model/ToastUtils'

@Component
export struct VideoList {
  @State list: Array<VideoListModel> = new Array()
  page: number = 0
  isMoreLoad: boolean = false

  aboutToAppear() {
    this.sendRequest()
  }

  build() {
    List({ space: 5 }) {
      ForEach(this.list, (item, index) => {
        this.item(item)
      })
    }.onScrollIndex((firstIndex: number, lastIndex: number) => {
      ConsoleUtils.log("firstIndex:" + firstIndex + "," + "lastIndex:" + lastIndex)
      if (lastIndex == this.list.length - 1 && !this.isMoreLoad) {
        this.isMoreLoad = true
        this.page++
        this.sendRequest()
      }
    })

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

  sendRequest() {
    HttpUtils.get('getMiniVideo?page=' + this.page + '&size=10', (json) => {
      let initValue = json.result.list.length
      if (initValue > 0) {
        for (var i = 0; i < initValue; i++) {
          const element = json.result.list[i];
          this.list.push(element)
        }
        if (initValue < 10) {
          this.isMoreLoad = true
        } else {
          this.isMoreLoad = false
        }
      } else {
        this.isMoreLoad = true
        ToastUtils.showOne("暂无更多数据")
        this.page--
      }
      // this.imageList = json.result.list
    }, (err) => {
      this.page--
      this.isMoreLoad = false
    })
  }
}