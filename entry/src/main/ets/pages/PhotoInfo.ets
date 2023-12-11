import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import { ConsoleUtils } from '../model/ConsoleUtils';
import { ImageList } from '../model/ImageList';
import { PhotoLooper } from '../view/PhotoLooper';
import { Header } from './header';

@Entry
@Component
struct PhotoInfo {
  private imagePath: string = (router.getParams() as Record<string, Object>).url as string;
  private imageInfo: string = (router.getParams() as Record<string, Object>).info as string;
  private imageList: Array<ImageList> = (router.getParams() as Record<string, Object>).list as Array<ImageList>;
  private imageListStr: Array<ResourceStr> = new Array()
  private index: number = (router.getParams() as Record<string, Object>).index as number;

  build() {
    Column({ space: 10 }) {
      Header({ title: '图片详情', onLeftClick: () => {
        router.back()
      } }).padding({ left: 15, top: 10, bottom: 10 })
      PhotoLooper({ list: this.imageList, index: this.index })


      Stack({ alignContent: Alignment.Bottom }) {

        Image(this.imagePath).objectFit(ImageFit.Contain)
          .width('90%')
          .onClick(() => {
            if (this.imageListStr && this.imageListStr.length > 0) {
              this.imageListStr.pop()
            }

            this.imageList.forEach((item) => {
              this.imageListStr.push(item.url)
            })
            router.pushUrl({
              url: Constants.URL_DETAIL_LIST_PAGE,
              params: { photoArr: this.imageListStr }
            });
          })
        Text(this.imageInfo)
          .fontColor('#36D')
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }.width('100%').layoutWeight(1)

    }.width('100%')
    .height('100%')
  }
}