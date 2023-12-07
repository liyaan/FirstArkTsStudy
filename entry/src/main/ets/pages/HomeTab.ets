import router from '@ohos.router'
import { FoodInfo } from '../model/DataModels'
import { My } from './My'
import { PhotoList } from './PhotoList'
import { VideoList } from './VideoList'

@Entry
@Component
struct HomeTab {
  @State currentTabIndex: number = 0

  build() {
    Tabs() {
      TabContent() {
        Foods()
      }.tabBar(this.bar('主页', $r('app.media.ic_bottom_home'), 0))

      TabContent() {
        // Column({ space: 10 }) {
        //   Text("敬请期待第二季").fontSize(26).fontColor(0x3E3E3E)
        //   Text("实战开发教程，会实现全部功能。").fontSize(18).fontColor(0x3E3E3E)
        // }.padding(30)
        // .alignItems(HorizontalAlign.Center)
        if (this.currentTabIndex == 1) {
          PhotoList()
        }

      }.tabBar(this.bar('记录', $r('app.media.ic_bottom_record'), 1))

      TabContent() {
        // Column({ space: 10 }) {
        //   Text("敬请期待第二季").fontSize(26).fontColor(0x3E3E3E)
        //   Text("实战开发教程，会实现全部功能。").fontSize(18).fontColor(0x3E3E3E)
        // }.padding(30)
        // .alignItems(HorizontalAlign.Center)\
        if (this.currentTabIndex == 2) {
          VideoList()
        }

      }.tabBar(this.bar('视频', $r('app.media.ic_public_delete'), 2))

      TabContent() {
        // Column({ space: 10 }) {
        //   Text("敬请期待第二季").fontSize(26).fontColor(0x3E3E3E)
        //   Text("实战开发教程，会实现全部功能。").fontSize(18).fontColor(0x3E3E3E)
        // }.padding(30)
        // .alignItems(HorizontalAlign.Center)\
        if (this.currentTabIndex == 3) {
          My()
        }

      }.tabBar(this.bar('我的', $r('app.media.ic_bottom_home'), 3))
    }.barPosition(BarPosition.End)
    .onChange((index) => {
      this.currentTabIndex = index
    })
  }

  onBackPress() {
    router.clear()
  }

  @Builder
  bar(name: string, icon: Resource, index: number) {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor(this.currentTabIndex === index ? '#55ff55' : '')
      Text(name).fontSize(11).fontColor(0x3E3E3E).margin(10).fontColor(this.currentTabIndex === index ? '#55ff55' : '')
    }
  }
}

@Component
struct Foods {
  @State currentTabIndex: number = 0
  private categories: Array<{
    id: number,
    name: string
  }> =
    [{ id: 1, name: '蔬菜' }, { id: 2, name: '水果' }, { id: 3, name: '坚果' }, { id: 4, name: '海鲜' }]
  private foods: Array<FoodInfo> = [
    {
      id: 0,
      name: '番茄',
      kk: 15,
      category: 1,
      img: $r('app.media.tomato'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 1,
      name: '核桃',
      kk: 646,
      category: 3,
      img: $r('app.media.walnut'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 2,
      name: '黄瓜',
      kk: 16,
      category: 2,
      img: $r('app.media.cucumber'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 3,
      name: '蓝莓',
      kk: 57,
      category: 2,
      img: $r('app.media.blueberry'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 4,
      name: '螃蟹',
      kk: 97,
      category: 4,
      img: $r('app.media.crab'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 5,
      name: '冰淇淋',
      kk: 150,
      category: 5,
      img: $r('app.media.icecream'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 6,
      name: '洋葱',
      kk: 40,
      category: 1,
      img: $r('app.media.onion'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 7,
      name: '蘑菇',
      kk: 20,
      category: 1,
      img: $r('app.media.mushroom'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 8,
      name: '猕猴桃',
      kk: 61,
      category: 2,
      img: $r('app.media.kiwi'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 9,
      name: '火龙果',
      kk: 55,
      category: 2,
      img: $r('app.media.pitaya'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 10,
      name: '草莓',
      kk: 32,
      category: 2,
      img: $r('app.media.strawberry'),
      rl: 0,
      yy: 0,
      zf: 0
    },
    {
      id: 11,
      name: '牛油果',
      kk: 171,
      category: 2,
      img: $r('app.media.avocado'),
      rl: 0,
      yy: 0,
      zf: 0
    },
  ]

  build() {
    Tabs() {
      TabContent() {
        Grid() {
          ForEach(this.foods, (item, index) => {
            GridItem() {
              FoodItem({ food: item })
            }
          })
        }.columnsTemplate('1fr 1fr')
        .rowsGap(10)
        .columnsGap(10)
      }.tabBar(this.bar('所有', 0))

      ForEach(this.categories, (item, index) => {
        TabContent() {
          Grid() {
            ForEach(this.foods.filter(food => food.category === this.currentTabIndex), (item, index) => {
              GridItem() {
                FoodItem({ food: item })
              }
            })
          }.columnsTemplate('1fr 1fr')
          .rowsGap(10)
          .columnsGap(10)
        }.tabBar(this.bar(item.name, item.id))
      })
    }.width('90%')
    .padding({ bottom: 20 })
    .onChange((index) => {
      this.currentTabIndex = index
    })
  }

  @Builder bar(name: string, index: number) {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.Center
    }) {
      Text(name).fontSize(this.currentTabIndex === index ? 20 : 14).fontColor(0x3E3E3E).margin(10)
    }
  }
}

@Component
struct FoodItem {
  private food: FoodInfo

  build() {
    Column() {
      Image(this.food.img)
        .width('100%')
        .height(152)
        .backgroundColor('#f1f3f5')
        .objectFit(ImageFit.Contain)
      Row() {
        Text(this.food.name)
          .fontSize(16)
          .fontColor(0x3E3E3E)
        Blank()
        Text(this.food.kk + '千卡')
          .fontSize(16)
          .fontColor(0x3E3E3E)
      }.width('100%')
      .height(32)
      .backgroundColor('#e5e5e5')
      .padding({ left: 12, right: 12 })
    }.clip(new Rect({ width: '100%', height: '100%', radius: 6 }))
    .onClick(() => {
      console.log(JSON.stringify(this.food))
      router.pushUrl({
        url: 'pages/Detail',
        params: {
          foodInfo: this.food
        }
      })
    })
  }
}