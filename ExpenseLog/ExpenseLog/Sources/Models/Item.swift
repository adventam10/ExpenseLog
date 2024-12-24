//
//  Item.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/04.
//

import Foundation
import SwiftData

@Model
final class Item {
    /// ID
    @Attribute(.unique) var id: String
    /// 購入日
    var date: Date
    /// 品名
    var name: String
    /// 価格
    var price: Int
    /// 項目
    var categoryValue: Int
    /// サブ項目
    var categorySubValue: Int?

    init(id: String, date: Date, name: String,
         price: Int, categoryValue: Int, categorySubValue: Int?) {
        self.id = id
        self.date = date
        self.name = name
        self.price = price
        self.categoryValue = categoryValue
        self.categorySubValue = categorySubValue
    }
}

extension Item {

    func convert() -> ResponseItem {
        return .init(id: id, date: date,
                     name: name, price: price,
                     category: categoryValue, categorySub: categorySubValue)
    }
}

extension Item {

    /// 項目とサブ項目
    var category: Category {
        return .init(categoryValue: categoryValue, categorySubValue: categorySubValue)
    }
}
