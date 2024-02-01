import { BreakpointConstants } from '../../common/music/BreakpointConstants';
import { StyleConstants } from '../../common/music/StyleConstants';
import { AlbumComponent } from './AlbumComponent';
@Component
export struct AlbumCover {
  @Link currentBreakpoint: string;

  build() {
    if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM) {
      AlbumComponent({ currentBreakpoint: $currentBreakpoint })
    } else {
      AlbumComponent({ currentBreakpoint: $currentBreakpoint })
        .height(StyleConstants.FULL_HEIGHT)
    }
  }
}