//
//  ContentView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/04.
//

import StoreKit
import SwiftUI

struct ContentView: View {

    @State var year: String
    @State var month: String
    @State var selection = 0

    @State private var isPresented = false
    @State private var loadingState = LoadingState.idle

    @AppStorage(UserDefaultsKey.registeredCount.rawValue) private var registeredCount = 0
    @State private var isRegistered = false
    @Environment(\.requestReview) private var requestReview

    @State private var currentAlert: AlertEntitiy?
    @State private var isAlertShown = false
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                YearView(year: $year, loadingState: $loadingState)
                    .tabItem {
                        Image(systemName: "y.circle.fill")
                        Text("tab_year_title")
                    }.tag(0)

                MonthView(year: $year, month: $month, loadingState: $loadingState)
                    .tabItem {
                        Image(systemName: "m.circle.fill")
                        Text("tab_month_title")
                    }.tag(1)
            }

            FloatingButton(color: .fillButton, shadowColor: .buttonShadow) {
                isPresented = true
            }.fullScreenCover(isPresented:  $isPresented) {
                RegisterView(isRegistered: $isRegistered)
            }.accessibilityLabel("show_register_button_accessibility_label")

            if case .loading(let message) = loadingState {
                LoadingView(isLoading: true).ignoresSafeArea()

                Text(message).foregroundColor(Color(uiColor: .label))
            }
        }
        .onChange(of: isRegistered) { oldValue, newValue in
            if newValue {
                isRegistered = false
                if registeredCount >= 10 {
                    requestReview()
                }
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .active:
                Task {
                    do {
                        let shouldUpdate = try await AppVersionChecker().shouldUpdate()
                        if shouldUpdate {
                            showAlert(.init(title: "", message: .init(localized: "app_update_message")) {
                                // FIXME: ここにストアのURL設定
                                openURL(URL(string: "https://apps.apple.com/app/%E3%82%B5%E3%82%A4%E3%82%B3%E3%83%AD%E4%BA%BA%E7%94%9F/id6450755473")!)
                            })
                        }
                    } catch let error {
                        print(error)
                    }
                }
            default:
                break
            }
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
}

extension ContentView {

    private func showAlert(_ alert: AlertEntitiy) {
        currentAlert = alert
        isAlertShown = true
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
