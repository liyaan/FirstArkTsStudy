import fs from '@ohos.file.fs';
import { ConsoleUtils } from '../model/ConsoleUtils';
import picker from '@ohos.file.picker';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { checkPermissions } from '../common/utils/PermisstonsUrils';
import image from '@ohos.multimedia.image';


const permissions: Array<Permissions> = ['ohos.permission.READ_MEDIA', 'ohos.permission.WRITE_MEDIA'];

@Entry
@Component
struct ImageEdit {
  @State edit: boolean = false
  @State imagePixelMap: PixelMap = undefined
  private imagePath: Resource = $r('app.media.banner2')

  @Builder buttonModel($$: {
    textContent,
    action
  }) {
    Button($$.textContent)
      .fontSize(14)
      .height(30)
      .width(60)
      .borderRadius(10)
      .backgroundColor('#E8A027')
      .onClick(() => {
        $$.action
        this.edit = true
      })
  }

  async get_pixelmap() {
    // 获取resourceManager资源管理
    const context = getContext(this)
    const resourceMgr = context.resourceManager
    // 获取rawfile文件夹下httpimage.PNG的ArrayBuffer
    const fileData = await resourceMgr.getMediaContent(this.imagePath)
    const buffer = fileData.buffer
    // 创建imageSource
    const imageSource = image.createImageSource(buffer)
    // 创建PixelMap
    const pixelMap = await imageSource.createPixelMap()
    return pixelMap
  }

  // 对pixelMap进行裁剪
  async crop_image() {
    let pixelMap = await this.get_pixelmap()
    pixelMap.crop({ x: 0, y: 0, size: { height: 300, width: 300 } })
    this.imagePixelMap = pixelMap
  }

  // 对pixelMap进行缩放
  async scale_image() {
    let pixelMap = await this.get_pixelmap()
    pixelMap.scale(0.5, 0.5)
    this.imagePixelMap = pixelMap
  }

  // 对pixelMap进行偏移
  async translate_image() {
    let pixelMap = await this.get_pixelmap()
    pixelMap.translate(100, 100);
    this.imagePixelMap = pixelMap
  }

  // 对pixelMap进行旋转
  async rotate_image() {
    let pixelMap = await this.get_pixelmap()
    pixelMap.rotate(90);
    this.imagePixelMap = pixelMap
  }

  // 对pixelMap进行翻转
  async flip_image() {
    let pixelMap = await this.get_pixelmap()
    pixelMap.flip(false, true);
    this.imagePixelMap = pixelMap
  }

  // 对pixelMap进行透明度调整
  async opacity_image() {
    let pixelMap = await this.get_pixelmap()
    pixelMap.opacity(0.5);
    this.imagePixelMap = pixelMap
  }

  build() {
    Column() {
      if (!this.edit) {
        Row() {
          Image(this.imagePath).objectFit(ImageFit.None)
        }.width('100%').height('50%').backgroundColor('#F0F0F0')
      } else {
        Row() {
          // 将编辑好的pixelMap传递给状态变量imagePixelMap后，通过Image组件进行渲染
          Image(this.imagePixelMap).objectFit(ImageFit.None)
        }.width('100%').height('50%').backgroundColor('#F0F0F0')
      }
      Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly }) {
        this.buttonModel({ textContent: '裁剪', action: this.crop_image() })
        this.buttonModel({ textContent: '缩放', action: this.scale_image() })
        this.buttonModel({ textContent: '偏移', action: this.translate_image() })
        this.buttonModel({ textContent: '旋转', action: this.rotate_image() })
        this.buttonModel({ textContent: '翻转', action: this.flip_image() })
        this.buttonModel({ textContent: '透明度', action: this.opacity_image() })
        Button('还原')
          .fontSize(14)
          .height(30)
          .width(60)
          .borderRadius(10)
          .margin({ top: 20 })
          .backgroundColor('#A4AE77')
          .onClick(() => {
            this.edit = false
          })
      }
      .margin({ top: 100 })
      .height('100%')
      .width('100%')
    }
  }
}


