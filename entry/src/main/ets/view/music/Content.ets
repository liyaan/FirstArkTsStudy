import { GridConstants } from '../../common/music/GridConstants';
import { PlayList } from './PlayList';
import { StyleConstants } from '../../common/music/StyleConstants';
import { AlbumCover } from './AlbumCover';

@Component
export struct Content {
  @Link currentBreakpoint: string;

  build() {
    GridRow() {
      GridCol({ span: { sm: GridConstants.SPAN_TWELVE, md: GridConstants.SPAN_SIX, lg: GridConstants.SPAN_FOUR } }) {
        AlbumCover({ currentBreakpoint: $currentBreakpoint })
      }
      .backgroundColor($r('app.color.album_background'))

      GridCol({ span: { sm: GridConstants.SPAN_TWELVE, md: GridConstants.SPAN_SIX, lg: GridConstants.SPAN_EIGHT } }) {
        PlayList({ currentBreakpoint: $currentBreakpoint })
      }
      .borderRadius($r('app.float.playlist_border_radius'))
    }.height(StyleConstants.FULL_HEIGHT)
    .onBreakpointChange((breakpoints: string) => {
      this.currentBreakpoint = breakpoints;
    })
  }
}