//
//  ScreenshotTests.swift
//  ExpenseLogTests
//
//  Created by am10 on 2024/12/19.
//

import Testing
import SwiftUI
import SwiftData
@testable import ExpenseLog

struct ScreenshotTests {

    let device: Device = .iPhone16ProMaxPortrait

    @MainActor @Test func snapshot() {
        yearView()
        monthView()
        registerView()
    }

    @MainActor func yearView() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        let calendar = Calendar(identifier: .gregorian)
        context.addItems([
            .init(id: "1", date: DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date!, name: "", price: 100, category: 0, categorySub: nil),
            .init(id: "1_1", date: DateComponents(calendar: calendar, year: 2024, month: 1, day: 1).date!, name: "", price: 50, category: 1, categorySub: nil),
            .init(id: "2", date: DateComponents(calendar: calendar, year: 2024, month: 2, day: 15).date!, name: "", price: 100, category: 0, categorySub: nil),
            .init(id: "2_1", date: DateComponents(calendar: calendar, year: 2024, month: 2, day: 15).date!, name: "", price: 150, category: 1, categorySub: nil),
            .init(id: "3", date: DateComponents(calendar: calendar, year: 2024, month: 3, day: 1).date!, name: "", price: 200, category: 0, categorySub: nil),
            .init(id: "3_1", date: DateComponents(calendar: calendar, year: 2024, month: 3, day: 1).date!, name: "", price: 100, category: 1, categorySub: nil),
            .init(id: "4", date: DateComponents(calendar: calendar, year: 2024, month: 4, day: 1).date!, name: "", price: 250, category: 0, categorySub: nil),
            .init(id: "4_1", date: DateComponents(calendar: calendar, year: 2024, month: 4, day: 1).date!, name: "", price: 200, category: 1, categorySub: nil),
            .init(id: "5", date: DateComponents(calendar: calendar, year: 2024, month: 5, day: 1).date!, name: "", price: 200, category: 0, categorySub: nil),
            .init(id: "5_1", date: DateComponents(calendar: calendar, year: 2024, month: 5, day: 1).date!, name: "", price: 200, category: 1, categorySub: nil),
            .init(id: "6", date: DateComponents(calendar: calendar, year: 2024, month: 6, day: 1).date!, name: "", price: 200, category: 0, categorySub: nil),
            .init(id: "7", date: DateComponents(calendar: calendar, year: 2024, month: 7, day: 1).date!, name: "", price: 100, category: 0, categorySub: nil),
            .init(id: "7_1", date: DateComponents(calendar: calendar, year: 2024, month: 7, day: 1).date!, name: "", price: 100, category: 1, categorySub: nil),
            .init(id: "8", date: DateComponents(calendar: calendar, year: 2024, month: 8, day: 1).date!, name: "", price: 70, category: 0, categorySub: nil),
            .init(id: "8_1", date: DateComponents(calendar: calendar, year: 2024, month: 8, day: 1).date!, name: "", price: 30, category: 1, categorySub: nil),
            .init(id: "9", date: DateComponents(calendar: calendar, year: 2024, month: 9, day: 1).date!, name: "", price: 120, category: 0, categorySub: nil),
            .init(id: "9_1", date: DateComponents(calendar: calendar, year: 2024, month: 9, day: 1).date!, name: "", price: 120, category: 1, categorySub: nil),
            .init(id: "10", date: DateComponents(calendar: calendar, year: 2024, month: 10, day: 1).date!, name: "", price: 300, category: 0, categorySub: nil),
            .init(id: "11", date: DateComponents(calendar: calendar, year: 2024, month: 11, day: 1).date!, name: "", price: 210, category: 0, categorySub: nil),
            .init(id: "11_1", date: DateComponents(calendar: calendar, year: 2024, month: 11, day: 1).date!, name: "", price: 220, category: 1, categorySub: nil),
            .init(id: "12", date: DateComponents(calendar: calendar, year: 2024, month: 12, day: 1).date!, name: "", price: 300, category: 1, categorySub: nil),
        ])
        let imageData = screenshot(ContentView(
            year: "2024",
            month: "12",
            selection: 0
        ).modelContext(context))
        let screenshot = screenshot(ScreenshotView(
            device: device, title: localized("title_year"), imageData: imageData, color: .red
        ))
        saveScreenshot(screenshot, fileName: "1")
    }

    @MainActor func monthView() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Item.self, configurations: config)
        let context = container.mainContext
        context.addItems([
            .init(id: "1", date: Date(), name: "", price: 100, category: 0, categorySub: nil),
            .init(id: "2", date: Date(), name: "", price: 150, category: 0, categorySub: nil),
            .init(id: "3", date: Date(), name: "", price: 200, category: 0, categorySub: nil),
            .init(id: "4", date: Date(), name: "", price: 200, category: 1, categorySub: nil),
            .init(id: "5", date: Date(), name: "", price: 250, category: 1, categorySub: nil),
            .init(id: "6", date: Date(), name: "", price: 300, category: 1, categorySub: nil),
        ])
        let imageData = screenshot(ContentView(
            year: String(Calendar(identifier: .gregorian).component(.year, from: Date())),
            month: String(Calendar(identifier: .gregorian).component(.month, from: Date())),
            selection: 1
        ).modelContext(context))
        let screenshot = screenshot(ScreenshotView(
            device: device, title: localized("title_month"), imageData: imageData, color: .blue
        ))
        saveScreenshot(screenshot, fileName: "2")
    }

    @MainActor func registerView() {
        let imageData = screenshot(
            RegisterView(
                isRegistered: .init(
                    get: { false },
                    set: { _ in  }),
                items: [
                    .init(id: "1", date: Date(), name: "ほげ", price: 200, categoryValue: 0, categorySubValue: 0),
                    .init(id: "2", date: Date(), name: "ふが", price: 1200, categoryValue: 1, categorySubValue: 0),
                    .init(id: "3", date: Date(), name: "ふー", price: 250, categoryValue: 1, categorySubValue: 1),
                    .init(id: "4", date: Date(), name: "ぴよ", price: 23000, categoryValue: 0, categorySubValue: 1),
                    .init(id: "5", date: Date(), name: "ほげほげ", price: 2100, categoryValue: 0, categorySubValue: 2)
                ]))
        let screenshot = screenshot(ScreenshotView(
            device: device, title: localized("title_register"), imageData: imageData, color: .green
        ))
        saveScreenshot(screenshot, fileName: "3")
    }
}

extension ScreenshotTests {

    @MainActor var folderName: String {
        let names = UIDevice.current.name.components(separatedBy: " ")
        let index = names.firstIndex(where: { $0 == "iPhone" || $0 == "iPad" }) ?? 0
        return names.suffix(names.count - index).joined(separator: " ")
    }

    @MainActor func saveScreenshot(_ imageData: Data, fileName: String) {
        let fileManager = FileManager.default
        let directoryPath = ProcessInfo.processInfo.environment["SCREENSHOTS_DIR"]! + "/\(self.folderName)"
        if !fileManager.fileExists(atPath: directoryPath) {
            try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: false, attributes: nil)
        }
        let path = "\(directoryPath)/\(Locale.current.identifier)_\(fileName).png"
        fileManager.createFile(atPath: path, contents: imageData, attributes: nil)
    }

    @MainActor func screenshot(_ view: some View) -> Data {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIHostingController(rootView: view)
        window.rootViewController = vc
        window.makeKeyAndVisible()
        vc.view.layoutIfNeeded()
        vc.view.setNeedsLayout()
        return vc.view.snapshot().pngData()!
    }
}

extension ScreenshotTests {

    func localized(_ key: String) -> String {
        class Tmp {}
        return Bundle(for: Tmp.self).localizedString(forKey: key, value: nil, table: nil)
    }
}

extension UIView {

    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
