const MSG_SEND_ACTION_CALL: string = 'call';
const MSG_SEND_ACTION_ROUTER: string = 'router';
const MSG_SEND_METHOD: string = 'CallSendMsgForm';
const ABILITY_NAME = 'EntryAbility';
const MSG_SEND_PLAY = 'play';
const MSG_SEND_PAUSE = 'pause';
const MSG_SEND_NEXT = 'next';

let storageCard = new LocalStorage();

@Entry(storageCard)
@Component
struct MusicCard {
  /**
   * The cover image height.
   */
  readonly COVER_IMAGE_HEIGHT: string = '76%';

  /**
   * The play icon height.
   */
  readonly PLAY_IMAGE_HEIGHT: string = '44%';

  /**
   * The stack image left.
   */
  readonly STACK_MARGIN_LEFT: string = '4%';

  /**
   * The text margin left.
   */
  readonly TEXT_MARGIN_LEFT: string = '4%';

  /**
   * The text width.
   */
  readonly TEXT_WIDTH: string = '50%';

  /**
   * The next image width.
   */
  readonly NEXT_IMAGE_WIDTH: string = '13%';

  /**
   * The next image margin right.
   */
  readonly NEXT_IMAGE_MARGIN_RIGHT: string = '9%';

  /**
   * The full percent.
   */
  readonly FULL_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  @LocalStorageProp('isPlay') isPlay: boolean = false;
  @LocalStorageProp('musicName') musicName: string = '独立民谣';
  @LocalStorageProp('musicCover') musicCover: Resource = $r('app.media.ic_avatar1');
  @LocalStorageProp('musicSinger') musicSinger: string = 'Katy Perry';

  routerToMainPage() {
    postCardAction(this, {
      'action': MSG_SEND_ACTION_ROUTER,
      'abilityName': ABILITY_NAME,
      'params': {
        'targetPage': MSG_SEND_PLAY
      }
    });
  }

  onCallOperation(sendMessage: string) {
    postCardAction(this, {
      'action': MSG_SEND_ACTION_CALL,
      'abilityName': ABILITY_NAME,
      'params': {
        'method': MSG_SEND_METHOD,
        'targetPage': sendMessage
      }
    });
  }

  build() {
    Row() {
      Stack() {
        Image(this.musicCover)
          .height(this.COVER_IMAGE_HEIGHT)
          .aspectRatio(1)
          .borderRadius($r('app.float.image_border_radius'))
        Image(this.isPlay ? $r('app.media.ic_play_normal') : $r('app.media.ic_Pause_normal'))
          .height(this.PLAY_IMAGE_HEIGHT)
          .height('44%')
          .aspectRatio(1)
          .onClick(() => {
            let sendMessage = this.isPlay ? MSG_SEND_PAUSE : MSG_SEND_PLAY;
            this.onCallOperation(sendMessage);
          })
      }

      Text(this.musicName)
        .width(this.TEXT_WIDTH)
        .fontSize($r('app.float.text_font_size'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.item_title_font'))
        .margin({ left: this.TEXT_MARGIN_LEFT })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)

      Blank()

      Image($r('app.media.ic_next_grey'))
        .width($r('app.float.image_option'))
        .aspectRatio(1)
        .onClick(() => {
          this.onCallOperation(MSG_SEND_NEXT);
        })
    }
    .padding({
      left: this.STACK_MARGIN_LEFT,
      right: this.STACK_MARGIN_LEFT
    })
    .height(this.FULL_HEIGHT_PERCENT)
    .width(this.FULL_PERCENT)
    .backgroundColor($r('app.color.card1_background'))
    .onClick(() => {
      this.routerToMainPage();
    })
  }
}