//
//  APIError.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

enum APIError: Error {
    /// 通信エラー
    case network
    /// サーバーエラー
    case server
    /// JSON 不正
    case invalidJSON
}

extension APIError: LocalizedError {

    /// アラートで画面に表示する用のメッセージ
    var errorDescription: String? {
        switch self {
        case .network:
            return .init(localized: "api_error_message_network")
        case .server, .invalidJSON:
            return .init(localized: "api_error_message_server")
        }
    }
}
