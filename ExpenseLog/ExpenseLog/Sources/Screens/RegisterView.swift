//
//  RegisterView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/08.
//

import SwiftUI

struct RegisterView: View {

    enum Field: Hashable {
        /// 品名
        case name
        /// 金額
        case price
    }

    @Binding var isRegistered: Bool
    @State var items: [Item] = []

    @AppStorage(UserDefaultsKey.registeredCount.rawValue) private var registeredCount = 0
    @StateObject private var feliCaSession = FeliCaSession()
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss

    @State var receiptTexts: [String] = []
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d(E)"
        return formatter
    }()

    @State private var item = Item(
        id: UUID().uuidString, date: Date(),
        name: "", price: 0,
        categoryValue: Category.foodValue, categorySubValue: Category.unselectedValue
    )
    @State private var itemIDSelection: String?

    @Environment(\.apiClient) private var apiClient
    @Environment(\.modelContext) private var context
    @Environment(\.sizeCategory) private var sizeCategory
    /// 文字サイズが大きいかどうか
    private var isAccessibilityCategory: Bool {
        sizeCategory >= .accessibilityMedium
    }

    @State private var currentAlert: AlertEntitiy?
    @State private var isAlertShown = false

    @State private var loadingState = LoadingState.idle
    private let priceFormatter = PriceFormatter()

    var body: some View {
        ZStack {
            Color.screenBackground
                .edgesIgnoringSafeArea(.all)

            if items.isEmpty {
                easterEgg
            }

            VStack {
                HStack {
                    Spacer()
                    Button("cancel_button_title") {
                        dismiss()
                    }
                }

                List(selection: $itemIDSelection) {
                    ForEach(items, id: \.id) { item in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(dateFormatter.string(from: item.date))
                                    .font(.font851tegakizatsu(size: 20))

                                Text(verbatim: "\(item.category.name)（\(item.category.subName)）")
                                    .font(.font851tegakizatsu(size: 14))
                                    .padding(4)
                                    .foregroundStyle(Color.white)
                                    .background(Color(uiColor: item.category.color))
                            }

                            HStack {
                                Text(item.name)
                                    .font(.font851tegakizatsu(size: 20))
                                Text(String(format: String(localized: "price_value"),
                                            priceFormatter.format(price: item.price)))
                                .font(.font851tegakizatsu(size: 20))
                            }
                        }
                    }
                    .onDelete { indexSet in
                        items.remove(atOffsets: indexSet)
                    }
                    .onChange(of: itemIDSelection) { _, newValue in
                        if let newValue = newValue,
                           let item = items.first(where: { $0.id == newValue }) {
                            self.item = item
                            self.item.categorySubValue = item.categorySubValue ?? Category.unselectedValue
                        }
                    }
                }
                .scrollContentBackground(.hidden)

                VStack(spacing: 8) {
                    DatePicker("form_date_title", selection: $item.date, displayedComponents: [.date])

                    TextField("form_name_title", text: $item.name)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .name)
                        .onSubmit {
                            focusedField = .price
                        }

                    TextField("form_price_title", value: $item.price, format: .number)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .focused($focusedField, equals: .price)
                        .onSubmit {
                            focusedField = nil
                        }

                    CategoryPicker(categorySelection: $item.categoryValue, categorySubSelection: .init(
                        get: { item.categorySubValue! },
                        set: { item.categorySubValue = $0 }
                    ))
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("close_button_title") {
                            focusedField = nil
                        }
                    }
                }

                if isAccessibilityCategory {
                    Spacer()
                } else {
                    Spacer(minLength: 16)
                }

                VStack(spacing: 8) {
                    Button(itemIDSelection == nil ? "add_button_title" : "update_button_title") {
                        focusedField = nil
                        if let message = ItemValidator().validate(item) {
                            showAlert(.init(title: .init(localized: "alert_error_title"),
                                            message: message))
                            return
                        }

                        if itemIDSelection == nil {
                            // 追加の場合
                            items.append(makeItem())
                        } else {
                            // 更新の場合
                            if let index = items.firstIndex(where: { $0.id == itemIDSelection }) {
                                items[index] = makeItem()
                            }
                            itemIDSelection = nil
                        }

                        clearItem()
                    }

                    ReadReceiptButton(receiptTexts: $receiptTexts)
                        .onChange(of: receiptTexts) { _, newValue in
                            if newValue.isEmpty {
                                return
                            }
                            let results = ReceiptDataFormatter().format(newValue).map {
                                Item(
                                    id: UUID().uuidString, date: item.date,
                                    name: $0.name, price: $0.price, categoryValue: item.categoryValue,
                                    categorySubValue: item.categorySubValue
                                )
                            }
                            items.append(contentsOf: results)
                            receiptTexts.removeAll()
                        }

                    Button {
                        feliCaSession.startReadSession { dataList, error in
                            if let error = error {
                                showAlert(.init(title: .init(localized: "alert_error_title"),
                                                message: error.localizedDescription))
                            } else if let dataList = dataList {
                                items.append(contentsOf: FeliCaDataFormatter().format(feliCaData: dataList))
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "creditcard.viewfinder")
                            Text("read_ic_card_button_title")
                        }
                    }
                }

                if isAccessibilityCategory {
                    Spacer()
                } else {
                    Spacer(minLength: 80)
                }

                Button {
                    focusedField = nil
                    if items.isEmpty {
                        showAlert(.init(title: .init(localized: "alert_error_title"),
                                        message: .init(localized: "alert_register_items_empty")))
                        return
                    }

                    Task {
                        loadingState = .loading(message: .init(localized: "loading_register_message"))
                        do {
                            try await register()
                            registeredCount += 1
                            loadingState = .idle
                            showAlert(.init(title: "",
                                            message: .init(localized: "alert_registered_message"),
                                            okAction: {
                                dismiss()
                                isRegistered = true
                            }))
                        } catch let error {
                            loadingState = .idle
                            showAlert(.init(title: .init(localized: "alert_error_title"),
                                            message: error.localizedDescription))
                        }
                    }
                } label: {
                    Text("register_button_title")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(RoundedFillButtonStyle(color: .fillButton))
            }
            .padding(16)
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

            if case .loading(let message) = loadingState {
                LoadingView(isLoading: true).ignoresSafeArea()

                Text(message).foregroundColor(Color(uiColor: .label))
            }
        }
    }

    private var easterEgg: some View {
        VStack {
            Spacer().frame(height: 80)

            PageView(pages: [
                AnyView(Color.screenBackground),
                AnyView(
                    HStack {
                        Image(.am10)
                            .resizable()
                            .frame(width: 50, height: 50)

                        Text(verbatim: "わたしがつくりました")
                    }
                )
            ])
            .frame(height: 50)

            Spacer()
        }
    }
}

extension RegisterView {

    /// 入力項目から家計簿データを作成する
    /// - Returns: 家計簿データ
    private func makeItem() -> Item {
        return .init(id: item.id, date: item.date,
                     name: item.name, price: item.price,
                     categoryValue: item.categoryValue,
                     categorySubValue: item.categorySubValue)
    }

    /// 入力項目クリア
    ///
    /// 購入日と項目・サブ項目はクリアしない
    private func clearItem() {
        item.id = UUID().uuidString
        item.name = ""
        item.price = 0
    }
}

extension RegisterView {

    private func showAlert(_ alert: AlertEntitiy) {
        currentAlert = alert
        isAlertShown = true
    }

    private func register() async throws {
        let responseItems = try await apiClient.register(items: items.map {
            let item = $0
            if item.categorySubValue == Category.unselectedValue {
                item.categorySubValue = nil
            }
            return item.convert()
        })
        context.addItems(responseItems)
    }
}

//#Preview {
//    RegisterView()
//}
