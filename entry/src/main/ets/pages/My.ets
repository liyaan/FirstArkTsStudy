import { HttpUtils } from '../model/HttpUtils'
import MyModel from '../model/MyModel'
import { UserData } from '../model/UserData'
import router from '@ohos.router'
import { StringUtils } from '../common/utils/StringUtils'
import { HttpManager } from '../common/http/HttpManager'
import { PersonDynamicList } from '../model/PersonDynamicList'
import { RequestMethod } from '../common/http/RequestOptions'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { Permission } from './Permission'
import { ToastUtils } from '../model/ToastUtils'
import featureAbility from '@ohos.ability.featureAbility'


// let promise = featureAbility.startAbility(
//   {
//     want:
//     {
//       bundleName: "com.jstest.service",
//       abilityName: "com.jstest.service.ServiceAbility",
//     },
//   }
// );
@Component
export struct My {
  @State name: string = ''
  @State imageUrl: string = ''
  @State info: string = ''
  dialogController: CustomDialogController = new CustomDialogController({
    builder: Permission(
      {
        permissions: ['ohos.permission.APPROXIMATELY_LOCATION'],
        accessText: "获取权限的为定位权限",
        confirm: () => {
          ToastUtils.showOne("获取权限成功")
          this.dialogController.close()
        },
        noPermission: () => {
          ToastUtils.showOne("权限没有获取")
          // this.dialogController.close()
        },
        gotoSetting: () => {
          ToastUtils.showOne("禁止权限需要进入系统设置打开权限")
          this.dialogController.close()
        }
      }
    ),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })
  // @State modelData: MyModel = new MyModel()
  aboutToAppear() {
    UserData.getPrefer("id", (id) => {
      HttpUtils.get('getUserInfoForId/' + id, (json) => {
        let result = json.result;
        this.name = result.name
        this.info = result.blurb
        this.imageUrl = result.head_url
      }, () => {

      })
    }, () => {
    })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.app_icon'))
          .width(100)
          .height(100)
          .borderRadius(50)
        Column() {
          Text(this.name).fontSize(18).fontWeight(FontWeight.Bold).margin({ bottom: 10 })
          Text(this.info).fontSize(14).fontColor('#666')
        }
        .height('100%').alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .margin({ left: 20 })
      }.width('100%')
      .height(150).padding({ left: 25 }).backgroundColor('#ffffff')

      this.item($r('app.media.avocado'), '服务', 15, () => {
        router.pushUrl({
          url: 'pages/AppServer'
        })
      })
      this.item($r('app.media.blueberry'), '发送邮件', 15, () => {
        router.pushUrl({
          url: 'pages/SendEmail'
        })
      })
      this.item($r('app.media.icecream'), '朋友圈', 0, () => {
        router.pushUrl({
          url: "pages/SendInfo",
          params: {
            'signType': 0
          }
        })

      })
      this.item($r('app.media.kiwi'), '歌曲', 0, () => {
        // this.dialogController.open()
        router.pushUrl({
          url: "pages/MusicMainPage",
          params: {
            'signType': 0
          }
        })
      })
      this.item($r('app.media.kiwi'), '图片裁剪', 0, () => {
        // this.dialogController.open()
        router.pushUrl({
          url: "pages/ImageEdit",
          params: {
            'signType': 0
          }
        })
      })
      Button('学习Demo')
        .width('100%')
        .height(40)
        .type(ButtonType.Normal)
        .backgroundColor('#ffffff')
        .fontColor('#222')
        .margin({ top: 10, left: 10, right: 10 })
        .onClick(() => {
          router.pushUrl({
            url: "pages/Index"
          })
        })
      Button('退出')
        .width('100%')
        .height(40)
        .type(ButtonType.Normal)
        .margin({ top: 30, left: 15, right: 15 })
        .onClick(() => {
          router.back({
            url: "pages/Login"
          })
          UserData.clear()
        })
    }.width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
  }

  @Builder item(icon: string | Resource, content: string, top: number, onClickView: () => void) {
    Row() {
      Image(icon)
        .width(40)
        .height(40)
      Text(content).fontColor('#222')
        .fontSize(16)
      Blank()
      Image($r('app.media.right_jiantou_one')).width(10).height(20)
    }
    .width('100%')
    .height(50)
    .padding({ left: 15, right: 15 })
    .backgroundColor('#ffffff')
    .margin({ top: top })
    .borderRadius(5)
    .onClick(() => {
      onClickView()
    })

  }

  sendHttp(header) {
    // ConsoleUtils.log(header.token)
    // HttpUtils.get('getUserInfo', (value) => {
    // }, (err) => {
    // })
    HttpManager.getInstance()
      .request<PersonDynamicList>(
        {
          method: RequestMethod.GET,
          header: header,
          url: 'https://api.apiopen.top/api/getPersonDynamicList'
        }
      )
      .then((result) => {
        router.pushUrl({
          url: "pages/SendInfo",
          params: {
            list: result.result.list
          }
        })
      })
      .catch((err) => {
        ConsoleUtils.error(JSON.stringify(err));
      })
      .finally(() => {
        ConsoleUtils.error("finally");
      });
  }
}