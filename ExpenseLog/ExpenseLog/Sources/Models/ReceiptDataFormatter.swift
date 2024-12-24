//
//  ReceiptDataFormatter.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/09.
//

import Foundation

struct ReceiptDataFormatter {

    enum ReceiptType {
        /// 万代
        case mandai
        /// コーナン
        case kohnan
    }

    struct FormattedData {
        /// 品名
        let name: String
        /// 金額
        let price: Int
    }

    /// レシートから読み取った文字列を品名と金額に変換する
    /// - Parameter receiptTexts: レシートから読み取った文字列（1行ごと、半角スペースで連結）
    /// - Returns: 品名と金額への変換結果
    func format(_ receiptTexts: [String]) -> [FormattedData] {
        switch receiptType(from: receiptTexts) {
        case .mandai:
            return mandaiFormat(receiptTexts)
        case .kohnan:
            return kohnanFormat(receiptTexts)
        }
    }

    private func receiptType(from receiptTexts: [String]) -> ReceiptType {
        if receiptTexts.contains(where: {
            let components = $0.components(separatedBy: " ")
            return $0.hasPrefix("#") &&
            components.count == 2 &&
            components[1].count == 16 &&
            components[1].isAlphanumeric
        }) &&
            receiptTexts.contains(where: {
                $0.hasSuffix("内") &&
                $0.replacingOccurrences(of: "内", with: "").isNumeric
            }) {
            // 「#015 JAN4548927034969」と「217内」形式のデータがある場合はコーナン
            return .kohnan
        }
        return .mandai
    }
}

extension ReceiptDataFormatter {

    private func mandaiFormat(_ receiptTexts: [String]) -> [FormattedData] {
        // 末尾が「¥1,899」形式のデータを抽出
        let filtered = receiptTexts.filter {
            let components = $0.components(separatedBy: " ")
            guard let priceText = components.last,
                  priceText.hasPrefix("¥") else {
                return false
            }
            return priceText.replacingOccurrences(of: "¥", with: "")
                .replacingOccurrences(of: ",", with: "")
                .isNumeric
        }

        return filtered.map {
            var components = $0.components(separatedBy: " ")

            // 末尾の「¥1,899」形式の文字列から金額取得
            let priceText = components.popLast()!
                .replacingOccurrences(of: "¥", with: "")
                .replacingOccurrences(of: ",", with: "")
            let price = Int(priceText) ?? 0

            let first = components.removeFirst()
            if first.count == 4 && first.contains("#") && String(first.suffix(2)).isNumeric {
                // 「ソ#11」形式の文字列を除去する
                return FormattedData(name: components.joined(separator: " "), price: price)
            }
            return FormattedData(name: ([first] + components).joined(separator: " "), price: price)
        }
    }

    private func kohnanFormat(_ receiptTexts: [String]) -> [FormattedData] {
        // 「#015 JAN4548927034969」形式のデータを除去する
        var filtered = receiptTexts.filter {
            let components = $0.components(separatedBy: " ")
            guard let last = components.last else {
                return false
            }
            return last.count != 16 || !last.isAlphanumeric
        }

        var results = [FormattedData]()
        var name = ""
        while !filtered.isEmpty {
            let value = filtered.removeFirst()
            if !value.hasSuffix("内") {
                name = name + value
            } else {
                // 「1,899内」形式の文字列から金額取得
                let priceText = value.replacingOccurrences(of: "内", with: "")
                    .replacingOccurrences(of: ",", with: "")
                if let price = Int(priceText) {
                    results.append(.init(name: name, price: price))
                    name = ""
                } else {
                    name = name + value
                }
            }
        }
        return results
    }
}

fileprivate extension String {

    /// 数値のみかどうか
    var isNumeric: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }

    /// アルファベットと数値のみかどうか
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
