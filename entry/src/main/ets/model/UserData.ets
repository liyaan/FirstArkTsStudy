import data_preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import { ConsoleUtils } from './ConsoleUtils';
import { PreferencesUtils } from './PreferencesUtils';

/**
 * 轻量级缓存工具类
 */
const context = getContext(this) as common.UIAbilityContext;
let promise = data_preferences.getPreferences(context, 'mystore');

export class UserData {
  static readonly TAG = 'UserData';
  /**
   *
   * @param name 传入的key
   * @param lhz 存储字段的类型（我这里存储的是string，所以直接写死了）
   * @returns 获取数据字段
   */
  static getPrefer(name, callBackData: (String) => void, callBackCatch: () => void) {
    promise.then((res) => {
      res.get(name, "")
        .then((data: data_preferences.ValueType) => {
          ConsoleUtils.log(this.TAG + " ------- " + name + " = " + data.toString())
          callBackData(data.toString())
        }).catch(() => {
        callBackCatch()
      })
    })
  }


  /**
   *
   * @param name 传入的key
   * @param valuer 传入的 value
   * 传入需要储存的字段
   */
  static putPrefer(name, value): void {
    promise.then((res) => {
      res.put(name, value).then(() => {
        res.flush();
        ConsoleUtils.log(this.TAG + " ------- " + name.toString() + "  " + value)
      }).catch((e) => {
        ConsoleUtils.log(this.TAG + " ------- " + name.toString() + "  " + value + "  111 " + e)
      })
    })
  }

  static clear() {
    promise.then((res) => {
      res.delete('token', (callback) => {
        res.flush()
        ConsoleUtils.log(this.TAG + " ------- delete success")
      })
    })
  }

  static getPreferName(name): String {
    promise.then((res) => {
      res.get(name, "")
        .then((data: data_preferences.ValueType) => {
          let token = data.toString()
          ConsoleUtils.log("-------" + token)
          token
        })
    })
    return
  }

  static async getPreferAwait(name, callBack: (String) => void) {
    let preferences = await PreferencesUtils.getPreferences(context, 'mystore');
    let value = await preferences.get(name, "")
    callBack(value)
  }
}