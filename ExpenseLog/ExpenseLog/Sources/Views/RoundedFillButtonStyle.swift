//
//  RoundedFillButtonStyle.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import SwiftUI

/// 角丸の塗りつぶしボタン
struct RoundedFillButtonStyle: ButtonStyle {

    /// ボタンの背景色
    var color: Color = .orange

    /// ボタンの文字色
    var textColor: Color = .white

    /// 非活性時のボタンの背景色
    var disabledColor: Color = .init(uiColor: .lightGray)

    /// 角の丸み
    var cornerRadius: CGFloat = 8.0

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .background(isEnabled ? color : disabledColor)
            .opacity(configuration.isPressed ? 0.5 : 1.0)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
