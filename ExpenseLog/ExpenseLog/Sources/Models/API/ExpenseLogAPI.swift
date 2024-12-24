//
//  ExpenseLogAPI.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

/// 家計簿API
enum ExpenseLogAPI {
    /// データ取得
    case fetch(year: String, month: String)
    /// データ登録
    case register(items: [ResponseItem])
}

extension ExpenseLogAPI: API {

    func makeBaseURL(config: AppConfig) -> URL {
        if config.isRelease {
            return .init(string: secretBaseURL)!
        }
        return .init(string: secretBaseURL)!
    }

    var queryItems: [String : Any] {
        switch self {
        case .fetch(let year, let month):
            return [
                "year": year,
                "month": month
            ]
        case .register:
            return [:]
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .fetch:
            return .get
        case .register:
            return .post
        }
    }

    var httpBody: Data? {
        switch self {
        case .fetch:
            return nil
        case .register(let items):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateStrategyFormatter)
            return try? encoder.encode(items)
        }
    }
}

extension ExpenseLogAPI {

    var dateStrategyFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return .formatted(dateStrategyFormatter)
    }
}
