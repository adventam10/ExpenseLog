//
//  DummySession.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

final class DummySession: Session {

    let config: AppConfig = .init(environment: .dummy)

    func send(api: API, completion: @Sendable @escaping (Result<Data, APIError>) -> Void) {
        guard let expenseLogAPI = api as? ExpenseLogAPI,
              let data = makeData(api: expenseLogAPI) else {
            assertionFailure("ダミー用データを用意してください")
            completion(.failure(.server))
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(data))
        }
    }

    private func makeData(api: ExpenseLogAPI) -> Data? {
        let fileName: String
        switch api {
        case .fetch:
            fileName = "fetch"
        case .register:
            fileName = "register"
        }

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
