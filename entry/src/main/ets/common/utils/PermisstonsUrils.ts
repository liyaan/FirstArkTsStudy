import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';

async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus;

  // 获取应用程序的accessTokenID
  let tokenId: number;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (err) {
    console.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (err) {
    console.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}

export async function checkPermissions(permissions: Array<Permissions>): Promise<boolean> {
  if (permissions.length > 0) {
    let result: boolean = false
    if (permissions.length == 1) {
      let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[0]);

      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        // 已经授权，可以继续访问目标操作
        result = true
      } else {
        // 申请日历权限
        result = false
      }
      return result;
    }
    let count: number = 0
    for (let index = 0; index < permissions.length; index++) {
      let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissions[index]);
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        // 已经授权，可以继续访问目标操作
        count++
      } else {
        //未授权
        isPermission(permissions, () => {
          count++
        }, () => {

        })
      }
      if (count == permissions.length) {
        result = true
      } else {
        result = false
      }
    }
    return result

  }

}

function isPermission(permissions: Array<Permissions>, success: () => void, error: () => void) {
  let context = getContext(this) as common.UIAbilityContext;
  let atManager = abilityAccessCtrl.createAtManager();

  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
        success()
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        error()
      }
    }
  }).catch((err) => {
    console.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
  })
}