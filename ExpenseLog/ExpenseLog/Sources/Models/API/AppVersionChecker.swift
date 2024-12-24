//
//  AppVersionChecker.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/18.
//

import Foundation

struct AppVersionChecker {

    func shouldUpdate()  async throws -> Bool {
        let url = URL(string: "https://raw.githubusercontent.com/adventam10/ExpenseLog/refs/heads/main/AppVersion.json")!
        let data = try await URLSession.shared.data(from: url)
        let response = try JSONSerialization.jsonObject(with: data.0, options: []) as? [String: Any]
        let remoteAppVersion = response?["appVersion"] as? String
        let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return currentAppVersion != remoteAppVersion
    }
}
