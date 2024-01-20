//
//  ContentView.swift
//  CameraSwiftUI
//
//  Created by 渡辺大智 on 2024/01/17.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    // 撮影画面(sheet)の開閉状態を管理
    @State var isShowSheet = false
    // フォトライブラリーで選択した写真を管理
    @State var photoPickerSelectedImage: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            
            Spacer()
            
            // カメラを起動するボタン
            Button {
                // ボタンをタップした時のアクション(クロージャ)
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    // 撮影写真を初期化する
                    captureImage = nil
                    // カメラが使えるならisShowSheetをtrue
                    isShowSheet.toggle()
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                Text("カメラを起動する")
                // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                // 高さ50ポイント設定
                    .frame(height: 50)
                // 文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                // 背景色を青色に指定
                    .background(Color.blue)
                // 文字色を白色に指定
                    .foregroundStyle(Color.white)
            }
            .padding()
            // isPresentedで指定した状態変数がtrueの時実行 これはButtonにあるSheet modifier
            // modifierは各順番で振る舞いが変わる(順次適応)ので注意
            .sheet(isPresented: $isShowSheet) {
                if let captureImage {
                    // 撮影した写真がある->EffectViewを表示する
                    EffectView(isShowSheet: $isShowSheet, captureImage: captureImage)
                } else {
                    // UIImagePickerController(写真撮影を表示) $をつけることで参照先を共有
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
            }
            
            // フォトライブラリーから選択する
            PhotosPicker(selection: $photoPickerSelectedImage, matching: .images, preferredItemEncoding: .automatic, photoLibrary: .shared()) {
                // テキスト表示
                Text("フォトライブラリーから選択する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .padding()
            }
            // 選択した写真情報をもとに写真を取り出す
            .onChange(of: photoPickerSelectedImage, initial: true) { oldValue, newValue in
                // 選択した写真があるとき
                if let newValue {
                    // Data型で写真を取り出す
                    newValue.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            // 写真があるとき
                            if let data {
                                captureImage = UIImage(data: data)
                            }
                        case .failure(_):
                            return
                        }
                    }
                }
            }
        }
        .onChange(of: captureImage) { oldValue, newValue in
            if let _ = newValue {
                // 撮影した写真がある->EffectViewを表示する
                isShowSheet.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
