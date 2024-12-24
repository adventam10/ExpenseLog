//
//  YearChartFormatter.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import Foundation

struct YearChartFormatter {

    /// 各項目（またはサブ項目）の各月の家計簿データの合計金額
    struct ChartData {
        /// ID
        let id = UUID().uuidString
        /// 項目
        let category: Category
        /// 各月の家計簿データの合計金額
        let monthlyTotalPrices: [MonthlyTotalPrice]
    }

    /// 各月の家計簿データの合計金額
    struct MonthlyTotalPrice {
        /// ID
        let id = UUID().uuidString
        /// 月（1~12）
        let month: Int
        /// 月の合計金額
        let price: Int
        /// 月初の日付（1月なら1/1）
        let date: Date
    }

    /// 任意の年のすべての家計簿データを棒グラフ表示用に整形する
    /// - Parameter items: 任意の年の家計簿データ
    /// - Returns: 棒グラフ表示用に整形した家計簿データ
    func formatAllItems(_ items: [Item]) -> [ChartData] {
        if items.isEmpty {
            return []
        }

        // 項目ごとにグルーピング
        let categoryGrouping = Dictionary(
            grouping: items,
            by: { $0.categoryValue }
        )

        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: items.first!.date)
        return categoryGrouping.keys.map { categoryValue in
            // 月ごとにグルーピング
            let monthGrouping = Dictionary(
                grouping: categoryGrouping[categoryValue]!,
                by: { calendar.component(.month, from: $0.date) }
            )
            return ChartData(
                category: .init(categoryValue: categoryValue, categorySubValue: nil),
                monthlyTotalPrices: monthGrouping.keys.map { month in
                    MonthlyTotalPrice(
                        month: month,
                        price: monthGrouping[month]!.reduce(0) { partialResult, item in
                            partialResult + item.price
                        },
                        date: DateComponents(calendar: calendar, year: year, month: month, day: 1).date!
                    )
            })
        }
    }

    /// 任意の年の任意の項目の家計簿データを棒グラフ表示用に整形する
    /// - Parameter items: 任意の年の任意の項目の家計簿データ
    /// - Returns: 棒グラフ表示用に整形した家計簿データ
    func formatCategoryFilteredItems(_ items: [Item]) -> [ChartData] {
        if items.isEmpty {
            return []
        }

        // サブ項目ごとにグルーピング
        let categorySubGrouping = Dictionary(
            grouping: items,
            by: { $0.categorySubValue }
        )

        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: items.first!.date)
        return categorySubGrouping.keys.map { categorySubValue in
            // 月ごとにグルーピング
            let monthGrouping = Dictionary(
                grouping: categorySubGrouping[categorySubValue]!,
                by: { calendar.component(.month, from: $0.date) }
            )
            return ChartData(
                category: .init(categoryValue: items.first!.categoryValue, categorySubValue: categorySubValue),
                monthlyTotalPrices: monthGrouping.keys.map { month in
                    MonthlyTotalPrice(
                        month: month,
                        price: monthGrouping[month]!.reduce(0) { partialResult, item in
                            partialResult + item.price
                        },
                        date: DateComponents(calendar: calendar, year: year, month: month, day: 1).date!
                    )
            })
        }
    }
}
