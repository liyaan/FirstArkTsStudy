import http from '@ohos.net.http';
import { StringUtils } from '../common/utils/StringUtils';
import { ToastUtils } from '../model/ToastUtils'
import { ConsoleUtils } from './ConsoleUtils';
import { UserData } from './UserData';

let httpRequest = http.createHttp();
let CONST_URL = 'https://api.apiopen.top/api/';

export class HttpUtils {
  static post(data: object, url: string,
              callSuccess: (string) => void,
              callError: (string) => void) {
    try {
      httpRequest.request(CONST_URL + url, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'token': StringUtils.TOKEN_STRING
        },
        extraData: JSON.stringify(data),
        connectTimeout: 60000,
        readTimeout: 60000
      }, (err, data) => {
        if (!err) {
          // data.result为http响应内容，可根据业务需要进行解析
          ConsoleUtils.info('Result:' + data.result);
          let json = JSON.parse(`${data.result}`)
          let code = json.code
          if (code === 200) {
            callSuccess(json)
          } else {
            ToastUtils.prototype.show(json.message)
            callError(json)
          }
          ConsoleUtils.info('code:' + data.responseCode);
          // data.header为http响应头，可根据业务需要进行解析
          ConsoleUtils.info('header:' + JSON.stringify(data.header));
          ConsoleUtils.info('cookies:' + data.cookies); // 8+
        } else {
          ConsoleUtils.info('error:' + JSON.stringify(err));
          callError(JSON.stringify(err))
          // 该请求不再使用，调用destroy方法主动销毁。
          httpRequest.destroy();
        }
      })
    } catch (e) {
      console.error(e)
    }
  }

  static get(url,
             callSuccess: (string) => void,
             callError: (string) => void) {
    try {
      ConsoleUtils.log("url:" + CONST_URL + url)
      httpRequest.request(CONST_URL + url,
        {
          method: http.RequestMethod.GET,
          header: {
            'token': StringUtils.TOKEN_STRING
          },
          connectTimeout: 60000,
          readTimeout: 60000
        }, (err, data) => {
          if (!err) {
            ConsoleUtils.info('Result:' + data.result);
            let json = JSON.parse(`${data.result}`)
            let code = json.code
            if (code === 200) {
              callSuccess(json)
            } else {
              ToastUtils.prototype.show(json.message)
              callError(json)
            }
            ConsoleUtils.info('header:' + JSON.stringify(data.header));
          } else {
            ConsoleUtils.info('error:' + JSON.stringify(err));
            callError(JSON.stringify(err))
            // 该请求不再使用，调用destroy方法主动销毁。
            httpRequest.destroy();
          }
        })
    } catch (e) {
      console.error(e)
    }
  }
}