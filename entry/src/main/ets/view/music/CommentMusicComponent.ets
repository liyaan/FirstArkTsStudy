
import Logger from '@ohos/imagelibrary/src/main/ets/components/data/Logger';
import { RouterUrlConstants } from '../../common/music/RouterUrlConstants';
import { SongItem } from '../../model/SongData';
import { MusicList } from '../../viewmodel/MusicList';
import router from '@ohos.router';
import { StyleConstants } from '../../common/music/StyleConstants';

@Component
export struct CommentMusicComponent {
  @StorageProp('selectIndex') selectIndex: number = 0;
  songList: SongItem[] = MusicList;

  build() {
    Row() {
      Image(this.songList[this.selectIndex].label)
        .width($r('app.float.info_image_width'))
        .height($r('app.float.info_image_height'))
        .margin({
          right: $r('app.float.info_image_margin_right')
        })
        .borderRadius($r('app.float.info_image_border'))
      Column() {
        Text(this.songList[this.selectIndex].title)
          .fontSize($r('app.float.info_title_size'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.info_title_color'))
        Text(this.songList[this.selectIndex].singer)
          .fontSize($r('app.float.info_singer_size'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.info_singer_color'))
          .lineHeight($r('app.float.info_singer_line_height'))
      }
      .alignItems(HorizontalAlign.Start)

      Blank()
      Image($r('app.media.ic_public_arrow_right'))
        .width($r('app.float.arrow_right_width'))
        .height($r('app.float.arrow_right_height'))
        .onClick(() => {
          router.pushUrl({
            url: RouterUrlConstants.MUSIC_PLAY
          }, router.RouterMode.Single).catch(error => {
            Logger.error('pushUrl failed :' + JSON.stringify(error))
          });
        })
    }
    .height($r('app.float.info_height'))
    .width(StyleConstants.FULL_WIDTH)
    .padding({
      top: $r('app.float.info_padding_top'),
      bottom: $r('app.float.info_padding_bottom')
    })
  }
}