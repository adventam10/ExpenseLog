//
//  LoadingView.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/10.
//

import SwiftUI

struct LoadingView: UIViewControllerRepresentable {

    let isLoading: Bool

    func makeUIViewController(context: Context) -> LoadingViewController {
        return LoadingViewController()
    }

    func updateUIViewController(_ uiViewController: LoadingViewController, context: Context) {
        if isLoading {
            uiViewController.start()
        }
    }
}
