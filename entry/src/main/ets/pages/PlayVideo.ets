import router from '@ohos.router'
import { ConsoleUtils } from '../model/ConsoleUtils'
import { Header } from './header'

@Entry
@Component
struct PlayVideo {
  @State videoSrc: string = router.getParams()['videoUrl']
  @State previewUri: string = router.getParams()['picUrl']
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @State isAutoPlay: boolean = true
  @State showControls: boolean = true
  controller: VideoController = new VideoController()

  onPageShow() {
    ConsoleUtils.log(this.videoSrc)
  }

  build() {
    Column() {
      Header({ title: '视频播放', onLeftClick: () => {
        router.back()
      } })
      Video({
        src: this.videoSrc,
        previewUri: this.previewUri,
        currentProgressRate: this.curRate,
        controller: this.controller
      })
        .width('100%')
        .height(600)
        .autoPlay(this.isAutoPlay)
        .controls(this.showControls)
        .onStart(() => {
          ConsoleUtils.info('onStart')
        })
        .onPause(() => {
          ConsoleUtils.info('onPause')
        })
        .onFinish(() => {
          ConsoleUtils.info('onFinish')
        })
        .onError(() => {
          ConsoleUtils.info('onError')
        })
        .onPrepared((e) => {
          ConsoleUtils.info('onPrepared is ' + e.duration)
        })
        .onSeeking((e) => {
          ConsoleUtils.info('onSeeking is ' + e.time)
        })
        .onSeeked((e) => {
          ConsoleUtils.info('onSeeked is ' + e.time)
        })
        .onUpdate((e) => {
          ConsoleUtils.info('onUpdate is ' + e.time)
        })

      Row() {
        Button('start').onClick(() => {
          this.controller.start() // 开始播放
          ConsoleUtils.log("start")
        }).margin(5)
        Button('pause').onClick(() => {
          this.controller.pause() // 暂停播放
          ConsoleUtils.log("pause")
        }).margin(5)
        Button('stop').onClick(() => {
          this.controller.stop() // 结束播放
        }).margin(5)
        Button('setTime').onClick(() => {
          this.controller.setCurrentTime(10, SeekMode.Accurate) // 精准跳转到视频的10s位置
        }).margin(5)
      }

      Row() {
        Button('rate 0.75').onClick(() => {
          this.curRate = PlaybackSpeed.Speed_Forward_0_75_X // 0.75倍速播放
        }).margin(5)
        Button('rate 1').onClick(() => {
          this.curRate = PlaybackSpeed.Speed_Forward_1_00_X // 原倍速播放
        }).margin(5)
        Button('rate 2').onClick(() => {
          this.curRate = PlaybackSpeed.Speed_Forward_2_00_X // 2倍速播放
        }).margin(5)
      }
    }
  }
}