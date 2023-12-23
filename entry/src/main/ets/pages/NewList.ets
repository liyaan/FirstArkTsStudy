let storageNew = LocalStorage.GetShared()

@Entry(storageNew)
@Component
struct NewList {
  @LocalStorageLink('newTypeDetail') newTypeDetail: string = ""

  build() {
    Column() {
      Text("新闻页面:" + this.newTypeDetail).fontSize(20)
    }.width('100%')
    .alignItems(HorizontalAlign.Center)
  }
}