//
//  EffectView.swift
//  CameraSwiftUI
//
//  Created by 渡辺大智 on 2024/01/20.
//

import SwiftUI

struct EffectView: View {
    // エフェクト変種画面(sheet)の開閉状態を管理
    @Binding var isShowSheet: Bool
    // 撮影した写真
    let captureImage: UIImage
    // 表示する写真
    @State var showImage: UIImage?
    // フィルタ名を列挙した配列(Array)
    // 0.モノクロ
    // 1.Chrome
    // 2.Fade
    // 3.Instant
    // 4.Noir
    // 5.Process
    // 6.Tonal
    // 7.Transtar
    // 8.SepiaTone
    let filterArray = ["CIPhotoEffectMono",
                  "CIPhotoEffectChrome",
                  "CIPhotoEffectFade",
                  "CIPhotoEffectInstant",
                  "CIPhotoEffectTransfar",
                  "CISepiaTone"
    ]
    
    // 選択中のエフェクト(filterArrayの添字)
    @State var filterSelectNumber = 0
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if let showImage {
                // 表示する写真がある場合は画面に表示
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            Button {
                // ボタンをタップしたときのアクション
                // フィルタ名を配列から取得
                let filterName = filterArray[filterSelectNumber]
                // 次回に適用するフィルタを決めておく
                filterSelectNumber += 1
                // 最後のフィルタまで適用した場合
                if filterSelectNumber == filterArray.count {
                    // 最後の場合は，最初のフィルタに戻す
                    filterSelectNumber = 0
                }
                // 元々の画像の回転角度を取得
                let rotate = captureImage.imageOrientation
                // UIImage英紙の画像をCIImage形式に変換
                let inputImage = CIImage(image: captureImage)
                
                // フィルタ名を指定してCIFilterのインスタンスを取得
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                
                // フィルタ加工のパラメータを初期化
                effectFilter.setDefaults()
                // インスタンスにフィルタ加工する元画像を設定
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                // フィルタ加工を行う情報を生成
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                // CIContextのインスタンスを取得
                let ciContext = CIContext(options: nil)
                // フィルタ加工後の画像をCIContext上に描画し，結果をcgImageとしてCGImage形式の画像を取得
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                    return
                }
                // フィルタ加工後の画像をCGImage形式からUIImage形式に変更．その際回転角度を指定．
                showImage = UIImage(
                    cgImage: cgImage,
                    scale: 1.0,
                    orientation: rotate
                )
            } label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
            // showImageをアンラップする
            if let showImage {
                // captureImageから共有する画像を生成する
                let shareImage = Image(uiImage: showImage)
                // 共有シート
                ShareLink(item: shareImage, subject: nil, message: nil,
                          preview: SharePreview("Photo", image: shareImage)) {
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                          .padding()
            }
            
            
            Button {
                // ボタンをタップしたときのアクション
                isShowSheet.toggle()
            } label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
        }
        .onAppear {
            // 撮影した写真を表示する写真に設定
            showImage = captureImage
        }
    }
}

#Preview {
    EffectView(isShowSheet: .constant(true), captureImage: UIImage(named:"preview_use")!)
}
