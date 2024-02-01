import { ConsoleUtils } from '../../model/ConsoleUtils'

export class Log {
  static info(tag, message) {
    ConsoleUtils.log(message)
  }

  static error(tag, message) {
    ConsoleUtils.error(message)
  }
  static infoTag(message) {
    ConsoleUtils.log(message)
  }

  static errorTag(message) {
    ConsoleUtils.error(message)
  }
}