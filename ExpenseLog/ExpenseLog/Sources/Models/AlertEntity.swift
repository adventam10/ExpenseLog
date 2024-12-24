//
//  AlertEntity.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/10.
//

import Foundation

/// アラート表示用
struct AlertEntitiy {
    /// アラートのタイトル
    let title: String
    /// アラートのメッセージ
    let message: String
    /// OK押下時の処理
    var okAction: (() -> Void)? = nil
}
