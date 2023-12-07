export class StringUtils {
  static isNotNullOrEmpty(filePath: string): any {
    if (filePath) {
      return true
    }
    return false
  }

  static isNullOrEmpty(url): any {
    if (!url) {
      return true
    }
    return false
  }

  static isNotNullOrEmptyLength(url: string, length: number): any {
    if (url && url.length < length) {
      return true
    }
    return false
  }
}