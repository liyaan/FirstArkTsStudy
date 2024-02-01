
import { BreakpointType } from '../../common/music/BreakpointSystem';
import { ControlConstants } from '../../common/music/ControlConstants';
import { PlayConstants } from '../../common/music/PlayConstants';
import { RouterUrlConstants } from '../../common/music/RouterUrlConstants';
import { StyleConstants } from '../../common/music/StyleConstants';
import { SongItem } from '../../model/SongData';
import { MusicList } from '../../viewmodel/MusicList';
import { playImage } from '../../viewmodel/PlayData';
import router from '@ohos.router';
import Logger from '@ohos/imagelibrary/src/main/ets/components/data/Logger';
import { PlayControlModel } from '../../model/PlayControlModel';

@Component
export struct MusicInfoComponent {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @StorageProp('selectIndex') selectIndex: number = 0;
  songList: SongItem[] = MusicList;

  build() {
    Column() {
      GridRow({
        columns: { sm: PlayConstants.COLUMN_FOUR, md: PlayConstants.COLUMN_EIGHT, lg: PlayConstants.COLUMN_TWELVE },
        gutter: PlayConstants.GRID_COL_GUTTER
      }) {
        GridCol({
          span: { sm: PlayConstants.SPAN_FOUR, md: PlayConstants.SPAN_FOUR, lg: PlayConstants.SPAN_FOUR },
          offset: { md: PlayConstants.OFFSET_TWO, lg: PlayConstants.OFFSET_ONE }
        }) {
          this.CoverInfo()
        }

        GridCol({
          span: { sm: PlayConstants.SPAN_FOUR, md: PlayConstants.SPAN_SIX, lg: 0 },
          offset: { md: PlayConstants.OFFSET_THREE }
        }) {
          this.MusicInfo()
        }
      }

      Blank()
      GridRow({
        columns: { sm: PlayConstants.COLUMN_FOUR, md: PlayConstants.COLUMN_EIGHT, lg: PlayConstants.COLUMN_TWELVE },
        gutter: PlayConstants.GRID_COL_GUTTER
      }) {
        GridCol({
          span: { sm: PlayConstants.SPAN_FOUR, md: PlayConstants.SPAN_SIX, lg: PlayConstants.SPAN_FOUR },
          offset: { md: PlayConstants.OFFSET_ONE, lg: PlayConstants.OFFSET_ONE }
        }) {
          this.OperationInfo()
        }
      }
    }
    .margin({ left: $r('app.float.twenty_four'), right: $r('app.float.twenty_four') })
    .height(StyleConstants.FULL_HEIGHT)
  }

  @Builder CoverInfo() {
    Image(this.songList[this.selectIndex].label)
      .constraintSize({ maxWidth: new BreakpointType({
        sm: $r('app.float.cover_image_width'),
        md: $r('app.float.cover_image_width'),
        lg: $r('app.float.cover_image_width_lg')
      }).getValue(this.currentBreakpoint) })
      .width(StyleConstants.FULL_WIDTH)
      .aspectRatio(1)
      .borderRadius($r('app.float.cover_radius'))
      .margin({
        left: new BreakpointType({
          sm: $r('app.float.cover_margin_left_sm')
        }).getValue(this.currentBreakpoint),
        right: new BreakpointType({
          sm: $r('app.float.cover_margin_right_sm')
        }).getValue(this.currentBreakpoint),
        top: new BreakpointType({
          sm: $r('app.float.cover_margin_top_sm'),
          md: $r('app.float.cover_margin_top_md'),
          lg: $r('app.float.cover_margin_top_lg')
        }).getValue(this.currentBreakpoint)
      })
  }

  @Builder MusicInfo() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text(this.songList[this.selectIndex].title)
          .fontSize($r('app.float.font_twenty_four'))
          .fontColor($r('app.color.text_color'))
        Image($r('app.media.ic_like'))
          .width($r('app.float.twenty_four'))
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)

      }

      Text(this.songList[this.selectIndex].singer)
        .textAlign(TextAlign.Start)
        .fontSize($r('app.float.font_fourteen'))
        .fontColor($r("app.color.text_sixty_color"))
        .margin({ top: $r('app.float.music_text_margin_top') })
        .width(StyleConstants.FULL_WIDTH)
    }
    .margin({ top: $r('app.float.music_info_margin_top') })
  }

  @Builder OperationInfo() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      ForEach(playImage, (item: PlayControlModel) => {
        Image(item.icon)
          .aspectRatio(1)
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.operation_image_width_lg')
          }).getValue(this.currentBreakpoint))
          .objectFit(ImageFit.Contain)
          .onClick(() => this.controlClick(item.key))
      }, (item: PlayControlModel) => JSON.stringify(item))
    }
  }

  controlClick(key: string) {
    if (key === ControlConstants.REVIEW) {
      router.pushUrl({
        url: RouterUrlConstants.MUSIC_COMMENT
      }, router.RouterMode.Single).catch(error => {
          Logger.error('pushUrl failed :' + JSON.stringify(error));
        })
    }
  }
}