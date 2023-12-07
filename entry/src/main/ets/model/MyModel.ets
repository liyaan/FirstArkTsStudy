import { HttpUtils } from './HttpUtils';
import { UserData } from './UserData';

export default class MyModel {
  name: string = ""
  info: string = ""
  imageUrl: string = ""

  constructor() {
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
}