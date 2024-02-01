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
  @State imgUri: string = ""
  @State pixelMap: PixelMap = null

  build() {
    Column() {
      Button('选择图片')
        .fontSize(14)
        .height(40)
        .width('90%')
        .borderRadius(10)
        .margin({ top: 20 })
        .backgroundColor('#A4AE77')
        .onClick(() => {
          checkPermissions(permissions).then((result) => {
            if (result) {
              this.selectImage()
            }
          })
        })
      Image(this.imgUri).height(200)

      Button('进行缩放')
        .fontSize(14)
        .height(40)
        .width('90%')
        .borderRadius(10)
        .margin({ top: 20 })
        .backgroundColor('#A4AE77')
        .onClick(() => {
          this.scale_image()
        })
    }.width('100%')
    .height('100%')
  }
  // 对pixelMap进行缩放
  scale_image() {
    this.getPixelMap((pixelMap) => {
      pixelMap.scale(0.5, 0.5)
      this.pixelMap = pixelMap
    })

  }

  async getPixelMap(success: (PixelMap) => void) {
    let opts = { editable: true, desiredPixelFormat: 3, }
    const imgSource = image.createImageSource(this.imgUri)
    imgSource.createPixelMap(opts).then((pixel) => {
      ConsoleUtils.info('pixel :' + JSON.stringify(pixel));
      success(pixel)
      // this.imgUri = imgUri
    }).catch((e) => {
      ConsoleUtils.info('pixel : error ' + e);
    })
  }

  async selectImage() {
    try {
      let PhotoSelectOptions = new picker.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 5;
      let photoPicker = new picker.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions, (err, PhotoSelectResult) => {
        if (err) {
          ConsoleUtils.error('PhotoViewPicker.select failed with err: ' + err);
          return;
        }
        ConsoleUtils.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
        this.imgUri = PhotoSelectResult.photoUris[0]
        // let file = fs.openSync(this.imgUri, fs.OpenMode.READ_ONLY)
        // ConsoleUtils.info('file fd: ' + file.fd);
        //
        // let buffer = new ArrayBuffer(4096);
        // let readLen = fs.readSync(file.fd, buffer);
        // ConsoleUtils.info('readSync data to file succeed and buffer size is:' + readLen);

        // MediaHelper.prototype.getImageWidthAndHeight(this.imgUri).then((bean) => {
        //   let opts = { editable: true, desiredPixelFormat: 3, size: { height: bean.imgHeight, width: bean.imgWidth } }
        //   imageSource.createPixelMap(buffer, opts)
        //     .then((pixel) => {
        //       this.pixelMap = pixel
        //     })
        //
        // })
        // fs.closeSync(file);
      });
    } catch (err) {
      ConsoleUtils.error('PhotoViewPicker failed with err: ' + err);
    }
  }
}


