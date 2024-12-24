//
//  MonthChartView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/07.
//

import Charts
import SwiftUI

struct MonthChartView: View {

    @Binding var items: [Item]
    @Binding var categorySelection: Int
    private let charFormatter = MonthChartFormatter()

    var body: some View {
        let data = chartData // 何度も整形処理がはしらないよう代入
        Chart(data, id: \.id) { categoryData in
            SectorMark(
                angle: .value("pie_chart_sector_label", categoryData.price)
            )
            .foregroundStyle(by: .value(
                "pie_chart_legend_label",
                categorySelection == Category.unselectedValue ? categoryData.category.name : categoryData.category.subName
            ))
        }
        .chartForegroundStyleScale(
            domain: makeChartNameList(chartData: data),
            range: makeChartColorList(chartData: data)
        )
    }
}

extension MonthChartView {

    private var chartData: [MonthChartFormatter.ChartData] {
        if categorySelection == Category.unselectedValue {
            return charFormatter.formatAllItems(items)
        } else {
            return charFormatter.formatCategoryFilteredItems(items)
        }
    }

    private func makeChartNameList(chartData: [MonthChartFormatter.ChartData]) -> [String] {
        if categorySelection == Category.unselectedValue {
            return sortedByCategory(chartData).map { $0.category.name }
        } else {
            return sortedBySubCategory(chartData).map { $0.category.sub?.name ?? .init(localized: "category_sub_none_name") }
        }
    }

    private func makeChartColorList(chartData: [MonthChartFormatter.ChartData]) -> [Color] {
        if categorySelection == Category.unselectedValue {
            return sortedByCategory(chartData).map { Color(uiColor: $0.category.color) }
        } else {
            return sortedBySubCategory(chartData).map { Color(uiColor: $0.category.subColor) }
        }
    }

    private func sortedByCategory(_ chartData: [MonthChartFormatter.ChartData]) -> [MonthChartFormatter.ChartData] {
        return chartData.sorted { $0.category.value < $1.category.value }
    }

    private func sortedBySubCategory(_ chartData: [MonthChartFormatter.ChartData]) -> [MonthChartFormatter.ChartData] {
        return chartData.sorted {
            let value1 = $0.category.sub?.value ?? Int.max
            let value2 = $1.category.sub?.value ?? Int.max
            return value1 < value2
        }
    }
}

//#Preview {
//    MonthChartView()
//}
