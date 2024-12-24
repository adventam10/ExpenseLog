//
//  ReceiptOCRView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/09.
//

import SwiftUI

struct ReceiptOCRView: UIViewControllerRepresentable {

    private let receiptImage: UIImage?
    @Binding private var receiptTexts: [String]
    @Environment(\.dismiss) private var dismiss

    /// 初期化処理
    /// - Parameters:
    ///   - receiptImage: レシート画像
    ///   - receiptTexts: レシートの読み取り結果受取用
    init(receiptImage: UIImage?, receiptTexts: Binding<[String]>) {
        self.receiptImage = receiptImage
        self._receiptTexts = receiptTexts
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ReceiptOCRViewController {
        let viewController = ReceiptOCRViewController()
        viewController.receiptImage = receiptImage
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: ReceiptOCRViewController, context: Context) {}
}

extension ReceiptOCRView {

    class Coordinator: NSObject, @preconcurrency ReceiptOCRViewControllerDelegate {
        let parent: ReceiptOCRView

        init(_ parent: ReceiptOCRView) {
            self.parent = parent
        }

        @MainActor func didReadTexts(_ texts: [String]) {
            parent.receiptTexts = texts
            parent.dismiss()
        }
    }
}
