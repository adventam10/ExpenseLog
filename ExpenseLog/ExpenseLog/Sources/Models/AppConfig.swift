//
//  AppConfig.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

struct AppConfig {

    enum Environment {
        /// 本番
        case release
        /// 開発
        case development
        /// ダミー
        case dummy
    }

    let environment: Environment

    /// 本番環境かどうか
    var isRelease: Bool {
        switch environment {
        case .release:
            return true
        default:
            return false
        }
    }
}
