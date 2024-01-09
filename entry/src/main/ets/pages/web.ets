import web_webview from '@ohos.web.webview'

@Entry
@Component
struct webShow {
  controller: web_webview.WebviewController = new web_webview.WebviewController();
  @State content: string = ""
  @State input: string = ""

  build() {
    Column() {
      Column() {
        Text("H5层")
        Web({ src: $rawfile('webTo.html'), controller: this.controller }).onConfirm((e: any) => {
          console.log("luvi > " + JSON.stringify(e))
          this.content = e['message']

          return true;
        })
      }
      .height("50%")
      .margin({ top: 10 })
      .padding(10)
      .border({ width: 1 })
      .width("100%")

      Column() {
        Text("应用层")
        TextInput({ placeholder: "请输入数据" }).onChange((e) => {
          this.input = e
        })
        Button("向H5层发送数据").onClick(() => {
          this.controller.runJavaScript(`sendText("${this.input}")`)
        }).margin(10)

        Row().width("100%").height(1).backgroundColor("#ddd").margin(10)
        Text("接收H5传递的内容：" + this.content)
      }
      .height("50%")
      .margin({ top: 10 })
      .padding(10)
      .border({ width: 1 })
      .width("100%")
    }.height('100%').padding("10")
  }
}