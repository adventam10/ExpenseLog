//
//  Category.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import Foundation
import UIKit.UIColor
import SwiftUI

/// 項目
enum Category {
    /// 食費
    case food(FoodSub?)
    /// 娯楽費
    case entertainment(EntertainmentSub?)

    /// 未選択（アプリの表示のみだ扱う値）
    static let unselectedValue = -1
    /// 食費
    static let foodValue = 0
    /// 娯楽費
    static let entertainmentValue = 1

    static let categoryValues = [
        foodValue, entertainmentValue,
    ]

    init(categoryValue: Int, categorySubValue: Int?) {
        switch categoryValue {
        case Self.foodValue:
            self = .food(categorySubValue == nil ? nil : .init(rawValue: categorySubValue!))
        case Self.entertainmentValue:
            self = .entertainment(categorySubValue == nil ? nil : .init(rawValue: categorySubValue!))
        default:
            assertionFailure("不正な値！！！！")
            self = .food(nil)
        }
    }
}

extension Category {

    // 表示名
    var name: String {
        switch self {
        case .food:
            return .init(localized: "category_food_name")
        case .entertainment:
            return .init(localized: "category_entertainment_name")
        }
    }

    /// 各項目の数値（サーバーの値と対応）
    var value: Int {
        switch self {
        case .food:
            return Self.foodValue
        case .entertainment:
            return Self.entertainmentValue
        }
    }
}

/// グラフ表示用
extension Category {

    /// グラフ表示時の色
    var color: UIColor {
        switch self {
        case .food:
            return .food
        case .entertainment:
            return .entertainment
        }
    }

    /// サブ項目
    var sub: (any CategorySub)? {
        switch self {
        case .food(let foodSub):
            return foodSub
        case .entertainment(let entertainmentSub):
            return entertainmentSub
        }
    }

    /// サブ項目名（未選択の場合は「なし」返却）
    var subName: String {
        return sub?.name ?? .init(localized: "category_sub_none_name")
    }

    /// サブ項目の色（未選択の場合はグレー返却）
    var subColor: UIColor {
        return sub?.color ?? .categorySubNone
    }
}

/// サブ項目
protocol CategorySub: CaseIterable {

    /// 表示名
    var name: String { get }

    /// 各サブ項目の数値（サーバーの値と対応）
    var value: Int { get }

    /// グラフ表示時の色
    var color: UIColor { get }
}

// MARK: - 食費
/// 食費サブ項目（0）
enum FoodSub: Int {
    /// 食品
    case grocery = 0
    /// 飲料
    case drink = 1
    /// 菓子類
    case sweets = 2
    /// 栄養補助
    case supplement = 3
}

extension FoodSub: CategorySub {

    var name: String {
        switch self {
        case .grocery:
            return .init(localized: "food_sub_grocery_name")
        case .drink:
            return .init(localized: "food_sub_drink_name")
        case .sweets:
            return .init(localized: "food_sub_sweets_name")
        case .supplement:
            return .init(localized: "food_sub_supplement_name")
        }
    }

    var value: Int {
        return rawValue
    }

    var color: UIColor {
        switch self {
        case .grocery:
            return .grocery
        case .drink:
            return .drink
        case .sweets:
            return .sweets
        case .supplement:
            return .supplement
        }
    }
}

// MARK: - 娯楽費
/// 娯楽費サブ項目（1）
enum EntertainmentSub: Int {
    /// 嗜好品
    case luxury = 0
    /// 交通費
    case traffic = 1
    /// 雑貨
    case goods = 2
}

extension EntertainmentSub: CategorySub {

    var name: String {
        switch self {
        case .luxury:
            return .init(localized: "entertainment_sub_luxury_name")
        case .traffic:
            return .init(localized: "entertainment_sub_traffic_name")
        case .goods:
            return .init(localized: "entertainment_sub_goods_name")
        }
    }

    var value: Int {
        return rawValue
    }

    var color: UIColor {
        switch self {
        case .luxury:
            return .luxury
        case .traffic:
            return .traffic
        case .goods:
            return .goods
        }
    }
}
