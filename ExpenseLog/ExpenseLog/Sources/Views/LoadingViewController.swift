//
//  LoadingViewController.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/10.
//

import UIKit

final class LoadingViewController: UIViewController {

    var timer: Timer?

    private let imageSize = CGSize(width: 80, height: 80)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .screenBackground
    }

    func start() {
        view.subviews.forEach { $0.removeFromSuperview() }
        timer?.invalidate()
        timer = Timer
            .scheduledTimer(
                withTimeInterval: 1.0,
                repeats: true
            ) { _ in
                Task { @MainActor in
                    self.addImage(at: self.randomPosition())
                }
            }
    }

    private func addImage(at position: CGPoint) {
        let image = UIImageView(frame: .init(origin: position, size: imageSize))
        view.addSubview(image)
        image.animationImages =  Array(1...7).compactMap { UIImage(named: "\($0)") }
        image.animationDuration = 4
        image.animationRepeatCount = 1
        image.image = UIImage(named: "7")
        image.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            image.stopAnimating()
            image.animationImages =  ["7", "8"].compactMap { UIImage(named: $0) }
            image.animationDuration = 0.5
            image.animationRepeatCount = 0
            image.startAnimating()
        }
    }

    private func randomPosition() -> CGPoint {
        let x = CGFloat.random(in: 0...view.frame.width - imageSize.width)
        let y = CGFloat.random(in: view.safeAreaInsets.top...view.frame.height - imageSize.height)
        return .init(x: x, y: y)
    }
}
