import prompt from '@ohos.prompt'

export class ToastUtils {
  show(message: string, duration: number = 1000) {
    prompt.showToast({
      message: message,
      duration: duration
    })
  }

  static showOne(message: string, duration: number = 1000) {
    prompt.showToast({
      message: message,
      duration: duration
    })
  }
}