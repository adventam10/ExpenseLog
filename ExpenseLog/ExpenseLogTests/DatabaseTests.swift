//
//  DatabaseTests.swift
//  ExpenseLogTests
//
//  Created by am10 on 2024/12/18.
//

import Testing
@testable import ExpenseLog
import SwiftData
import Foundation

struct DatabaseTests {

    @MainActor @Test func fetchYear() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let calendar = Calendar(identifier: .gregorian)
        context.addItems([
            .init(id: "0", date: DateComponents(calendar: calendar, year: 2023, month: 12, day: 31).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "1", date: DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "2", date: DateComponents(calendar: calendar, year: 2024, month: 6, day: 15).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "3", date: DateComponents(calendar: calendar, year: 2025, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil)
        ])
        let result = context.fetchItems(year: "2024", category: nil)
        #expect(result.count == 2)
    }

    @MainActor @Test func fetchYearAndCategory() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let calendar = Calendar(identifier: .gregorian)
        context.addItems([
            .init(id: "0", date: DateComponents(calendar: calendar, year: 2023, month: 12, day: 31).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "1", date: DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "2", date: DateComponents(calendar: calendar, year: 2024, month: 6, day: 15).date!, name: "", price: 0, category: 1, categorySub: nil),
            .init(id: "3", date: DateComponents(calendar: calendar, year: 2024, month: 7, day: 15).date!, name: "", price: 0, category: 0, categorySub: 0),
            .init(id: "4", date: DateComponents(calendar: calendar, year: 2024, month: 8, day: 15).date!, name: "", price: 0, category: 0, categorySub: 1),
            .init(id: "5", date: DateComponents(calendar: calendar, year: 2025, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: 0)
        ])
        let result = context.fetchItems(year: "2024", category: .food(nil))
        #expect(result.count == 3)
    }

    @MainActor @Test func fetchMonth() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let calendar = Calendar(identifier: .gregorian)
        context.addItems([
            .init(id: "0", date: DateComponents(calendar: calendar, year: 2023, month: 12, day: 31).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "1", date: DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "2", date: DateComponents(calendar: calendar, year: 2024, month: 6, day: 15).date!, name: "", price: 0, category: 1, categorySub: nil),
            .init(id: "3", date: DateComponents(calendar: calendar, year: 2024, month: 7, day: 15).date!, name: "", price: 0, category: 0, categorySub: 0),
            .init(id: "4", date: DateComponents(calendar: calendar, year: 2024, month: 8, day: 15).date!, name: "", price: 0, category: 0, categorySub: 1),
            .init(id: "5", date: DateComponents(calendar: calendar, year: 2025, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: 0),
            .init(id: "6", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "7", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 15).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "8", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 28).date!, name: "", price: 0, category: 0, categorySub: nil),
        ])
        let result = context.fetchItems(year: "2025", month: "2", category: nil)
        #expect(result.count == 3)
    }

    @MainActor @Test func fetchMonthAndCategory() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let calendar = Calendar(identifier: .gregorian)
        context.addItems([
            .init(id: "0", date: DateComponents(calendar: calendar, year: 2023, month: 12, day: 31).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "1", date: DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "2", date: DateComponents(calendar: calendar, year: 2024, month: 6, day: 15).date!, name: "", price: 0, category: 1, categorySub: nil),
            .init(id: "3", date: DateComponents(calendar: calendar, year: 2024, month: 7, day: 15).date!, name: "", price: 0, category: 0, categorySub: 0),
            .init(id: "4", date: DateComponents(calendar: calendar, year: 2024, month: 8, day: 15).date!, name: "", price: 0, category: 0, categorySub: 1),
            .init(id: "5", date: DateComponents(calendar: calendar, year: 2025, month: 1, day: 1).date!, name: "", price: 0, category: 0, categorySub: 0),
            .init(id: "6", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 1).date!, name: "", price: 0, category: 0, categorySub: nil),
            .init(id: "7", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 8).date!, name: "", price: 0, category: 1, categorySub: nil),
            .init(id: "8", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 12).date!, name: "", price: 0, category: 1, categorySub: 0),
            .init(id: "9", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 15).date!, name: "", price: 0, category: 0, categorySub: 1),
            .init(id: "10", date: DateComponents(calendar: calendar, year: 2025, month: 2, day: 28).date!, name: "", price: 0, category: 0, categorySub: 2),
        ])
        let result = context.fetchItems(year: "2025", month: "2", category: .food(nil))
        #expect(result.count == 3)
    }
}
