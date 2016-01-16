# btCamera
## Overview
これは Multipeer Session を用いて近距離でシャッターを切ることができるカメラアプリです。

## Description
このアプリは iOS 端末を 2 つ使います。一方はカメラ、もう一方はシャッターです。

![例](./btCamera/images/IMG_0035.png)

iOS 端末で写真を撮る時、せっかく固定してもタップにより写真がブレてしまうことを防ぐのが目的です。また、機種変更などで余らせた複数の iOS 端末を有効活用させない手はないと思い作ってみました。

なお、端末がスリープしたり、アプリを背後に回すだけで peering は切れてしまう、要するにカメラとして使う時に 2 つの端末が揃ってないといけないので、悪用はできないと考えています。

### 位置情報について
位置情報は下記の例において iPhone A で取得します。すなわち iPhone B には iPhone A での位置情報が保存されます。

## Usage
    1. 例えば 2つの iPhone、A と B にこのアプリを導入し、起動します。
    2. iPhone A で "Find device as shutter" をタップします。
    3. するとリスト画面に iPhone B が表示されているはずですので、これをタップします。
    4. iPhone B で接続許可のダイアログが表示されるので "Accept" をタップします。
    5. iPhone A で "Start Camera" をタップし、カメラ画面に移ります。
    6. 洗濯バサミや三脚などで iPhone A を固定したら、
    7. iPhone B の "SHUTTER" ボタンをタップします。
    8. iPhone A が撮影し、離れた iPhone B に保存されます。(Wi-Fi adhook で直接 iPhone B へ転送されます。環境によって転送速度にばらつきがあります。)

## Plan
    - 画面デザイン (操作フローの整理)
    - 写真の転送速度が速かったり (Wi-Fi) 遅かったり (Bluetooth) するのでどうにかしたい。
    - Instant Hot Spot 中にテキスト入力で "Unable to simultaneously satisfy constraints." を直す。(Instant Hot Spot 中は Auto Layout 崩壊する？)

## Change Log
2016/01/16
    - PhotoKit を用いて位置情報を保存する。
    - 画像へウォーターマークを挿入させる。
    - ウォーターマークのフォントサイズを変更可能にする。

## License
Copyright (c) 2015 tkumata

This software is release under the MIT License, please see [MIT](http://opensource.org/licenses/mit-license.php)

## Author
[tkumata](https://github.com/tkumata)
