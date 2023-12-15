import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import common from '@ohos.app.ability.common';
import geoLocationManager from '@ohos.geoLocationManager';
import { ConsoleUtils } from '../model/ConsoleUtils';

@CustomDialog
export struct Permission {
  private permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION'];
  accessText: string = '设备获取粗略位置权限: 未授权';
  controller: CustomDialogController
  noPermission: () => void
  gotoSetting: () => void
  confirm: () => void

  aboutToAppear() {
    this.checkPermissions(this.permissions);
  }

  build() {
    Column() {
      Text(this.accessText)
        .fontSize(20)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)

      Button('申请权限').margin({ top: 12 })
        .onClick(() => {
          this.reqPermissionsFromUser(this.permissions);
        })
    }
    .width('90%')
    .padding(12)
  }

  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus;

    // 获取应用程序的accessTokenID
    let tokenId: number;
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (err) {
      ConsoleUtils.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (err) {
      ConsoleUtils.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
    }

    return grantStatus;
  }

  async checkPermissions(permissions: Array<Permissions>): Promise<void> {
    let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(permissions[0]);

    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      // 已经授权，可以继续访问目标操作
      // this.hasAccess = true;
      // this.accessText = '设备获取粗略位置权限: 已授权';
      this.confirm()
    } else {
      // 申请权限
      // this.hasAccess = false;
      // this.accessText = '设备获取粗略位置权限: 未授权';
      this.noPermission()
    }
  }

  reqPermissionsFromUser(permissions: Array<Permissions>): void {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      // this.hasAccess = true;
      // this.accessText = '设备获取粗略位置权限: 已授权';
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // let requestInfo = {
          //   'priority': 0x203,
          //   'scenario': 0x300,
          //   'timeInterval': 0,
          //   'distanceInterval': 0,
          //   'maxAccuracy': 0
          // };
          // let locationChange = (location) => {
          //   ConsoleUtils.log('locationChanger: data: ' + JSON.stringify(location));
          // };
          // try {
          //   geoLocationManager.on('locationChange', requestInfo, locationChange);
          // } catch (err) {
          //   ConsoleUtils.error("errCode:" + err.code + ",errMessage:" + err.message);
          // }
          // try {
          //   let location = geoLocationManager.getLastLocation();
          //   this.locationText = 'latitude:' + location.latitude + '\n'
          //   + 'longitude:' + location.longitude + '\n'
          //   + 'altitude:' + location.altitude + '\n'
          //   + 'accuracy:' + location.accuracy + '\n'
          //   + 'speed:' + location.speed + '\n'
          //   + 'direction:' + location.direction;
          // } catch (err) {
          //   ConsoleUtils.error("errCode:" + err.code + ",errMessage:" + err.message);
          // }
          this.confirm()
        } else {
          // this.hasAccess = false;
          // this.accessText = '设备获取粗略位置权限: 未授权';
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          this.gotoSetting()
          return;
        }
      }
      // 授权成功
    }).catch((err) => {
      ConsoleUtils.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
    })
  }
}