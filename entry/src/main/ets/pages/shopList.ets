import { Header } from '../pages/header'
// 导入router模块
import router from '@ohos.router';

class Item {
  name: string;
  price: number;
  image: ResourceStr;
  zk: number

  constructor(name: string, price: number, image: ResourceStr, zk: number = 0) {
    this.name = name
    this.price = price
    this.image = image
    this.zk = zk
  }
}

//特定组件的样式
@Extend(Text) function textPriceStyle() {
  .fontSize(18)
  .fontColor("#F36")
}

//全局的
// @Builder function ItemCard(item:Item){
//   Row({space:10}){
//     Image(item.image).width(100).margin({left:10})
//
//     Column({space:5}){
//       Text(item.name)
//         .fontSize(20)
//         .fontWeight(FontWeight.Bold)
//       if (!item.zk) {
//         Text(item.price.toFixed(0))
//           .fontSize(18)
//           .fontColor("#F36")
//       }else{
//         Text("原价:"+item.price.toFixed(0))
//           .fontSize(18)
//           .decoration({
//             type:TextDecorationType.LineThrough,
//             color:"#ccc"
//           })
//           .fontColor("#CCC")
//         Text("折扣价格:"+(item.price-item.zk)).fontColor("#f36")
//         Text("折扣金额:"+item.zk).fontColor("#f36")
//       }
//
//     }.height("100%").padding({top:10,bottom:10})
//   }.width('100%').height(120)
//   .backgroundColor("#f0f0f0")
//   .borderRadius(10)
// }
// //全局公用样式
// @Styles function fullCommon(){
//   .width('100%')
//   .height('100%')
//   .padding({left:15,right:15})
// }

let storageNew = LocalStorage.GetShared()

@Entry(storageNew)
@Component
struct ShopList {
  @LocalStorageLink('newTypeDetail') newTypeDetail: string = ""
  private items: Array<Item> = [
    new Item("小米9", 3999, $r('app.media.icon'), 900),
    new Item("小米10", 4999, $r('app.media.icon')),
    new Item("小米11", 5999, $r('app.media.icon')),
    new Item("小米12", 6999, $r('app.media.icon')),
    new Item("小米13", 7999, $r('app.media.icon')),
    new Item("小米14", 8999, $r('app.media.icon')),
    new Item("红米70", 9999, $r('app.media.icon'))
  ]

  build() {
    Column({ space: 8 }) {
      Header({ title: "商品列表", onLeftClick: (ev: ClickEvent) => {
        router.back()
      }, isVisLeft: this.newTypeDetail === '1001' ? false : true })
        .margin({ bottom: 20, top: 20 })

      List({ space: 5 }) {
        ForEach(
          this.items,
          (item: Item) => {
            ListItem() {
              this.ItemCardOne(item)
            }
          }
        )
      }.width("100%")
      .layoutWeight(1)
      .listDirection(Axis.Vertical)

    }.fullOneCommon()

  }
  //内部
  @Styles fullOneCommon(){
    .width('100%')
    .height('100%')
    .padding({ left: 15, right: 15 })
  }
  //内部调用
  @Builder ItemCardOne(item: Item) {
    Row({ space: 10 }) {
      Image(item.image).width(100).margin({ left: 10 })

      Column({ space: 5 }) {
        Text(item.name)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        if (!item.zk) {
          Text(item.price.toFixed(0))
            .textPriceStyle()
        } else {
          Text("原价:" + item.price.toFixed(0))
            .fontSize(18)
            .decoration({
              type: TextDecorationType.LineThrough,
              color: "#ccc"
            })
            .fontColor("#CCC")
          Text("折扣价格:" + (item.price - item.zk)).textPriceStyle()
          Text("折扣金额:" + item.zk).textPriceStyle()
        }

      }.height("100%").padding({ top: 10, bottom: 10 })
    }.width('100%').height(120)
    .backgroundColor("#f0f0f0")
    .borderRadius(10)
  }
}