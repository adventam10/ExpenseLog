# ExpenseLog
下記ブログで作っていた家計簿アプリです。好きなように改造して自分専用の家計簿アプリを作ってください！

https://www.am10.blog/archives/759

iPhone

| 日本語 | 英語 |
| --- | --- |
|![ja_JP_1](https://github.com/user-attachments/assets/edaf545c-3388-4fca-a4f8-c40df2a57ad2)|![en_JP_1](https://github.com/user-attachments/assets/187a5ae2-452e-494a-8ac1-6f7c1f2d5a46)|
|![ja_JP_2](https://github.com/user-attachments/assets/12823cb7-10d5-48f6-bbe0-206a2040fc8e)|![en_JP_2](https://github.com/user-attachments/assets/fe645b63-76b1-43c3-8b0c-8295a8bc4805)|
|![ja_JP_3](https://github.com/user-attachments/assets/8eafeb8d-1f6a-448c-81e4-c991f770e2c4)|![en_JP_3](https://github.com/user-attachments/assets/ba72f2c9-b0b0-42af-beec-ac1900a1ccd7)|

iPad

| 日本語 | 英語 |
| --- | --- |
|<img width="1032" alt="ja_JP_1" src="https://github.com/user-attachments/assets/51a2a4f4-6442-4f34-9f4d-efaa9367cd1a" />|<img width="1032" alt="en_JP_1" src="https://github.com/user-attachments/assets/a3d8aaeb-4a80-426d-93e4-25e2b15a1a53" />|
|<img width="1032" alt="ja_JP_2" src="https://github.com/user-attachments/assets/905a6ca4-d20c-4652-befd-383941a8fcc4" />|<img width="1032" alt="en_JP_2" src="https://github.com/user-attachments/assets/34754e81-4a9e-4289-b37e-824f3d8f8260" />|
|<img width="1032" alt="ja_JP_3" src="https://github.com/user-attachments/assets/5c5802e6-2796-4ea1-b9ac-99873c263f72" />|<img width="1032" alt="en_JP_3" src="https://github.com/user-attachments/assets/c94f950f-cdb7-450d-8eb4-1876ebb55a4d" />|

## 動作確認
動かすには下記の URL の設定が必要です。

```swift
let secretBaseURL = "xxx"
```

https://www.am10.blog/archives/767

上記を見てサーバーを実装するか下記のように修正すればローカルの JSON ファイル読み込み形でデモみたいな感じで動かせます。

```swift
// 適当に URL (string:)でnilにならないように値を設定する
let secretBaseURL = "https://example.com"
```

PROJECT > Info > Configurations で ExpenseLog.dummy.xcconfig を指定する。

<img width="500" alt="configurations" src="https://github.com/user-attachments/assets/9cc9c360-8bed-4f25-8e5e-4a8278435720" />

※ S バイマンの画像 1 ~ 8.png はアップしていないのでローディング画面で画像は表示されません。

フォントもアップしていないので必要であれば下記から 851tegaki_zatsu_normal_0883.ttf ファイルを追加してください。

https://pm85122.onamae.jp/851fontpage.html