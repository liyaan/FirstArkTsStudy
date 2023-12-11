import DataPreferences from '@ohos.data.preferences';
import { ConsoleUtils } from './ConsoleUtils';


export class PreferencesUtils {
  private static readonly TAG = 'PreferencesUtils';

  private constructor() {
  }

  /**
   * 封装一层，增加获取失败的日志输出
   * @param context
   * @param name
   */
  public static getPreferences(context: Context, name: string): Promise<DataPreferences.Preferences> {

    return new Promise<DataPreferences.Preferences>((resolved, rejected) => {
      DataPreferences.getPreferences(context, name)
        .then((res) => {
          resolved(res);
        })
        .catch(reason => {
          ConsoleUtils.error('获取Preferences实例失败');
          rejected(reason);
        })
    });

  }
}