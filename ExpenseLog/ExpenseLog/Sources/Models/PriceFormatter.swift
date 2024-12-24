//
//  PriceFormatter.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/11.
//

import Foundation

struct PriceFormatter {

    private let formatter = NumberFormatter()

    /// 金額に3桁おきにカンマをいれる
    /// - Parameter price: 金額
    /// - Returns: 3桁おきにカンマをいれた金額（変換できない場合は0を返す）
    func format(price: Int) -> String {
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? "0"
    }
}
