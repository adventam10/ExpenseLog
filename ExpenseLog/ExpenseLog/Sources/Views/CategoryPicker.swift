//
//  CategoryPicker.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import SwiftUI

struct CategoryPicker: View {

    /// 選択項目
    @Binding var categorySelection: Int
    /// 選択サブ項目（未選択の場合はCategory.unselectedValue（-1））
    @Binding var categorySubSelection: Int

    private let categoryList = Category.categoryValues
    private let categorySubList = [
        [Category.unselectedValue] + FoodSub.allCases.map { $0.rawValue },
        [Category.unselectedValue] + EntertainmentSub.allCases.map { $0.rawValue }
    ]

    var body: some View {
        VStack {
            HStack {
                Picker("category_picker_label", selection: $categorySelection) {
                    ForEach(categoryList, id:\.self) { value in
                        let category = Category(categoryValue: value, categorySubValue: nil)
                        Text(category.name)
                            .tag(value)
                    }
                }

                Picker("category_sub_picker_label", selection: $categorySubSelection) {
                    ForEach(categorySubList[categorySelection], id:\.self) { value in
                        let category = Category(categoryValue: categorySelection, categorySubValue: value)
                        Text(category.subName)
                            .tag(value)
                    }
                }
            }.onChange(of: categorySelection, { _, _ in
                categorySubSelection = Category.unselectedValue
            })
        }
    }
}

//#Preview {
//    CategoryPicker()
//}
