import { ConsoleUtils } from '../model/ConsoleUtils'
import { HttpUtils } from '../model/HttpUtils'
import { ImageList } from '../model/ImageList'
import router from '@ohos.router'
import { ToastUtils } from '../model/ToastUtils'

@Component
export struct PhotoList {
  @State imageList: Array<ImageList> = new Array()
  page: number = 0
  isMoreLoad: boolean = false

  aboutToAppear() {
    this.httpSend()
  }

  build() {
    Column() {
      List({ space: 5 }) {
        ForEach(this.imageList, (item, index) => {
          this.items(item, index)
        })
      }.onScrollIndex((firstIndex: number, lastIndex: number) => {
        ConsoleUtils.log("firstIndex:" + firstIndex + "," + "lastIndex:" + lastIndex)
        if (lastIndex == this.imageList.length - 1 && !this.isMoreLoad) {
          this.isMoreLoad = true
          this.page++
          this.httpSend()
        }
      })
    }.width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
  }

  @Builder items(item: ImageList, index: number) {
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
    .onClick(() => {
      router.pushUrl({
        url: 'pages/PhotoInfo',
        params: {
          url: item.url,
          info: item.title,
          list: this.imageList,
          index: index
        }
      })
    })
  }

  httpSend() {
    HttpUtils.get('getImages?page=' + this.page + '&size=10', (json) => {

      let initValue = json.result.list.length
      if (initValue > 0) {
        for (var i = 0; i < initValue; i++) {
          const element = json.result.list[i];
          this.imageList.push(element)
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