//
//  CameraView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/09.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {

    private let allowsEditing: Bool
    @Binding private var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    /// 初期化処理
    /// - Parameters:
    ///   - image: 撮影した画像受取用
    ///   - allowsEditing: UIImagePickerController で編集可能かどうか
    init(image: Binding<UIImage?>, allowsEditing: Bool = false) {
        self._image = image
        self.allowsEditing = allowsEditing
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.delegate = context.coordinator
        viewController.allowsEditing = allowsEditing
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            viewController.sourceType = .camera
        }

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

extension CameraView {

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
