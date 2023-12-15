import testNapi from 'libentry.so'
import { ConsoleUtils } from '../model/ConsoleUtils';
import { ToastUtils } from '../model/ToastUtils';

@Entry
@Component
struct ArkTsNative {
  @State message: string = 'Test NAPI 2 + 3 = '
  @State numX: number = 0.0;
  private textInputControllerX: TextInputController = new TextInputController();
  @State firstNumber: number = 0
  @State secondNumber: number = 0
  @State addResult: number = 0

  build() {
    Column() {
      Row() {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            ConsoleUtils.info(0x0000 + " " + 'testTag  ' + 'Test NAPI 2 + 3 = ' + testNapi.add(2, 3));
          })

        Text(testNapi.add(2, 3).toString())
          .fontSize(40)
          .fontColor(Color.Red)
          .onClick(() => {
            ToastUtils.showOne('string length:' + testNapi.strLength('aaaa'))
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)


      Column() {
        Row() {
          TextInput({ controller: this.textInputControllerX })
            .width(100)
            .type(InputType.Number)
            .onChange(value => {
              let temp = parseFloat(value);
              this.numX = testNapi.sqrt(temp);
            })
          Text("的平方根=")
            .fontSize(40)
          Text(this.numX.toString())
            .fontSize(40)
            .fontColor(Color.Green)

        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 100 })

      Column() {
        TextInput({ placeholder: '请输入第一个数字' })
          .textInputCommon()
          .onChange((value) => {
            this.firstNumber = parseInt(value.trim())
          })
        TextInput({ placeholder: '请输入第二个数字' })
          .textInputCommon()
          .onChange((value) => {
            this.secondNumber = parseInt(value.trim())
          })
        Button('结果:' + this.addResult)
          .buttonStyle()
          .onClick(() => {
            this.addResult = testNapi.add(this.firstNumber, this.secondNumber)
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

@Extend(TextInput) function textInputCommon() {
  .textAlign(TextAlign.Center)
  .type(InputType.Normal)
  .padding({ left: 10, right: 15 })
  .width('85%')
  .margin({ left: 10, top: 10 })
}

@Extend(Button) function buttonStyle() {
  .width('90%')
  .margin({ top: 20 })
  .height(40)
  .type(ButtonType.Normal)
  .backgroundColor('#36D')
  .borderRadius(10)
}