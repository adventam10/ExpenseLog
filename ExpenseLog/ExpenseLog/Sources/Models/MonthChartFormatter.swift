//
//  MonthChartFormatter.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/07.
//

import Foundation

struct MonthChartFormatter {

    /// 各項目（またはサブ項目）の家計簿データの合計金額
    struct ChartData {
        /// ID
        let id = UUID().uuidString
        /// 項目
        let category: Category
        /// 任意の月と項目（またはサブ項目）の合計金額
        let price: Int
    }

    /// 任意の年月のすべての家計簿データを円グラフ表示用に整形する
    /// - Parameter items: 任意の年月の家計簿データ
    /// - Returns: 円グラフ表示用に整形した家計簿データ
    func formatAllItems(_ items: [Item]) -> [ChartData] {
        if items.isEmpty {
            return []
        }

        // 項目ごとにグルーピング
        let categoryGrouping = Dictionary(
            grouping: items,
            by: { $0.categoryValue }
        )

        return categoryGrouping.keys.map { categoryValue in
            ChartData(
                category: .init(categoryValue: categoryValue, categorySubValue: nil),
                price: categoryGrouping[categoryValue]!.reduce(0) { partialResult, item in
                    partialResult + item.price
                })
        }
    }

    /// 任意の年月の任意の項目の家計簿データを円グラフ表示用に整形する
    /// - Parameter items: 任意の年月の任意の項目の家計簿データ
    /// - Returns: 円グラフ表示用に整形した家計簿データ
    func formatCategoryFilteredItems(_ items: [Item]) -> [ChartData] {
        if items.isEmpty {
            return []
        }

        // サブ項目ごとにグルーピング
        let categorySubGrouping = Dictionary(
            grouping: items,
            by: { $0.categorySubValue }
        )

        let categoryValue = items.first!.categoryValue
        return categorySubGrouping.keys.map { categorySubValue in
            ChartData(
                category: .init(categoryValue: categoryValue, categorySubValue: categorySubValue),
                price: categorySubGrouping[categorySubValue]!.reduce(0) { partialResult, item in
                    partialResult + item.price
                })
        }
    }
}
