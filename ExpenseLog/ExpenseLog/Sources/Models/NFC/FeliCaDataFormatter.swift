//
//  FeliCaDataFormatter.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import Foundation

struct FeliCaDataFormatter {

    /// 交通系ICカードから読み取ったデータを家計簿データに整形する
    /// - Parameter feliCaData: 交通系ICカードから読み取ったデータ（日付降順で最大20件）
    /// - Returns: 整形した家計簿データ
    func format(feliCaData: [Data]) -> [Item] {
        return feliCaData.enumerated().compactMap { index, value in
            // 乗車日取得
            let components = DateComponents(
                calendar: .init(identifier: .gregorian),
                year: Int(value[4] >> 1) + 2000,
                month: ((value[4] & 1) == 1 ? 8 : 0) + Int(value[5] >> 5),
                day: Int(value[5] & 0x1f)
            )
            guard let date = components.date else {
                return nil
            }

            // 乗車駅・降車駅取得
            let start = value[6...7].map { String(format: "%03d", $0) }.joined()
            let startValue = String(start.prefix(3)) + "-" + String(start.suffix(3))
            let end = value[8...9].map { String(format: "%03d", $0) }.joined()
            let endValue = String(end.prefix(3)) + "-" + String(end.suffix(3))
            let name = "\(FeliCaStation(rawValue: startValue)?.name ?? startValue) - \(FeliCaStation(rawValue: endValue)?.name ?? endValue)"

            // 金額取得
            let price: Int
            if feliCaData.count > index + 1 {
                let nextData = feliCaData[index + 1]
                let current = Int(value[10]) + Int(value[11]) << 8
                let next = Int(nextData[10]) + Int(nextData[11]) << 8
                price = next - current
            } else {
                // 一番古いデータは残高しかわからずデータが取れないので除外する
                return nil
            }

            return Item(
                id: UUID().uuidString, date: date,
                name: name, price: price,
                categoryValue: Category.entertainmentValue,
                categorySubValue: EntertainmentSub.traffic.rawValue
            )
        }
    }
}
