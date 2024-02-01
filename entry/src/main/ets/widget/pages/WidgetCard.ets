@Entry
@Component
struct WidgetCard1 {
  /*
   * The mini title.
   */
  readonly MINI_TITLE: string = '风景';

  /*
   * The item title.
   */
  readonly ITEM_TITLE: string = 'Title';

  /*
   * The item content.
   */
  readonly ITEM_CONTENT: string = 'Introduction';

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
  */
  readonly ABILITY_NAME: string = 'EntryAbility';

  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';

  /*
   * The mini display priority.
   */
  readonly MINI_DISPLAY_PRIORITY: number = 2;

  /*
   * The max line.
   */
  readonly MAX_LINES: number = 1;

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  /*
   * Image height percentage setting.
   */
  readonly IMAGE_HEIGHT_PERCENT: string = '64%';
  @State mini: boolean = false;

  build() {
    Row() {
      Column({ space: 5 }) {
        Text(this.MINI_TITLE)
          .fontSize($r('app.float.normal_content_font_size_14'))
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .maxLines(this.MAX_LINES)
          .textOverflow({ 'overflow': TextOverflow.Ellipsis })
        Image($r("app.media.xue"))
          .width(this.FULL_WIDTH_PERCENT)
          .height(this.IMAGE_HEIGHT_PERCENT)
          .objectFit(ImageFit.Fill)
          .borderRadius($r('app.float.image_border_radius'))
        Blank()
        Text(this.ITEM_TITLE)
          .fontSize($r('app.float.normal_content_font_size_14'))
          .maxLines(this.MAX_LINES)
          .textOverflow({ 'overflow': TextOverflow.Ellipsis })
        Text(this.ITEM_CONTENT)
          .maxLines(this.MAX_LINES)
          .fontSize($r('app.float.normal_content_font_size'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(this.FULL_HEIGHT_PERCENT)
      .alignItems(HorizontalAlign.Start)
      .backgroundColor($r('app.color.start_window_background'))
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .alignItems(VerticalAlign.Top)
    .padding($r('app.float.row_padding'))
    .onClick(() => {
      console.log("UserData Click WidgetCard")
      postCardAction(this, {
        "action": this.ACTION_TYPE,
        "abilityName": this.ABILITY_NAME,
        "params": {
          "message": this.MESSAGE
        }
      });
    })
  }
}