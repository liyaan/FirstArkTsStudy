export class Log {
  static info(tag, message) {
    console.log(tag, message)
  }

  static error(tag, message) {
    console.error(tag, message)
  }
}