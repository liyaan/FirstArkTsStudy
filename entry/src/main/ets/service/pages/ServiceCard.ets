let storage = new LocalStorage();

@Entry(storage)
@Component
struct ServiceCard {
  @LocalStorageProp('title') title: string = 'init';
  @LocalStorageProp('detail') detail: string = 'init';
  /*
   * The title.
   */
  readonly TITLE: string = '汤圆卡片';

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
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  build() {
    Column() {
      Row() {
        Image($r('app.media.ty'))
          .width(20)
          .height(20)
        Blank()
        Text(this.TITLE)
          .fontSize(16)
      }
      .width('100%')
      .height(30)
      .alignItems(VerticalAlign.Center)
      .margin(5)
      .padding({ left: 10, right: 10 })


      Button('新闻列表')
        .width('100')
        .height('32')
        .fontSize(16)
        .type(ButtonType.Normal)
        .onClick(() => {
          postCardAction(this, {
            'action': this.ACTION_TYPE,
            'abilityName': 'EntryAbility', // 只能跳转到当前应用下的UIAbility
            'params': {
              'targetPage': 'funA', // 在EntryAbility中处理这个信息
              'detail': "最新"
            }
          });
        })
      Button('商品列表')
        .width('100')
        .height('32')
        .fontSize(16)
        .margin({ top: 5 })
        .type(ButtonType.Normal)
        .onClick(() => {
          postCardAction(this, {
            'action': this.ACTION_TYPE,
            'abilityName': this.ABILITY_NAME, // 只能跳转到当前应用下的UIAbility
            'params': {
              'targetPage': 'funB', // 在EntryAbility中处理这个信息
              'detail': '1001'
            }
          });
        })
      Button('学习页面')
        .width('100')
        .height('28')
        .fontSize(14)
        .margin({ top: 5 })
        .type(ButtonType.Normal)
        .onClick(() => {
          console.info('Jump to EntryAbility funB');
          postCardAction(this, {
            'action': this.ACTION_TYPE,
            'abilityName': this.ABILITY_NAME, // 只能跳转到当前应用下的UIAbility
            'params': {
              'targetPage': 'funC', // 在EntryAbility中处理这个信息
            }
          });
        })
      // Row() {
      //   Text(`${this.title}`).fontSize(12).margin({ left: 5 })
      //   Text(`${this.detail}`).fontSize(12).margin({ left: 5 })
      // }.width('100%')
    }.height(this.FULL_HEIGHT_PERCENT)
    .alignItems(HorizontalAlign.Center)

  }
}