//
//  CategoryFilterPicker.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/06.
//

import SwiftUI

/// 項目ピッカー（サブ項目なし）
struct CategoryFilterPicker: View {

    /// 選択した項目
    @Binding var categorySelection: Int

    private let categoryList = [Category.unselectedValue] + Category.categoryValues

    var body: some View {
        Picker("category_picker_label", selection: $categorySelection) {
            ForEach(categoryList, id: \.self) { value in
                if value == Category.unselectedValue {
                    Text("category_picker_all_title")
                        .tag(value)
                } else {
                    Text(Category(categoryValue: value, categorySubValue: nil).name)
                        .tag(value)
                }
            }
        }
    }
}
