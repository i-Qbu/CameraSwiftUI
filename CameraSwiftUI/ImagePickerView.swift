//
//  ImagePickerView.swift
//  CameraSwiftUI
//
//  Created by 渡辺大智 on 2024/01/17.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // UIImagePickerControllerの表示状態
    @Binding var isShowSheet: Bool
    
    // 撮影写真の保存先
    @Binding var captureImage: UIImage?
    
    // Coordinatorコントローラのdelegate管理
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePickerView
        
        // イニシャライザ
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        // 撮影が終わった時に呼ばれるdelegateメソッド 必須
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // UIImagePickerControllerを閉じる, isShowSheetがfalseになる
            picker.dismiss(animated: true) {
                // 撮影した写真をcaptureImageに保存
                if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.parent.captureImage = originalImage
                }
            }
        }
    }
    
    // Coordinateを生成，SwiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスのインスタンスの生成
        Coordinator(self)
    }
    
    // UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let myImagePickerController = UIImagePickerController()
        myImagePickerController.sourceType = .camera
        myImagePickerController.delegate = context.coordinator
        return myImagePickerController
    }
    
    // Viewが更新された時に実行
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}
