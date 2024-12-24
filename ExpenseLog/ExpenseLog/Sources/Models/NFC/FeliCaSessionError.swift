//
//  FeliCaSessionError.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import Foundation

enum FeliCaSessionError: Error {
    /// 利用不可
    case invalid

    /// タグが見つからない
    case notFound

    /// タグと接続失敗
    case notConnected

    /// サービス利用不可
    case invalidService

    /// 履歴利用不可
    case invalidHistories
}

extension FeliCaSessionError: LocalizedError {

    /// アラートで画面に表示する用のメッセージ
    var errorDescription: String? {
        switch self {
        case .invalid:
            return .init(localized: "felica_session_error_message_invalid")
        case .notFound, .notConnected, .invalidService, .invalidHistories:
            return .init(localized: "felica_session_error_message_unavailable")
        }
    }
}
