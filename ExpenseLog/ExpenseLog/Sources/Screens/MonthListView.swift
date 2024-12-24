//
//  MonthListView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/07.
//

import SwiftUI

struct MonthListView: View {

    /// ソートの種類
    enum SortType: Int, Identifiable, CaseIterable {
        /// 購入日
        case date
        /// 金額
        case price

        var id: Int {
            return rawValue
        }

        var name: String {
            switch self {
            case .date:
                return .init(localized: "month_sort_type_date_name")
            case .price:
                return .init(localized: "month_sort_type_price_name")
            }
        }
    }

    @Binding var items: [Item]
    @Binding var categorySelection: Int
    @State private var sortType = SortType.date
    @State private var isAscending = true

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d(E)"
        return formatter
    }()
    private let priceFormatter = PriceFormatter()

    var body: some View {
        VStack {
            HStack {
                Picker("month_sort_type_picker_label", selection: $sortType) {
                    ForEach(SortType.allCases) {
                        Text(String(format: String(localized: "month_sort_type_picker_value"), $0.name))
                            .tag($0)
                    }
                }

                Button(action: {
                    isAscending.toggle()
                }, label: {
                    Image(systemName: isAscending ? "arrow.up.right" : "arrow.down.right")
                        .frame(minWidth: 44, minHeight: 44)
                })
                .accessibilityLabel(isAscending ? "sort_button_ascending_accessibility_label" : "sort_button_descending_accessibility_label")
            }

            List {
                ForEach(items, id: \.id) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(dateFormatter.string(from: item.date))
                                .font(.font851tegakizatsu(size: 20))
                            Text(item.name)
                                .font(.font851tegakizatsu(size: 20))
                        }

                        HStack {
                            if categorySelection == Category.unselectedValue {
                                Text(verbatim: "\(item.category.name)（\(item.category.subName)）")
                                    .font(.font851tegakizatsu(size: 14))
                                    .padding(4)
                                    .foregroundStyle(Color.white)
                                    .background(Color(uiColor: item.category.color))
                            } else {
                                Text(item.category.subName)
                                    .font(.font851tegakizatsu(size: 14))
                                    .padding(4)
                                    .foregroundStyle(Color.white)
                                    .background(Color(uiColor: item.category.subColor))
                            }

                            Text(String(format: String(localized: "price_value"),
                                        priceFormatter.format(price: item.price)))
                            .font(.font851tegakizatsu(size: 20))
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .onChange(of: items) { _, _ in
            sort()
        }
        .onChange(of: sortType) { _, _ in
            sort()
        }
        .onChange(of: isAscending) { _, _ in
            sort()
        }
        .onAppear() {
            sort()
        }
    }
}

extension MonthListView {

    private func sort() {
        switch sortType {
        case .date:
            items.sort {
                if isAscending {
                    $0.date < $1.date
                } else {
                    $0.date > $1.date
                }
            }
        case .price:
            items.sort {
                if isAscending {
                    $0.price < $1.price
                } else {
                    $0.price > $1.price
                }
            }
        }
    }
}

//#Preview {
//    MonthListView()
//}
