//
//  ReadReceiptButton.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/09.
//

import SwiftUI

struct ReadReceiptButton: View {

    /// レシートの読み取り結果
    @Binding var receiptTexts: [String]

    @State private var receiptImage: UIImage?
    @State private var isCameraViewShown = false
    @State private var isOCRViewShown = false

    var body: some View {
        Button {
            isCameraViewShown = true
        } label: {
            HStack {
                Image(systemName: "text.viewfinder")
                Text("read_receipt_button_title")
            }
        }.fullScreenCover(isPresented: $isCameraViewShown) {
            CameraView(image: $receiptImage).ignoresSafeArea()
        }.fullScreenCover(isPresented: $isOCRViewShown) {
            ReceiptOCRView(receiptImage: receiptImage, receiptTexts: $receiptTexts).ignoresSafeArea()
        }.onChange(of: receiptImage) { _, _ in
            isOCRViewShown = true
        }
    }
}
