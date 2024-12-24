//
//  ItemValidationError.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/10.
//

import Foundation

protocol ItemValidationError {
    /// メッセージ
    var message: String { get }

    /// 項目内での優先度
    var localPriority: Int { get }

    /// 項目間での優先度
    var globalPriority: Int { get }
}

/// 品名のバリデーションエラー
enum ItemNameValidationError: ItemValidationError {

    /// 入力なし
    case empty

    /// 長さ超過
    case length

    var message: String {
        switch self {
        case .empty:
            return .init(localized: "item_validation_name_empty_message")
        case .length:
            return .init(localized: "item_validation_name_length_message")
        }
    }

    var localPriority: Int {
        switch self {
        case .empty:
            return 500
        case .length:
            return 100
        }
    }

    var globalPriority: Int {
        return 1
    }
}

/// 金額のバリデーションエラー
enum ItemPriceValidationError: ItemValidationError {

    /// 入力なし
    case empty

    var message: String {
        switch self {
        case .empty:
            return .init(localized: "item_validation_price_empty_message")
        }
    }

    var localPriority: Int {
        switch self {
        case .empty:
            return 0
        }
    }

    var globalPriority: Int {
        return 0
    }
}
