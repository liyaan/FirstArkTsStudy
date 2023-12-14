import { Header } from './header'
import router from '@ohos.router'
import { HttpUtils } from '../model/HttpUtils'
import { Sentence } from '../model/GetSentencesModel'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { ToastUtils } from '../model/ToastUtils'

@Entry
@Component
struct AppServer {
  @State sentences: Array<Sentence> = []

  build() {
    Column({ space: 10 }) {
      Header({ title: '工具服务', onLeftClick: () => {
        router.back()
      } }).padding({ left: 10 })
        .margin({ top: 10, bottom: 10 })
      Button('获取时间')
        .buttonStyle()
        .onClick(() => {
          this.GetTime()
        })
      Button('获取名言')
        .buttonStyle()
        .onClick(() => {
          this.GetSentences()
        })
      List({ space: 10 }) {
        ForEach(this.sentences, (item, index) => {
          ListItem() {
            this.listSentences(item)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
    }.width('100%')
    .height('100%')
  }

  GetSentences() {
    HttpUtils.get('sentences', (json) => {
      if (this.sentences) {
        let bean = new Sentence()
        bean.from = json.result.from
        bean.name = json.result.name
        this.sentences.push(bean)
      }
    }, (err) => {

    })
  }

  GetTime() {
    HttpUtils.get('getTime', (json) => {
      ToastUtils.showOne(json.result.dateTime)
    }, (err) => {

    })
  }

  @Builder listSentences(item: Sentence) {
    Column({ space: 10 }) {
      Text(item.from)
        .fontSize(18)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
      Text(item.name)
        .fontSize(16)
        .fontColor(Color.Black)
    }.width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}

@Extend(Button) function buttonStyle() {
  .fontSize(18)
  .fontColor(Color.White)
  .backgroundColor(Color.Green)
  .type(ButtonType.Normal)
  .width('90%')
  .height(45)
}