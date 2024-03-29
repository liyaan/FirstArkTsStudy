
import dataPreferences from '@ohos.data.preferences';
import { Logger } from './Logger';

const TAG = 'PreferencesUtil';
const MY_STORE = 'myStore';
const FORM_ID = 'formIds';
type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>;
export class PreferencesUtil {
  private static preferencesUtil: PreferencesUtil;

  public static getInstance(): PreferencesUtil {
    if (!PreferencesUtil.preferencesUtil) {
      PreferencesUtil.preferencesUtil = new PreferencesUtil();
    }
    return PreferencesUtil.preferencesUtil;
  }

  getPreferences(context: Context): Promise<dataPreferences.Preferences> {
    return new Promise((resolve, reject) => {
      dataPreferences.getPreferences(context, MY_STORE, (err, pref: dataPreferences.Preferences) => {
        if (err) {
          Logger.error(TAG, `Failed to get preferences. Code:${err.code},message:${err.message}`);
          reject(err);
          return;
        }
        resolve(pref);
      })
    })
  }

  preferencesFlush(preferences: dataPreferences.Preferences) {
    preferences.flush((err) => {
      if (err) {
        Logger.error(TAG, `Failed to flush. Code:${err.code}, message:${err.message}`);
      }
    })
  }

  preferencesPut(preferences: dataPreferences.Preferences, formIds: Array<string>): Promise<boolean> {
    return new Promise((resolve, reject) => {
      try {
        preferences.put(FORM_ID, formIds, (err) => {
          if (err) {
            reject(err);
            Logger.error(TAG, `Failed to put data. Code:${err.code}, message:${err.message}`);
            return;
          }
          Logger.info(TAG, `preferencesPut succeed,formIds: ${JSON.stringify(formIds)}`);
          resolve(true);
        })
      } catch (error) {
        Logger.error(TAG, `Failed to put data. Code: ${error.code},
        message:${error.message}`);
      }
    });
  }

  async preferencesHas(preferences: dataPreferences.Preferences): Promise<boolean> {
    return new Promise((resolve, reject) => {
      preferences.has(FORM_ID, (err, value) => {
        if (err) {
          reject(err);
          Logger.error(TAG, `WANG to check the key 'formIds'. Code:${err.code}, message:${err.message}`);
          return;
        }
        resolve(value);
      });
    })
  }

  removePreferencesFromCache(context: Context): void {
    dataPreferences.removePreferencesFromCache(context, MY_STORE);
  }

  async getFormIds(context: Context): Promise<Array<string>> {
    try {
      let preferences = await this.getPreferences(context);
      return new Promise((resolve, reject) => {
        if (preferences === null) {
          Logger.error(TAG, `preferences is null`);
          return;
        }
        preferences.get(FORM_ID, [''], (err, value: ValueType) => {
          if (err) {
            reject(err);
            Logger.error(TAG, `Failed to get value of 'formIds'. Code:${err.code}, message:${err.message}`);
            return;
          }
          resolve(value as Array<string>);
          Logger.info(TAG, `Succeeded in getting value of 'formIds'. val: ${value}.`);
        })
      })
    } catch (error) {
      Logger.error(TAG, `WANG Failed to get value of 'formIds'. Code:${error.code},
       message:${error.message}`);
    }
    return new Promise((resolve, reject) => {})
  }

  async addFormId(context: Context, formId: string) {
    try {
      let preferences = await this.getPreferences(context);
      if (preferences === null) {
        Logger.error(TAG, `preferences is null`);
        return;
      }

      if (await this.preferencesHas(preferences)) {
        let formIds = await this.getFormIds(context);
        if (formIds.indexOf(formId) === -1) {
          formIds.push(formId);
          if (!await this.preferencesPut(preferences, formIds)) {
            return;
          }
          this.preferencesFlush(preferences);
        }
      } else {
        if (!await this.preferencesPut(preferences, [formId])) {
          return;
        }
        this.preferencesFlush(preferences);
      }
    } catch (error) {
      Logger.error(TAG, `Failed to check the key 'formIds'. Code:${error.code},
       message:${error.message}`);
    }
  }

  async removeFormId(context: Context, formId: string) {
    try {
      let preferences = await this.getPreferences(context);
      if (preferences === null) {
        Logger.error(TAG, `preferences is null`);
        return;
      }
      if (await this.preferencesHas(preferences)) {
        let formIds = await this.getFormIds(context);
        let index = formIds.indexOf(formId);
        if (index !== -1) {
          formIds.splice(index, 1);
        }
        if (!await this.preferencesPut(preferences, formIds)) {
          return;
        }
        this.preferencesFlush(preferences);
      }
    } catch (error) {
      Logger.error(TAG, `WANG Failed to get preferences. Code:${error.code},
      message:${error.message}`);
    }
  }
}