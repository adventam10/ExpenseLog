//
//  Session.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

protocol Session: Sendable {

    var config: AppConfig { get }

    func send(api: API, completion: @Sendable @escaping (Result<Data, APIError>) -> Void)
}

final class DefaultSession: Session {

    private let urlSession: URLSession
    let config: AppConfig

    init(urlSession: URLSession = .shared, config: AppConfig) {
        self.urlSession = urlSession
        self.config = config
    }

    func send(api: API, completion: @Sendable @escaping (Result<Data, APIError>) -> Void) {
        let task = urlSession.dataTask(with: api.makeURLRequest(config: config)) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(.network))
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.server))
                return
            }

            if let data = data {
                completion(.success(data))
                return
            }

            completion(.failure(.server))
        }
        task.resume()
    }
}
