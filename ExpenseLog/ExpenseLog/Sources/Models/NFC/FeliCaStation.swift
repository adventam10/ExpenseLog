//
//  FeliCaStation.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import Foundation

enum FeliCaStation: String {
    /// JR京都
    case jrKyoto = "001-204"

    /// JR新大阪
    case jrShinOsaka = "001-230"

    /// JR大阪
    case jrOsaka = "001-232"

    /// JR高槻
    case jrTakatsuki = "001-216"

    /// 阪急梅田
    case hankyuUmeda = "157-001"

    /// 阪急高槻市
    case hankyuTakatsuki = "159-029"
}

extension FeliCaStation {

    var name: String {
        switch self {
        case .jrKyoto:
            return "JR京都駅"
        case .jrShinOsaka:
            return "JR新大阪駅"
        case .jrOsaka:
            return "JR大阪駅"
        case .jrTakatsuki:
            return "JR高槻駅"
        case .hankyuUmeda:
            return "阪急梅田駅"
        case .hankyuTakatsuki:
            return "阪急高槻市駅"
        }
    }
}
