//
//  API.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/05.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol API {

    func makeURLRequest(config: AppConfig) -> URLRequest

    func makeBaseURL(config: AppConfig) -> URL

    var queryItems: [String: Any] { get }

    var httpMethod: HTTPMethod { get }

    var httpBody: Data? { get }

    var timeout: TimeInterval { get }

    var accept: String { get }

    var contentType: String { get }
}

/// リクエストのデフォルト値
enum APIDefaultValue {
    static let timeout: TimeInterval = 30
    static let accept: String = "application/json"
    static let contentType: String = "application/json"
}

extension API {

    func makeURLRequest(config: AppConfig) -> URLRequest {
        var components = URLComponents(url: makeBaseURL(config: config), resolvingAgainstBaseURL: true)!
        var request = URLRequest(url: components.url!, timeoutInterval: timeout)
        switch httpMethod {
        case .get:
            components.queryItems = queryItems.map { .init(name: $0, value: $1 as? String) }
        case .post:
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
        }
        request.httpMethod = httpMethod.rawValue
        request.setValue(accept, forHTTPHeaderField: "Accept")
        request.url = components.url
        return request
    }

    var timeout: TimeInterval {
        return APIDefaultValue.timeout
    }

    var accept: String {
        return APIDefaultValue.accept
    }

    var contentType: String {
        return APIDefaultValue.contentType
    }
}
