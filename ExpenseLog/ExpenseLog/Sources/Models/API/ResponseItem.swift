//
//  ResponseItem.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import Foundation

/// サーバーとやり取りするための家計簿データ
struct ResponseItem: Sendable {
    /// ID
    let id: String
    /// 購入日
    let date: Date
    /// 品名
    let name: String
    /// 価格
    let price: Int
    /// 項目
    let category: Int
    /// サブ項目
    let categorySub: Int?
}

extension ResponseItem: Codable {

    enum CodingKeys: CodingKey {
        case id
        case date
        case name
        case price
        case category
        case categorySub
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Int.self, forKey: .price)
        category = try container.decode(Int.self, forKey: .category)
        categorySub = try? container.decode(Int.self, forKey: .categorySub)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(category, forKey: .category)
        try container.encode(categorySub, forKey: .categorySub)
    }
}

extension ResponseItem {

    func convert() -> Item {
        return .init(id: id, date: date,
                     name: name, price: price,
                     categoryValue: category, categorySubValue: categorySub)
    }
}
