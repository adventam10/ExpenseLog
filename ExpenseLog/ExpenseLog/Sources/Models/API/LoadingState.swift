//
//  LoadingState.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/10.
//

import Foundation

enum LoadingState {
    /// 何もしていない
    case idle

    /// ロード中（message: ロード中に表示するメッセージ）
    case loading(message: String)
}
