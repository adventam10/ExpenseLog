//
//  FloatingButton.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import SwiftUI

/// フローティングボタン
struct FloatingButton: View {

    /// ボタンの色
    var color: Color = .orange

    /// 影の色
    var shadowColor: Color = .gray

    /// 上下左右の余白
    var padding: EdgeInsets = .init(top: 0, leading: 0, bottom: 40, trailing: 16)

    /// アイコンの名前（システムイメージ限定）
    var imageSystemName: String = "pencil"

    /// アイコンの色
    var imageColor: Color = .white

    /// アイコンのサイズ
    var imageFontSize: CGFloat = 24

    /// 縦・横の長さ
    var length: CGFloat = 60
    private var cornerRadius: CGFloat {
        return length/2
    }

    /// 押下時の処理
    var tappedAction: (() -> Void)? = nil

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    tappedAction?()
                }, label: {
                    Image(systemName: imageSystemName)
                        .foregroundColor(imageColor)
                        .font(.system(size: imageFontSize))
                })
                .frame(width: length, height: length)
                .background(color)
                .cornerRadius(cornerRadius)
                .shadow(color: shadowColor, radius: 3, x: 3, y: 3)
                .padding(padding)
            }
        }
    }
}
