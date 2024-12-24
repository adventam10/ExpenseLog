//
//  MonthView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/07.
//

import SwiftUI

struct MonthView: View {

    /// 表示モード
    enum DisplayMode: Int, Identifiable, CaseIterable {
        /// 円グラフ
        case pieChart
        /// 一覧
        case list

        var id: Int {
            return rawValue
        }

        var name: String {
            switch self {
            case .pieChart:
                return .init(localized: "month_display_mode_chart_name")
            case .list:
                return .init(localized: "month_display_mode_list_name")
            }
        }
    }

    @Binding var year: String
    @Binding var month: String
    @Binding var loadingState: LoadingState

    @Environment(\.apiClient) private var apiClient
    @Environment(\.modelContext) private var context
    @State private var items: [Item] = []
    @Environment(\.sizeCategory) private var sizeCategory
    /// 文字サイズが大きいかどうか
    private var isAccessibilityCategory: Bool {
        sizeCategory >= .accessibilityMedium
    }

    private var years: [String] {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        return (currentYear - 10...currentYear).map { String($0) }
    }

    private var months: [String] {
        return (1...12).map { String($0) }
    }

    private let monthSymbols: [String] = DateFormatter().monthSymbols

    private var totalPrice: Int {
        return items.reduce(0) { partialResult, item in
            partialResult + item.price
        }
    }

    @State private var categorySelection: Int = Category.unselectedValue
    @State private var displayMode = DisplayMode.pieChart
    @State private var currentAlert: AlertEntitiy?
    @State private var isAlertShown = false

    var body: some View {
        ZStack {
            Color.screenBackground
                .edgesIgnoringSafeArea(.all)

            VStack {
                if isAccessibilityCategory {
                    VStack {
                        header
                    }
                } else {
                    HStack {
                        header
                    }
                }

                Picker("month_display_mode_picker_label", selection: $displayMode) {
                    ForEach(DisplayMode.allCases) {
                        Text($0.name).tag($0)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                if items.isEmpty {
                    Text("no_data_message")
                } else {
                    Text(String(format: String(localized: "price_value"),
                                PriceFormatter().format(price: totalPrice)))
                    .font(.font851tegakizatsu(size: 24))

                    switch displayMode {
                    case .pieChart:
                        MonthChartView(items: $items, categorySelection: $categorySelection)
                    case .list:
                        MonthListView(items: $items, categorySelection: $categorySelection)
                    }
                }

                if isAccessibilityCategory {
                    Spacer()
                } else {
                    Spacer(minLength: 40)
                }

                Button("fetch_button_title") {
                    Task {
                        loadingState = .loading(message: .init(localized: "loading_fetch_message"))
                        do {
                            let items = try await remoteFetch()
                            context.removeItems(year: year, month: month)
                            context.addItems(items)
                            localFetch()
                            loadingState = .idle
                        } catch let error {
                            showAlert(.init(title: .init(localized: "alert_error_title"),
                                            message: error.localizedDescription))
                            loadingState = .idle
                        }
                    }
                }
            }
            .padding(16)
        }
        .onChange(of: year) { _, _ in
            localFetch()
        }
        .onChange(of: month) { _, _ in
            localFetch()
        }
        .onChange(of: categorySelection) { _, _ in
            localFetch()
        }
        .onAppear() {
            localFetch()
        }
        .alert(
            currentAlert?.title ?? "",
            isPresented: $isAlertShown,
            presenting: currentAlert
        ) { entity in
            Button("alert_default_button_title") {
                entity.okAction?()
            }
        } message: { entity in
            Text(entity.message)
        }
    }

    private var header: some View {
        Group {
            Picker("year_picker_label", selection: $year) {
                ForEach(years, id: \.self) {
                    Text(String(format: String(localized: "year_picker_value"), $0))
                        .tag($0)
                }
            }

            Picker("month_picker_label", selection: $month) {
                ForEach(months, id: \.self) {
                    Text(monthSymbols[Int($0)! - 1])
                        .tag($0)
                }
            }

            CategoryFilterPicker(categorySelection: $categorySelection)
        }
    }
}

extension MonthView {

    private func showAlert(_ alert: AlertEntitiy) {
        currentAlert = alert
        isAlertShown = true
    }

    /// サーバーから選択年月の家計簿データを取得する
    private func remoteFetch() async throws -> [ResponseItem] {
        return try await apiClient.fetch(year: year, month: month)
    }

    /// ローカル DB から年月と項目を指定してデータを取得する
    private func localFetch() {
        let category: Category?
        if categorySelection == Category.unselectedValue {
            category = nil
        } else {
            category = .init(categoryValue: categorySelection, categorySubValue: nil)
        }
        items = context.fetchItems(year: year, month: month, category: category)
    }
}

//#Preview {
//    MonthView()
//}
