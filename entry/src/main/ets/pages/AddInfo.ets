import { Header } from './header'
import router from '@ohos.router'
import { ToastUtils } from '../model/ToastUtils'
import { ListMenuDialog } from '../common/dialog/ListMenuDialog'
import { MediaHelper } from '../common/selectFile/MediaHelper'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { ListMenu } from '../common/dialog/ListMenu'
import { HttpUtils } from '../model/HttpUtils'
import { ImageData } from '../common/selectFile/ImageDatas'


@Entry
@Component
struct AddInfo {
  @State listImage: Array<string | Resource> = []
  submitList: Array<string | Resource>
  title: string = '今天心情真好!'
  private customDialogController: CustomDialogController;

  aboutToAppear() {
    this.listImage.push($r('app.media.app_icon'))
  }

  build() {
    Column({ space: 8 }) {
      Header({
        title: '添加消息',
        onLeftClick: () => {
          router.back()
        },
        isVisRightText: true,
        rightText: '添加',
        onRightClick: () => {

          this.submitList = this.listImage
          this.submitList = this.submitList.filter(
            item => item !== undefined
          )
          this.submitList.splice(0, 1)
          // for (let index = 0; index < this.submitList.length; index++) {
          //   const element = this.submitList[index];
          //   ConsoleUtils.log(element)
          // }
          let data = {
            "images": this.submitList,
            "text": this.title
          }
          this.sendAddIndo(data)
        }
      }).padding({ left: 15 }).margin({ bottom: 10, top: 10 })

      TextInput({ placeholder: '请输入标题' })
        .maxLength(15)
        .TextInputStyle()
        .onChange((value) => {
          this.title = value
        })
      Grid() {
        ForEach(this.listImage, (item, index) => {
          GridItem() {
            this.AddInfoItem(item, index)
          }
        }, item => item)
      }.columnsTemplate('1fr 1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
    }.width('100%')
    .height('100%').backgroundColor('#f0f0f0')
    .padding({ left: 15, right: 15 })
  }

  sendAddIndo(data) {

    HttpUtils.post(data, 'publishDynamic', (json) => {
      let code = json.code
      if (code == 200) {
        ToastUtils.showOne('添加成功')
        router.back({ url: 'pages/SendInfo',
          params: {
            'signType': 1
          } })
      }
    }, (err => {

    }))
  }

  @Builder AddInfoItem(item: string | Resource, index: number) {

    Column() {
      Image(item)
        .width('100%')
        .height(152)
        .backgroundColor('#f1f3f5')
        .objectFit(ImageFit.Contain)
    }.clip(new Rect({ width: '100%', height: '100%', radius: 6 }))
    .onClick(() => {
      if (index == 0) {
        this.showButtonDialog()
        ToastUtils.showOne('添加图片')
      }
    })

  }

  getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  showButtonDialog() {
    const menuList: ListMenu[] = [
      {
        id: '1',
        text: '选择图片',
        fontColor: $r("app.color.blue_089ed9"),
        onItemClick: () => {
          MediaHelper.prototype.selectPicture().then((filePath) => {
            ConsoleUtils.log(filePath.fileName)
          }).finally(() => {
            let num = this.getRandomInt(0, ImageData.images.length - 1)

            this.listImage.push(ImageData.images[num])
          })
        }
      },
      {
        id: '2',
        text: '选择文件',
        fontColor: $r("app.color.blue_089ed9"),
        onItemClick: () => {
          console.log('点击了选择文件');
        }
      },
      {
        id: '3',
        text: '拍照',
        fontColor: $r("app.color.blue_089ed9"),
        onItemClick: () => {
          console.log('点击了拍照');
        }
      },
    ];
    //不同文本颜色效果
    // const menuList: ListMenu[] = [
    //   {
    //     id: '1',
    //     text: '选择图片',
    //     fontColor: $r("app.color.blue_089ed9"),
    //     onItemClick: () => {
    //       console.log('点击了选择图片');
    //     }
    //   },
    //   {
    //     id: '2',
    //     text: '选择文件',
    //     fontColor: $r("app.color.green_2f7e04"),
    //     onItemClick: () => {
    //       console.log('点击了选择文件');
    //     }
    //   }
    // ]
    //设置文本颜色效果
    // const menuList: ListMenu[] = [
    //   {
    //     id: '1',
    //     text: '选择图片',
    //     fontColor: $r("app.color.blue_089ed9"),
    //     onItemClick: () => {
    //       console.log('点击了选择图片');
    //     }
    //   },
    //   {
    //     id: '2',
    //     text: '选择文件',
    //     fontColor: $r("app.color.blue_089ed9"),
    //     onItemClick: () => {
    //       console.log('点击了选择文件');
    //     }
    //   }
    // ]

    this.customDialogController = new CustomDialogController({
      //有标题
      //builder: ListMenuDialog(
      //         {
      //           title: '多媒体操作',
      //           menuArray: menuList,
      //           controller: this.customDialogController
      //         }),
      //无标题
      builder: ListMenuDialog(
        {
          menuArray: menuList,
          controller: this.customDialogController
        }),
      cancel: () => {
        console.log('点击了取消');
      },
      autoCancel: true,
      alignment: DialogAlignment.Bottom,
      customStyle: true
    });
    this.customDialogController.open();
  }

  hideBottomDialog() {
    this.customDialogController.close();
  }
}

@Extend(TextInput) function TextInputStyle() {
  .fontSize(18)
  .fontColor('#222')
  .borderRadius(10)
  .margin({ top: 15 })
}


