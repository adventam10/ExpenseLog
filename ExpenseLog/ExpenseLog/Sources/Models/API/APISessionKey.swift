//
//  APISessionKey.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import SwiftUI

let environment: AppConfig.Environment = AppConfig.Environment.makeEnvironment()

struct APISessionKey: @preconcurrency EnvironmentKey {

    @MainActor static let defaultValue: ExpenseLogAPIClient =
    environment == .dummy ? .init(session: DummySession()) : .init(session: DefaultSession(config: .init(environment: environment)))
}

extension EnvironmentValues {

  var apiClient: ExpenseLogAPIClient {
    get { self[APISessionKey.self] }
    set { self[APISessionKey.self] = newValue }
  }
}

extension AppConfig.Environment {

    static func makeEnvironment() -> AppConfig.Environment {
        let value = Bundle.main.object(forInfoDictionaryKey: "APP_ENVIRONMENT") as! String
        switch value {
        case "RELEASE":
            return .release
        case "DEVELOPMENT":
            return .development
        case "DUMMY":
            return .dummy
        default:
            assertionFailure("xcconfigの設定ミス")
            return .development
        }
    }
}
