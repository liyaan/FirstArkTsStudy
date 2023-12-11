/**
 * 自定义底部列表菜单弹窗
 */
import { ListMenu } from './ListMenu';

@CustomDialog
export struct ListMenuDialog {
  private title: string;
  @State titleVisible: boolean = true;
  @State menuArray: ListMenu[] = [];
  controller: CustomDialogController;
  onCancel?: () => void;

  @Styles
  itemPressedStyle() {
    .backgroundColor('#e2e2e2')
  }

  @Styles
  itemNormalStyle() {
    .backgroundColor(Color.White)
  }

  build() {
    Column() {
      Text(this.title)
        .fontColor('#999999')
        .fontSize(14)
        .margin({ top: 10 })
        .maxLines(1)
        .visibility(this.titleVisible ? Visibility.Visible : Visibility.None)

      if (this.menuArray.length > 0) {

        Scroll() {
          Column() {
            ForEach(this.menuArray, (item: ListMenu, index: number) => {

              this.MenuItem(item, index)

            }, (index: number) => {
              return index.toString();
            })
          }
        }
        .backgroundColor(Color.White)
        .borderRadius(8)
        .margin({ top: 10 })
        .constraintSize({
          maxHeight: '40%'
        })
      }

      Text('取消')
        .width('100%')
        .height(50)
        .fontColor(Color.Black)
        .fontSize(16)
        .margin({ top: 15 })
        .backgroundColor(Color.White)
        .textAlign(TextAlign.Center)
        .borderRadius(8)
        .stateStyles({
          normal: this.itemNormalStyle,
          pressed: this.itemPressedStyle
        })
        .onClick(() => {
          if (this.controller) {
            this.controller.close();
          }
          if (this.onCancel) {
            this.onCancel();
          }
        })
    }
    .padding(10)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .backgroundColor('#f8f8f8')
    .borderRadius({
      topLeft: 15,
      topRight: 15
    })

  }

  @Builder
  MenuItem(item: ListMenu, index: number) {
    Row() {

      Image(item.icon)
        .width(30)
        .height(30)
        .visibility(item.icon ? Visibility.Visible : Visibility.None)

      Text(item.text)
        .fontColor(item.fontColor ? item.fontColor : Color.Black)
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .margin({ left: 5 })
    }
    .width('100%')
    .height(50)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .borderStyle({ bottom: BorderStyle.Solid })
    .borderColor('#f8f8f8')
    .borderWidth({
      bottom: index === this.menuArray.length - 1 ? 0 : 1
    })
    .stateStyles({
      normal: this.itemNormalStyle,
      pressed: this.itemPressedStyle
    })
    .onClick(() => {
      if (this.controller) {
        this.controller.close();
      }
      if (item.onItemClick) {
        item.onItemClick();
      }
    })
  }
}


