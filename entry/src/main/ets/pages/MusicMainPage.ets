import { BreakpointConstants } from '../common/music/BreakpointConstants';
import { BreakpointSystem } from '../common/music/BreakpointSystem';
import { SongConstants } from '../common/music/SongConstants'
import { StyleConstants } from '../common/music/StyleConstants';
import { MediaService } from '../common/utils/MediaService';
import { Content } from '../view/music/Content';
import { Player } from '../view/music/Player';

@Entry
@Component
struct MusicMainPage {
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @State currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  aboutToAppear() {
    MediaService.getInstance();
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }
  build() {
    Stack({ alignContent: Alignment.Top }) {
      Content({ currentBreakpoint: $currentBreakpoint })
      Player({ currentBreakpoint: $currentBreakpoint })
    }.width(StyleConstants.FULL_WIDTH)
    .backgroundColor(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
    $r('app.color.page_background_sm') : $r('app.color.page_background_other'))
  }

  pageTransition() {
    PageTransitionEnter({ duration: SongConstants.TRANSITION_DURATION, curve: Curve.Smooth })
    PageTransitionExit({ duration: SongConstants.TRANSITION_DURATION, curve: Curve.Smooth })
  }
}