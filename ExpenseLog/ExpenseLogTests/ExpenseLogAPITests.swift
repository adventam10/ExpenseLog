//
//  ExpenseLogAPITests.swift
//  ExpenseLogTests
//
//  Created by am10 on 2024/12/18.
//

import Testing
@testable import ExpenseLog
import Foundation

struct ExpenseLogAPITests {

    @Test func fetch() {
        let year = "2024"
        let month = "12"
        let api = ExpenseLogAPI.fetch(year: year, month: month)
        #expect(api.httpMethod == .get)
        #expect(api.httpBody == nil)
        #expect(api.timeout == APIDefaultValue.timeout)
        #expect(api.accept == APIDefaultValue.accept)
        #expect(api.contentType == APIDefaultValue.contentType)

        let queryItems = api.queryItems
        #expect(queryItems.count == 2)
        #expect(queryItems["year"] as? String == year)
        #expect(queryItems["month"] as? String == month)
    }

    @Test func register() {
        let item = ResponseItem(id: "1", date: Date(), name: "name", price: 100, category: 1, categorySub: 1)
        let api = ExpenseLogAPI.register(items: [item])
        #expect(api.httpMethod == .post)
        #expect(api.timeout == APIDefaultValue.timeout)
        #expect(api.accept == APIDefaultValue.accept)
        #expect(api.contentType == APIDefaultValue.contentType)
        #expect(api.queryItems.isEmpty)

        let parameters = try? JSONSerialization.jsonObject(with: api.httpBody!, options: []) as? [[String: Any]]
        #expect(parameters?.count == 1)
        let parameter = parameters?.first
        #expect(parameter?.count == 6)
        #expect(parameter?["id"] as? String == item.id)
        #expect(parameter?["date"] as? String == api.dateStrategyFormatter.string(from: item.date))
        #expect(parameter?["name"] as? String == item.name)
        #expect(parameter?["price"] as? Int == item.price)
        #expect(parameter?["category"] as? Int == item.category)
        #expect(parameter?["categorySub"] as? Int == item.categorySub)
    }
}
