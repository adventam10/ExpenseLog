//
//  YearView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import Charts
import SwiftUI

struct YearView: View {

    @Binding var year: String
    @Binding var loadingState: LoadingState

    @State private var categorySelection: Int = Category.unselectedValue
    @Environment(\.apiClient) private var apiClient
    @Environment(\.modelContext) private var context
    @Environment(\.sizeCategory) private var sizeCategory
    /// 文字サイズが大きいかどうか
    private var isAccessibilityCategory: Bool {
        sizeCategory >= .accessibilityMedium
    }
    @State private var items: [Item] = []
    @State private var currentAlert: AlertEntitiy?
    @State private var isAlertShown = false

    private let charFormatter = YearChartFormatter()

    private var chartData: [YearChartFormatter.ChartData] {
        if categorySelection == Category.unselectedValue {
            return charFormatter.formatAllItems(items)
        } else {
            return charFormatter.formatCategoryFilteredItems(items)
        }
    }

    private var totalPrice: Int {
        return items.reduce(0) { partialResult, item in
            partialResult + item.price
        }
    }

    private var years: [String] {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        return (currentYear - 10...currentYear).map { String($0) }
    }

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

                Spacer()

                if items.isEmpty {
                    Text("no_data_message")
                } else {
                    Text(String(format: String(localized: "price_value"),
                                PriceFormatter().format(price: totalPrice)))
                    .font(.font851tegakizatsu(size: 24))

                    let data = chartData // 何度も整形処理がはしらないよう代入
                    Chart(data, id: \.id) { categoryData in
                        ForEach(categoryData.monthlyTotalPrices, id: \.id) { monthlyData in
                            BarMark(
                                x: .value("bar_chart_x_label", monthlyData.date, unit: .month),
                                y: .value("bar_chart_y_label", monthlyData.price)
                            )
                            .foregroundStyle(by: .value(
                                "bar_chart_legend_label",
                                categorySelection == Category.unselectedValue ? categoryData.category.name : categoryData.category.subName
                            ))
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .month, count: 1))
                    }
                    .chartForegroundStyleScale(
                        domain: makeChartNameList(chartData: data),
                        range: makeChartColorList(chartData: data)
                    )
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
                            context.removeItems(year: year)
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
            .padding(.init(top: 16, leading: 8, bottom: 16, trailing: 8))
        }
        .onChange(of: year) { _, _ in
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

            CategoryFilterPicker(categorySelection: $categorySelection)
        }
    }
}

extension YearView {

    private func makeChartNameList(chartData: [YearChartFormatter.ChartData]) -> [String] {
        if categorySelection == Category.unselectedValue {
            return sortedByCategory(chartData).map { $0.category.name }
        } else {
            return sortedBySubCategory(chartData).map { $0.category.sub?.name ?? .init(localized: "category_sub_none_name") }
        }
    }

    private func makeChartColorList(chartData: [YearChartFormatter.ChartData]) -> [Color] {
        if categorySelection == Category.unselectedValue {
            return sortedByCategory(chartData).map { Color(uiColor: $0.category.color) }
        } else {
            return sortedBySubCategory(chartData).map { Color(uiColor: $0.category.subColor) }
        }
    }

    private func sortedByCategory(_ chartData: [YearChartFormatter.ChartData]) -> [YearChartFormatter.ChartData] {
        return chartData.sorted { $0.category.value < $1.category.value }
    }

    private func sortedBySubCategory(_ chartData: [YearChartFormatter.ChartData]) -> [YearChartFormatter.ChartData] {
        return chartData.sorted {
            let value1 = $0.category.sub?.value ?? Int.max
            let value2 = $1.category.sub?.value ?? Int.max
            return value1 < value2
        }
    }
}

extension YearView {

    private func showAlert(_ alert: AlertEntitiy) {
        currentAlert = alert
        isAlertShown = true
    }

    /// サーバーから選択年の1~12月の家計簿データを取得する
    private func remoteFetch() async throws -> [ResponseItem] {
        return try await withThrowingTaskGroup(of: [ResponseItem]?.self) { group in
            for month in 1...12 {
                group.addTask {
                    return try await apiClient.fetch(year: year, month: String(month))
                }
            }
            var allItems: [ResponseItem] = []
            for try await items in group {
                if let items = items {
                    allItems.append(contentsOf: items)
                }
            }
            return allItems
        }
    }

    /// ローカル DB から年と項目を指定してデータを取得する
    private func localFetch() {
        let category: Category?
        if categorySelection == Category.unselectedValue {
            category = nil
        } else {
            category = .init(categoryValue: categorySelection, categorySubValue: nil)
        }
        items = context.fetchItems(year: year, category: category)
    }
}

//#Preview {
//    YearView()
//}
