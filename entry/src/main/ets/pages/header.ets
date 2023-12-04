@Component
export struct Header {
  private title: ResourceStr
  private onLeftClick: (event: ClickEvent) => void
  private onRightClick: (event: ClickEvent) => void
  private isVisRight: boolean = false

  build() {
    Row() {
      Image($r('app.media.title_left'))
        .width(15).onClick(this.onLeftClick)
      Text(this.title)
        .fontColor('#000')
        .fontSize(20)
        .fontWeight(FontWeight.Bold).margin({ left: 20 })
      Blank()
      if (this.isVisRight) {
        Image($r('app.media.title_left'))
          .width(30).onClick(this.onRightClick)
      }

    }.width('100%')
    .height(40)
  }
}

