import router from '@ohos.router'
import { FoodInfo } from '../model/DataModels'

@Entry
@Component
struct Detail {
  private foodInfo = (router.getParams() as { foodInfo: FoodInfo }).foodInfo
  // private foodInfo = {"id":0,"name":"番茄","kk":15,"category":1,"img":{"id":16777232,"type":20000,"params":[],"bundleName":"com.example.healthydiet","moduleName":"entry"},"rl":0,"yy":0,"zf":0}

  build() {
    Column() {
      PageTitle()
      FoodImage({ foodInfo: this.foodInfo })
      Content({ foodInfo: this.foodInfo })
    }
    .height('100%')
    .backgroundColor('#dedede')
  }
}

@Component
struct PageTitle {
  build() {
    Row() {
      Image($r('app.media.back'))
        .width(20)
        .height(20)
        .margin({ right: 5 })
        .onClick(() => {
          router.back()
        })
      Text('食物详情').fontSize(26).fontColor(0x3E3E3E)
    }.width('100%')
    .margin({ top: 8 })
    .padding({ left: 20 })
    .justifyContent(FlexAlign.Start)
  }
}

@Component
struct FoodImage {
  private foodInfo: FoodInfo

  build() {
    Stack() {
      Image(this.foodInfo.img)
        .objectFit(ImageFit.Contain)
      Text(this.foodInfo.name)
        .fontSize(26)
        .fontColor(0x3E3E3E)
        .width('90%')
        .position({ x: 10, y: 230 })
    }.height(300)
  }
}

@Component
struct Content {
  private foodInfo: FoodInfo

  build() {
    Column() {
      this.LineContent('#ffaaaa', '热量', this.foodInfo.rl, '千卡')
      this.LineContent('#aaffaa', '营养元素', this.foodInfo.rl, '克')
      this.LineContent('#aaaaff', '脂肪', this.foodInfo.zf, '克')
    }
    .width('90%')
    .margin({ top: 20, bottom: 20 })
    .padding(20)
    .borderRadius(10)
    .backgroundColor(Color.White)
  }

  @Builder
  LineContent(color: ResourceColor, name: string, count: number, unit: string) {
    Row() {
      Circle({ width: 6, height: 6 })
        .margin({ right: 12 })
        .fill(color)
      Text(name)
        .fontSize(22)
        .fontColor(0x3E3E3E)
      Blank()
      Text(count + ' ' + unit).fontSize(22).fontColor(0x3E3E3E)
    }.width('100%')
    .margin(10)
    .padding({ left: 10, right: 10 })
  }
}
