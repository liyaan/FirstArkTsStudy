import { HttpManager } from '../common/http/HttpManager'
import { RequestMethod } from '../common/http/RequestOptions'
import { StringUtils } from '../common/utils/StringUtils'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { PersonDynamicBeanList, PersonDynamicBeanListImage, PersonDynamicList } from '../model/PersonDynamicList'
import { ListRefresh } from './ListRefresh'
import router from '@ohos.router'
import { ToastUtils } from '../model/ToastUtils'
import { Header } from './header'
import { ALL_PERCENT, MARGIN_FONT_SIZE, STRING_PERCENT } from '../common/constants/CommonConstants'
import { HttpUtils } from '../model/HttpUtils'


@Entry
@Component
struct SendInfo {
  @State list: Array<PersonDynamicBeanList> = []
  page: number = 0
  isMoreLoad: boolean = true
  isDownLoad: boolean = false
  @State isRefreshing: boolean = false
  @State firstIndex: number = 0
  @State lastIndex: number = 0
  private signType: number = (router.getParams() as Record<string, Object>).signType as number;
  private scrollerForScroll: Scroller = new Scroller()
  private scrollerForList: Scroller = new Scroller()
  private downY = 0

  onPageShow() {
    this.isMoreLoad = false
    this.list = []
    this.page = 0
    this.setRequest()
    ConsoleUtils.log("isDownLoad:" + this.isDownLoad)
  }

  build() {
    Column({ space: 8 }) {
      Header({ title: '消息', onLeftClick: () => {
        router.back()
      }, isVisRightText: true, onRightClick: () => {
        router.pushUrl({
          url: 'pages/AddInfo'
        })
      } }).padding({ left: 15 }).margin({ bottom: 10, top: 10 })
      // Refresh({ refreshing: $$this.isRefreshing, friction: 100 }) {
      //   Scroll(this.scrollerForScroll) {
      //
      //
      //   }.width('100%').height('100%')
      // }.onStateChange((refreshStatus: RefreshStatus) => {
      //   ConsoleUtils.info('Refresh onStatueChange state is ' + refreshStatus)
      // }).onRefreshing(() => {
      //   setTimeout(() => {
      //     this.list = []
      //     this.page = 0
      //     this.isRefreshing = false
      //     ConsoleUtils.log('onRefreshing test ' + this.isRefreshing)
      //     this.setRequest()
      //   }, 1000)
      // })
      List({ scroller: this.scrollerForList }) {
        ForEach(this.list, (item: PersonDynamicBeanList, index) => {
          ListItem() {
            this.itemView(item)
          }
        })
      }
      .listDirection(Axis.Vertical)
      .width("100%")
      .layoutWeight(1)
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        ConsoleUtils.log("firstIndex:" + firstIndex + ","
        + "lastIndex:" + lastIndex + ",this.isMoreLoad:"
        + this.isMoreLoad + ", this.list.length:" + this.list.length)
        this.lastIndex = lastIndex
      })
      .onScrollStop(() => {
        if (this.lastIndex == this.list.length - 1 && !this.isMoreLoad) {
          this.isMoreLoad = true
          this.page++
          this.setRequest()
        }
      })
      // ListRefresh({ list: this.list,
      //   refreshDataList: (list) => {
      //     this.page = 0
      //     ConsoleUtils.log("refreshDataList")
      //     for (let index = 0; index < this.list.length; index++) {
      //       const element = this.list[index];
      //       list.push(element)
      //     }
      //   },
      //   loadMoreDataList: (list) => {
      //     ConsoleUtils.log("loadMoreDataList")
      //     this.page++
      //     this.setRequest(list)
      //
      //   } })
    }.width("100%")
    .height('100%')
    .backgroundColor($r("app.color.index_backgroundColor"))
  }

  @Builder itemView(item: PersonDynamicBeanList) {
    Column({ space: MARGIN_FONT_SIZE.FOURTH_MARGIN }) {
      List({ space: MARGIN_FONT_SIZE.FIRST_MARGIN }) {
        ForEach(item.images, (image: PersonDynamicBeanListImage, index) => {
          ListItem() {
            Image(image.url)
              .width(MARGIN_FONT_SIZE.SEVENTH_MARGIN)
              .height(MARGIN_FONT_SIZE.SIXTH_MARGIN)
          }
        })
      }.listDirection(Axis.Horizontal)

      Text(item.text)
        .margin({
          top: MARGIN_FONT_SIZE.FIRST_MARGIN,
          bottom: MARGIN_FONT_SIZE.FIRST_MARGIN
        })
        .textAlign(TextAlign.Center)
        .fontSize(MARGIN_FONT_SIZE.SECOND_MARGIN)
    }
    .margin({
      left: STRING_PERCENT.INDEX_SWIPER_LEFT_RIGHT_MARGIN,
      right: STRING_PERCENT.INDEX_SWIPER_LEFT_RIGHT_MARGIN,
      top: MARGIN_FONT_SIZE.FIRST_MARGIN
    })
    .width(STRING_PERCENT.INDEX_COMPONENT_WITH_PERCENT)
    .justifyContent(FlexAlign.Center)
    .borderRadius(MARGIN_FONT_SIZE.FOURTH_MARGIN)
    .borderStyle(BorderStyle.Solid)
    .borderColor(Color.White)
    .backgroundColor($r('app.color.white'))
    .onClick(() => {
      this.sendDel(item.id)
    })

  }

  setRequest() {
    var header = {
      'Content-Type': 'application/json',
      'token': StringUtils.TOKEN_STRING
    }
    HttpManager.getInstance()
      .request<PersonDynamicList>(
        {
          method: RequestMethod.GET,
          header: header,
          url: 'https://api.apiopen.top/api/getPersonDynamicList?page=' + this.page + "&size=10"
        }
      )
      .then((result) => {
        // this.list = result.result.list
        let initValue = result.result.list.length
        if (initValue > 0) {
          for (var i = 0; i < initValue; i++) {
            const element = result.result.list[i];
            this.list.push(element)
          }
          if (initValue < 10) {
            this.isMoreLoad = true
          } else {
            this.isMoreLoad = false
          }
        } else {
          this.isMoreLoad = true
          ToastUtils.showOne("暂无更多数据")
          this.page--
        }

      })
      .catch((err) => {
        this.page--
        this.isMoreLoad = false
        ConsoleUtils.error(JSON.stringify(err));
      })
      .finally(() => {
        this.isDownLoad = true
        ConsoleUtils.error("finally");
      });
  }

  sendDel(id) {
    HttpUtils.post({ 'id': id }, 'delPersonDynamicList', (json) => {
      let code = json.code
      if (code == 200) {
        this.list = this.list.filter(item => item.id !== id)
        ToastUtils.showOne("删除成功")
      }

    }, (err) => {

    })
  }
}

