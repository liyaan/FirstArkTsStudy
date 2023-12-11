import { MARGIN_FONT_SIZE, SECOND_PAGE, STRING_PERCENT } from '../common/constants/CommonConstants'
import { ImageList } from '../model/ImageList'

@Component
export struct PhotoLooper {
  private list: Array<ImageList>
  private index: number = 0

  build() {
    Column() {
      Swiper() {
        ForEach(this.list, (item: ImageList) => {
          SwiperItem({ imageSrc: item.url, source: item.title })
        }, (item: ImageList) => JSON.stringify(item))
      }
      .autoPlay(true)
      .index(this.index)
    }
    .height(STRING_PERCENT.INDEX_SWIPER_HEIGHT_PERCENT)
    .width(STRING_PERCENT.INDEX_COMPONENT_WITH_PERCENT)
    .backgroundColor($r('app.color.white'))
    .margin({
      left: STRING_PERCENT.INDEX_SWIPER_LEFT_RIGHT_MARGIN,
      right: STRING_PERCENT.INDEX_SWIPER_LEFT_RIGHT_MARGIN,
      top: MARGIN_FONT_SIZE.FOURTH_MARGIN
    })
  }
}

@Component
struct SwiperItem {
  private imageSrc: Resource | string = $r('app.string.empty');
  private source: string
  private paramItem: ImageList = new ImageList();

  aboutToAppear() {
    this.paramItem.url = this.source;
  }

  build() {
    Navigator() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.imageSrc)
          .borderRadius(MARGIN_FONT_SIZE.FIRST_MARGIN)
        Text(this.source)
          .fontColor('#36d')
          .fontSize(16)
          .width('100%')
          .textAlign(TextAlign.Center)
          .height(30)
          .opacity(0.7)
          .backgroundColor('#000')
      }.width('100%')
    }
    .params(this.paramItem)
  }
}