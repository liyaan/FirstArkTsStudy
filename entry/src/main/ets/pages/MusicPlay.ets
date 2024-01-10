import media from '@ohos.multimedia.media'
import fileIO from '@ohos.fileio'
import { AudioDemo } from '../common/utils/AudioDemo'
import { ConsoleUtils } from '../model/ConsoleUtils';
import display from '@ohos.display';

@Entry
@Component
struct MusicPlay {
  audioPlayer = media.createAudioPlayer(); //创建一个音频播放实例
  isPlaying: boolean = false
  isFinish: boolean = false
  @State musicLength: number = 0
  @State seekLength: number = 0

  build() {
    Column() {
      Button('播放')
        .type(ButtonType.Normal)
        .width('100%')
        .height(40).onClick(() => {
        if (!this.isFinish) {
          if (this.audioPlayer == undefined) {
            this.audioPlayer = media.createAudioPlayer()
          }
          AudioDemo.initPlayer(this.audioPlayer, () => {
          }, () => {
            this.setCallBack()
          })
          this.isFinish = true;
        } else {
          if (this.isPlaying) {
            this.audioPlayer.play()
            this.isPlaying = false
          }
        }


      })
      Button('暂停')
        .type(ButtonType.Normal)
        .width('100%').onClick(() => {
        this.isPlaying = true
        this.audioPlayer.pause()
      })
        .height(40)

      Button('下一曲')
        .type(ButtonType.Normal)
        .width('100%').onClick(() => {
        if (!this.isPlaying && this.isFinish) {
          ConsoleUtils.info("examples/1.mp3")
          this.audioPlayer.reset();

        } else {
          ConsoleUtils.info(this.isPlaying + "  " + this.isFinish)
        }

      })
        .height(40)

      Button('停止')
        .type(ButtonType.Normal)
        .width('100%').onClick(() => {
        this.audioPlayer.stop()
      })
        .height(40)
      Slider(
        { min: 0, max: this.musicLength, step: 1, value: this.seekLength }
      )
        .blockColor('#36D')
        .width('90%')
        .trackThickness(7)
        .showTips(true)
        .showSteps(false)
        .onChange(value => {
          this.audioPlayer.seek(value);
        })
    }.width('100%')
    .height('100%')
  }

  setCallBack() {
    this.audioPlayer.on('dataLoad', () => { //设置'dataLoad'事件回调，src属性设置成功后，触发此回调
      ConsoleUtils.info('audio set source success');
      this.audioPlayer.play(); //调用play方法开始播放，触发'play'事件回调
    });
    this.audioPlayer.on('play', () => { //设置'play'事件回调
      ConsoleUtils.info('audio play success');
      this.musicLength = this.audioPlayer.duration
      ConsoleUtils.info(" musicLength = " + this.audioPlayer.duration)
    });
    this.audioPlayer.on('pause', () => { //设置'pause'事件回调
      ConsoleUtils.info('audio pause success'); //触发'timeUpdate'事件回调，seek到5000ms处播放
    });
    this.audioPlayer.on('reset', () => { //设置'reset'事件回调
      ConsoleUtils.info('audio reset success');
      // this.audioPlayer.release(); //audioPlayer资源被销毁
      // audioPlayer = undefined;
      this.audioPlayer.src = 'http://192.168.10.19:8080/examples/1.mp3';
    });
    this.audioPlayer.on('timeUpdate', (seekDoneTime) => { //设置'timeUpdate'事件回调
      if (typeof (seekDoneTime) == 'undefined') {
        console.info('audio seek fail');
        return;
      }
      ConsoleUtils.info('audio seek success, and seek time is ' + seekDoneTime);
      this.seekLength = seekDoneTime
      // audioPlayer.setVolume(0.5);                 //触发'volumeChange'事件回调
    });
    this.audioPlayer.on('stop', () => { //设置'stop'事件回调
      console.log('audio stop success');
      this.audioPlayer.release(); //audioPlayer资源被销毁
      this.audioPlayer = undefined;
      this.seekLength = 0
      this.isFinish = false
    });
    this.audioPlayer.on('finish', () => { //设置'finish'事件回调，播放完成触发
      ConsoleUtils.info('audio play finish');
      this.audioPlayer.release(); //audioPlayer资源被销毁
      this.audioPlayer = undefined;
      this.seekLength = 0
      this.isFinish = false
    });
  }
}