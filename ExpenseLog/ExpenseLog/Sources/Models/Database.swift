//
//  Database.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import Foundation
import SwiftData

extension ModelContext {

    /// 家計簿データ保存処理
    /// - Parameter items: 追加するデータ
    func addItems(_ items: [ResponseItem]) {
        items.map { $0.convert() } .forEach { insert($0) }
        do {
            try save()
        } catch let error {
            print(error)
            assertionFailure("データ登録でエラー")
        }
    }

    /// 年と項目を指定して家計簿データを取得する
    /// - Parameters:
    ///   - year: 指定の年（yyyy形式）
    ///   - category: 指定の項目（nilの場合は指定の年のデータをすべて取得）
    /// - Returns: 指定の年と項目の家計簿データ
    func fetchItems(year: String, category: Category?) -> [Item] {
        let calendar = Calendar(identifier: .gregorian)
        let startDate = DateComponents(calendar: calendar, year: Int(year)!, month: 1, day: 1).date!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: DateComponents(calendar: calendar, year: Int(year)!, month: 12).date!)!
        let filteredItems: [Item]?
        if let categoryValue = category?.value {
            filteredItems = try? fetch(
              FetchDescriptor<Item>(
                predicate: #Predicate {
                    $0.categoryValue == categoryValue && (startDate...endDate).contains($0.date)
                }
              )
            )
        } else {
            filteredItems = try? fetch(
              FetchDescriptor<Item>(
                predicate: #Predicate {
                    (startDate...endDate).contains($0.date)
                }
              )
            )
        }
        return filteredItems ?? []
    }

    /// 指定の年の家計簿データを削除する
    /// - Parameter year: 指定の年（yyyy形式）
    func removeItems(year: String) {
        let items = fetchItems(year: year, category: nil)
        items.forEach {
            delete($0)
        }
    }

    // 年月と項目を指定して家計簿データを取得する
    /// - Parameters:
    ///   - year: 指定の年（yyyy形式）
    ///   - month: 指定の月（M形式、1~12）
    ///   - category: 指定の項目（nilの場合は指定の年月のデータをすべて取得）
    /// - Returns: 指定の年月と項目の家計簿データ
    func fetchItems(year: String, month: String, category: Category?) -> [Item] {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(calendar: calendar, year: Int(year)!, month: Int(month)!, day: 1)
        let startDate = components.date!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        let filteredItems: [Item]?
        if let categoryValue = category?.value {
            filteredItems = try? fetch(
              FetchDescriptor<Item>(
                predicate: #Predicate {
                    $0.categoryValue == categoryValue && (startDate...endDate).contains($0.date)
                }
              )
            )
        } else {
            filteredItems = try? fetch(
              FetchDescriptor<Item>(
                predicate: #Predicate {
                    (startDate...endDate).contains($0.date)
                }
              )
            )
        }
        return filteredItems ?? []
    }

    /// 指定の年月の家計簿データを削除する
    /// - Parameters:
    ///   - year: 指定の年（yyyy形式）
    ///   - month: 指定の月（M形式、1~12）
    func removeItems(year: String, month: String) {
        let items = fetchItems(year: year, month: month, category: nil)
        items.forEach {
            delete($0)
        }
    }
}
