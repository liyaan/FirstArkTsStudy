import media from '@ohos.multimedia.media'
import fileIO from '@ohos.fileio'
import { ConsoleUtils } from '../../model/ConsoleUtils';

export class AudioDemo {
  // 设置播放器回调函数
  static setCallBack(audioPlayer) {
    audioPlayer.on('dataLoad', () => { //设置'dataLoad'事件回调，src属性设置成功后，触发此回调
      ConsoleUtils.info('audio set source success');
      audioPlayer.play(); //调用play方法开始播放，触发'play'事件回调
    });
    audioPlayer.on('play', () => { //设置'play'事件回调
      ConsoleUtils.info('audio play success');
    });
    audioPlayer.on('pause', () => { //设置'pause'事件回调
      ConsoleUtils.info('audio pause success'); //触发'timeUpdate'事件回调，seek到5000ms处播放
    });
    audioPlayer.on('reset', () => { //设置'reset'事件回调
      ConsoleUtils.info('audio reset success');
      audioPlayer.release(); //audioPlayer资源被销毁
      // audioPlayer = undefined;
    });
    audioPlayer.on('finish', () => { //设置'finish'事件回调，播放完成触发
      ConsoleUtils.info('audio play finish');
      audioPlayer.release(); //audioPlayer资源被销毁
      audioPlayer = undefined;
    });
  }

  static async audioPlayerDemo() {
    let audioPlayer = media.createAudioPlayer(); //创建一个音频播放实例
    // AudioDemo.initPlayer(audioPlayer)
    // media.createAVPlayer().then((player) => {
    //   if (player != null) {
    //     AudioDemo.initPlayer(player)
    //   } else {
    //     ConsoleUtils.info('video createVideoPlayer fail');
    //   }
    // }).catch((error) => {
    //   ConsoleUtils.log("error " + error)
    // })
    // this.setCallBack(audioPlayer); //设置事件回调
    // let fdPath = 'http://192.168.10.19:8080/examples/1mp4.mp3'
    // path路径的码流可通过"hdc file send D:\xxx\01.mp3 /data/app/el1/bundle/public/ohos.acts.multimedia.audio.audioplayer/ohos.acts.multimedia.audio.audioplayer/assets/entry/resources/rawfile" 命令，将其推送到设备上
    // let path = '/sdcard/1mp4.mp3';
    // await fileIO.open(path).then((fdNumber) => {
    //   fdPath = fdPath + '' + fdNumber;
    //   ConsoleUtils.info('open fd success fd is' + fdPath);
    // }, (err) => {
    //   ConsoleUtils.info('open fd failed err is' + err);
    // }).catch((err) => {
    //   ConsoleUtils.info('open fd failed err is' + err);
    // });
    // audioPlayer.src = fdPath; //设置src属性，并触发'dataLoad'事件回调
  }

  static initPlayer(audioPlayer, callback: () => void, callListener: () => void) {
    callListener()
    //设置事件回调
    ConsoleUtils.info('video createVideoPlayer success');
    let fdPath = 'http://192.168.10.19:8080/examples/1mp4.mp3'
    audioPlayer.src = fdPath
    callback()
  }
}