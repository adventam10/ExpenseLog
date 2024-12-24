//
//  ExpenseLogAPIClient.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

final class ExpenseLogAPIClient: Sendable {

    private let session: Session

    init(session: Session) {
        self.session = session
    }

    private func send<T: Codable>(api: ExpenseLogAPI, completion: @escaping @Sendable (Result<T, APIError>) -> Void) {
        let dateDecodingStrategy = api.dateDecodingStrategy
        session.send(api: api) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let dateDecodingStrategy = dateDecodingStrategy {
                    decoder.dateDecodingStrategy = dateDecodingStrategy
                }
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch let error {
                    print(error)
                    completion(.failure(.invalidJSON))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ExpenseLogAPIClient {

    /// 指定の年月の家計簿データ取得処理
    /// - Parameters:
    ///   - year: 年（yyyy形式）
    ///   - month: 月(M形式、範囲は1~12)
    func fetch(year: String, month: String, completion: @escaping @Sendable (Result<[ResponseItem], APIError>) -> Void) {
        send(api: .fetch(year: year, month: month), completion: completion)
    }

    /// 家計簿データ登録処理
    /// - Parameters:
    ///   - items:登録する家計簿データ
    func register(items: [ResponseItem], completion: @escaping @Sendable (Result<[ResponseItem], APIError>) -> Void) {
        send(api: .register(items: items), completion: completion)
    }
}

extension ExpenseLogAPIClient {

    /// 指定の年月の家計簿データ取得処理
    /// - Parameters:
    ///   - year: 年（yyyy形式）
    ///   - month: 月(M形式、範囲は1~12)
    func fetch(year: String, month: String) async throws -> [ResponseItem] {
        try await withCheckedThrowingContinuation { continuation in
            fetch(year: year, month: month) { result in
                switch result {
                case .success(let items):
                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// 家計簿データ登録処理
    /// - Parameters:
    ///   - items:登録する家計簿データ
    func register(items: [ResponseItem]) async throws -> [ResponseItem]  {
        try await withCheckedThrowingContinuation { continuation in
            register(items: items) { result in
                switch result {
                case .success(let items):
                    continuation.resume(returning: items)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
