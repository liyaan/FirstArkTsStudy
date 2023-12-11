import { ConsoleUtils } from '../model/ConsoleUtils'

@Component
export struct ListRefresh {
  @State list: Array<any> = []
  // 列表y坐标偏移量
  @State offsetY: number = 0
  // 按下的y坐标
  private downY = 0
  // 上一次移动的y坐标
  private lastMoveY = 0
  // 当前列表首部的索引
  private startIndex = 0
  // 当前列表尾部的索引
  private endIndex = 0

  // 下拉刷新的布局高度
  private pullRefreshHeight = 70
  // 下拉刷新文字：下拉刷新、松开刷新、正在刷新、刷新成功
  @State pullRefreshText: string = '下拉刷新'
  // 下拉刷新图标：与文字对应
  @State pullRefreshImage: Resource = $r("app.media.ic_pull_refresh_down")
  // 是否可以刷新：未达到刷新条件，收缩回去
  private isCanRefresh = false
  // 是否正在刷新：刷新中不进入触摸逻辑
  private isRefreshing: boolean = false
  // 是否已经进入了下拉刷新操作
  private isPullRefreshOperation = false

  // 上拉加载的布局默认高度
  private loadMoreHeight = 70
  // 上拉加载的布局是否显示
  @State isVisibleLoadMore: boolean = false
  // 是否可以加载更多
  private isCanLoadMore = false
  // 是否加载中：加载中不进入触摸逻辑
  private isLoading: boolean = false
  // @BuilderParam itemViewMain: (any) => void
  private refreshDataList: (list) => void
  private loadMoreDataList: (list) => void

  aboutToAppear() {
    this.list
    for (let index = 0; index < this.list.length; index++) {
      const element = this.list[index];
      ConsoleUtils.log(element.text)

    }
  }
  // 自定义下拉刷新布局
  @Builder CustomPullRefreshLayout() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image(this.pullRefreshImage)
        .width(18)
        .height(18)

      Text(this.pullRefreshText)
        .margin({ left: 7, bottom: 1 })
        .fontSize(17)
    }
    .width('100%')
    // 布局跟着列表偏移量移动
    .offset({ x: 0, y: `${vp2px(-this.pullRefreshHeight) + this.offsetY}px` })
  }

  // 自定义加载更多布局
  @Builder CustomLoadMoreLayout() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Image($r("app.media.ic_loading"))
        .width(18)
        .height(18)

      Text('加载更多中...')
        .margin({ left: 7, bottom: 1 })
        .fontSize(17)
    }
    .width('100%')
    .height(this.loadMoreHeight)
    .backgroundColor('#f4f4f4')
    .visibility(this.isVisibleLoadMore ? Visibility.Visible : Visibility.None)
  }

  // 刷新测试数据
  private refreshData() {
    this.list = []
    // for (var i = 0; i < 10; i++) {
    //   this.list.push(i)
    // }
    this.refreshDataList(this.list)
  }

  // 加载更多测试数据
  private loadMoreData() {
    // let initValue = this.list[this.list.length-1] + 1
    // for (var i = initValue; i < initValue + 10; i++) {
    //   this.list.push(i)
    // }
    this.loadMoreDataList(this.list)
  }

  build() {
    Column() {
      // 下拉刷新布局
      this.CustomPullRefreshLayout()
      // this.itemViewMain()
      // 列表布局
      List() {

        ForEach(this.list, item => {
          ListItem() {
            Column() {
              Text(item.text).padding(15)
                .fontSize(18)
            }
          }
        })

        // 加载更多布局
        ListItem() {
          this.CustomLoadMoreLayout()
        }
      }
      .backgroundColor(Color.White) // 背景
      .divider({ color: '#e2e2e2', strokeWidth: 1 }) // 分割线
      .edgeEffect(EdgeEffect.None) // 去掉回弹效果
      .offset({ x: 0, y: `${this.offsetY}px` }) // touch事件计算的偏移量单位是px，记得加上单位
      .onScrollIndex((start, end) => { // 监听当前列表首位索引
        console.info(`${start}=start============end=${end}`)
        this.startIndex = start
        this.endIndex = end
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4f4f4')
    .onTouch((event) => this.listTouchEvent(event)) // 父容器设置touch事件，当列表无数据也可以下拉刷新
    .onAppear(() => {
      this.refreshData()
    })
  }

  // 触摸事件
  listTouchEvent(event: TouchEvent) {
    switch (event.type) {
      case TouchType.Down: // 手指按下
      // 记录按下的y坐标
        this.downY = event.touches[0].y
        this.lastMoveY = event.touches[0].y
        break
      case TouchType.Move: // 手指移动
      // 下拉刷新中 或 加载更多中，不进入处理逻辑
        if (this.isRefreshing || this.isLoading) {
          console.info('========Move刷新中，返回=========')
          return
        }
      // 判断手势
        let isDownPull = event.touches[0].y - this.lastMoveY > 0
      // 下拉手势 或 已经进入了下拉刷新操作
        if ((isDownPull || this.isPullRefreshOperation) && !this.isCanLoadMore) {
          this.touchMovePullRefresh(event)
        } else {
          this.touchMoveLoadMore(event)
        }
        this.lastMoveY = event.touches[0].y
        break
      case TouchType.Up: // 手指抬起
      case TouchType.Cancel: // 触摸意外中断：来电界面
      // 刷新中 或 加载更多中，不进入处理逻辑
        if (this.isRefreshing || this.isLoading) {
          console.info('========Up刷新中，返回=========')
          return
        }
        if (this.isPullRefreshOperation) {
          this.touchUpPullRefresh()
        } else {
          this.touchUpLoadMore()
        }
        break
    }
  }

  //============================================下拉刷新==================================================
  // 手指移动，处理下拉刷新
  touchMovePullRefresh(event: TouchEvent) {
    // 当首部索引位于0
    if (this.startIndex == 0) {
      this.isPullRefreshOperation = true
      // 下拉刷新布局高度
      var height = vp2px(this.pullRefreshHeight)
      // 滑动的偏移量
      this.offsetY = event.touches[0].y - this.downY

      // 偏移量大于下拉刷新布局高度，达到刷新条件
      if (this.offsetY >= height) {
        // 状态1：松开刷新
        this.pullRefreshState(1)
        // 偏移量的值缓慢增加
        this.offsetY = height + this.offsetY * 0.15
      } else {
        // 状态0：下拉刷新
        this.pullRefreshState(0)
      }

      if (this.offsetY < 0) {
        this.offsetY = 0
        this.isPullRefreshOperation = false
      }
    }
  }

  // 手指抬起，处理下拉刷新
  touchUpPullRefresh() {
    // 是否可以刷新
    if (this.isCanRefresh) {
      console.info('======执行下拉刷新========')
      // 偏移量为下拉刷新布局高度
      this.offsetY = vp2px(this.pullRefreshHeight)
      // 状态2：正在刷新
      this.pullRefreshState(2)

      // 模拟耗时操作
      setTimeout(() => {
        this.refreshData()
        this.closeRefresh()
      }, 2000)

    } else {
      console.info('======关闭下拉刷新！未达到条件========')
      // 关闭刷新
      this.closeRefresh()
    }
  }

  // 下拉刷新状态
  // 0下拉刷新、1松开刷新、2正在刷新、3刷新成功
  pullRefreshState(state: number) {
    switch (state) {
      case 0:
      // 初始状态
        this.pullRefreshText = '下拉刷新'
        this.pullRefreshImage = $r("app.media.ic_pull_refresh_down")
        this.isCanRefresh = false
        this.isRefreshing = false
        break;
      case 1:
        this.pullRefreshText = '松开刷新'
        this.pullRefreshImage = $r("app.media.ic_pull_refresh_up")
        this.isCanRefresh = true
        this.isRefreshing = false
        break;
      case 2:
        this.offsetY = vp2px(this.pullRefreshHeight)
        this.pullRefreshText = '正在刷新'
        this.pullRefreshImage = $r("app.media.ic_loading")
        this.isCanRefresh = true
        this.isRefreshing = true
        break;
      case 3:
        this.pullRefreshText = '刷新成功'
        this.pullRefreshImage = $r("app.media.ic_refresh_succeed")
        this.isCanRefresh = true
        this.isRefreshing = true
        break;
    }
  }

  // 关闭刷新
  closeRefresh() {
    // 如果允许刷新，延迟进入，为了显示刷新中
    setTimeout(() => {
      var delay = 50
      if (this.isCanRefresh) {
        // 状态3：刷新成功
        this.pullRefreshState(3)
        // 为了显示刷新成功，延迟执行收缩动画
        delay = 500
      }
      animateTo({
        duration: 150, // 动画时长
        delay: delay, // 延迟时长
        onFinish: () => {
          // 状态0：下拉刷新
          this.pullRefreshState(0)
          this.isPullRefreshOperation = false
        }
      }, () => {
        this.offsetY = 0
      })
    }, this.isCanRefresh ? 500 : 0)
  }

  //============================================加载更多==================================================
  // 手指移动，处理加载更多
  touchMoveLoadMore(event: TouchEvent) {
    // 因为加载更多是在列表后面新增一个item，当一屏能够展示全部列表，endIndex 为 length+1
    if (this.endIndex == this.list.length - 1 || this.endIndex == this.list.length) {
      // 滑动的偏移量
      this.offsetY = event.touches[0].y - this.downY
      if (Math.abs(this.offsetY) > vp2px(this.loadMoreHeight) / 2) {
        // 可以刷新了
        this.isCanLoadMore = true
        // 显示加载更多布局
        this.isVisibleLoadMore = true
        // 偏移量缓慢增加
        this.offsetY = -vp2px(this.loadMoreHeight) + this.offsetY * 0.1
      }
    }
  }

  // 手指抬起，处理加载更多
  touchUpLoadMore() {
    animateTo({
      duration: 200, // 动画时长
    }, () => {
      // 偏移量设置为0
      this.offsetY = 0
    })
    if (this.isCanLoadMore) {
      console.info('======执行加载更多========')
      // 加载中...
      this.isLoading = true
      // 模拟耗时操作
      setTimeout(() => {
        this.closeLoadMore()
        this.loadMoreData()
      }, 2000)
    } else {
      console.info('======关闭加载更多！未达到条件========')
      this.closeLoadMore()
    }
  }

  // 关闭加载更多
  closeLoadMore() {
    this.isCanLoadMore = false
    this.isLoading = false
    this.isVisibleLoadMore = false
  }
}