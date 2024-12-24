//
//  ItemValidator.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/10.
//

import Foundation

struct ItemValidator {

    /// 家計簿データのバリデーション
    /// - Parameter item: 対象の家計簿データ
    /// - Returns: エラーメッセージ、nilの場合はエラーなし
    func validate(_ item: Item) -> String? {
        var results = [ItemValidationError]()
        // 必要であれば優先度の最も高いものだけを使う（localPriorityで降順にしたfirst）
        results.append(contentsOf: validateName(item.name))
        results.append(contentsOf: validatePrice(item.price))

        // 優先度でソート
        results.sort {
            if $0.globalPriority != $1.globalPriority {
                return $0.globalPriority > $1.globalPriority
            }
            return $0.localPriority > $1.localPriority
        }
        // 必要であれば優先度の最も高いresults.firstだけを使う
        return formatMessage(results)
    }

    private func formatMessage(_ errors: [ItemValidationError]) -> String? {
        if errors.isEmpty {
            return nil
        }
        return errors.map { $0.message }.joined(separator: "\n")
    }

    private func validateName(_ name: String) -> [ItemNameValidationError] {
        var results = [ItemNameValidationError]()
        if name.isEmpty {
            results.append(.empty)
        }
        return results
    }

    private func validatePrice(_ price: Int) -> [ItemPriceValidationError] {
        var results = [ItemPriceValidationError]()
        if price == 0 {
            results.append(.empty)
        }
        return results
    }
}
