@Component
export struct Header {
  private title: ResourceStr
  private onLeftClick: (event: ClickEvent) => void
  private onRightClick: (event: ClickEvent) => void
  private isVisRight: boolean = false
  private isVisLeft: boolean = true
  private isVisRightText: boolean = false
  private rightText: string = '添加'
  private iconRight: string | Resource = $r('app.media.title_left')

  build() {
    Row() {
      if (this.isVisLeft){
        Image($r('app.media.title_left'))
          .width(15).onClick(this.onLeftClick)
      }

      Text(this.title)
        .fontColor('#000')
        .fontSize(20)
        .fontWeight(FontWeight.Bold).margin({ left: 20 })
      Blank()
      if (this.isVisRight) {
        Image(this.iconRight)
          .width(30).onClick(this.onRightClick)
      }
      if (this.isVisRightText) {
        Text(this.rightText)
          .fontColor('#000')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ right: 20 })
          .onClick(this.onRightClick)
      }

    }.width('100%')
    .height(40)
  }
}

