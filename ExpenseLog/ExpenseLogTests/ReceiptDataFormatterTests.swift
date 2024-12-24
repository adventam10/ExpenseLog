//
//  ReceiptDataFormatterTests.swift
//  ExpenseLogTests
//
//  Created by am10 on 2024/12/18.
//

import Testing
@testable import ExpenseLog

struct ReceiptDataFormatterTests {

    @Test func formatForMandai() {
        let formatter = ReceiptDataFormatter()
        let name1 = "hoge"
        let name2 = "fuga"
        let price1 = 123
        let price2 = 12345
        let result = formatter.format([
            "ｿ#12 \(name1) ¥\(price1)",
            "ｿ#10 \(name2) ¥12,345",
        ])
        #expect(result.count == 2)
        #expect(result[0].name == name1)
        #expect(result[0].price == price1)
        #expect(result[1].name == name2)
        #expect(result[1].price == price2)
    }

    @Test func formatForKohnan() {
        let formatter = ReceiptDataFormatter()
        let name1 = "hoge"
        let name2 = "fuga"
        let price1 = 123
        let price2 = 12345
        let result = formatter.format([
            "#015 JAN1234567890123",
            name1,
            "\(price1)内",
            "#012 JAN1231231290123",
            name2,
            "12,345内",
        ])
        #expect(result.count == 2)
        #expect(result[0].name == name1)
        #expect(result[0].price == price1)
        #expect(result[1].name == name2)
        #expect(result[1].price == price2)
    }
}
