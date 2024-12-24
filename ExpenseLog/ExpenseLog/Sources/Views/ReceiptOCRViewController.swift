//
//  ReceiptOCRViewController.swift
//  ExpenseLog
//
//  Created by am10 on 2024/12/09.
//

import UIKit
import Vision

protocol ReceiptOCRViewControllerDelegate: AnyObject {

    /// レシート画像からの読み取り処理後の通知
    /// - Parameter texts: レシート画像から読み取った文字列
    ///
    /// 1 行ずつ返し同じ行の文字列は半角スペースで連結している。
    /// 読み取り失敗時は空配列。
    func didReadTexts(_ texts: [String])
}

final class ReceiptOCRViewController: UIViewController {

    /// タップした場所
    enum TapRegion {
        /// 左上
        case topLeft
        /// 右上
        case topRight
        /// 左下
        case bottomLeft
        /// 右下
        case bottomRight
        /// 中心
        case center
    }

    /// レシート画像
    var receiptImage: UIImage?
    weak var delegate: ReceiptOCRViewControllerDelegate?

    /// 範囲指定用（赤枠のView）
    private var regionView: UIView!
    /// レシート画像表示用
    private var receiptImageView: UIImageView!
    /// regionViewのタップした場所
    private var tappedRegion: TapRegion? = nil

    /// tappedRegionでcenterと判定する範囲
    private let regionViewCenterRegion = CGSize(width: 40, height: 40)
    /// regionViewの幅と高さの最小値
    private let regionViewMinSize = CGSize(width: 60, height: 60)
    /// regionViewの初期表示のサイズ
    private let regionViewDefaultSize = CGSize(width: 200, height: 200)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        receiptImageView = UIImageView(image: receiptImage)
        view.addSubview(receiptImageView)
        receiptImageView.translatesAutoresizingMaskIntoConstraints = false

        let readButton = UIButton()
        readButton.setTitle(.init(localized: "ocr_read_button_title"), for: .normal)
        readButton.backgroundColor = .fillButton
        readButton.addAction(.init(handler: { [weak self] _ in
            self?.readImage()
        }), for: .touchUpInside)
        view.addSubview(readButton)
        readButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            receiptImageView.topAnchor.constraint(equalTo: view.topAnchor),
            receiptImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            receiptImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            readButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            readButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            readButton.heightAnchor.constraint(equalToConstant: 60),
            receiptImageView.bottomAnchor.constraint(equalTo: readButton.topAnchor, constant: 16)
        ])

        regionView = UIView(frame: .init(origin: .zero, size: regionViewDefaultSize))
        view.addSubview(regionView)
        regionView.center = view.center
        regionView.backgroundColor = .clear
        regionView.layer.borderColor = UIColor.red.cgColor
        regionView.layer.borderWidth = 1
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view),
              regionView.frame.contains(point) else {
            tappedRegion = nil
            return
        }

        let touchedPoint = view.convert(point, to: regionView)
        let center = CGPoint(x: regionView.frame.size.width/2, y: regionView.frame.size.height/2)
        if CGRect(x: center.x - regionViewCenterRegion.width/2, y: center.y - regionViewCenterRegion.height/2,
                  width: regionViewCenterRegion.width, height: regionViewCenterRegion.height).contains(touchedPoint) {
            tappedRegion = .center
        } else if touchedPoint.x < center.x {
            if touchedPoint.y < center.y {
                tappedRegion = .topLeft
            } else {
                tappedRegion = .bottomLeft
            }
        } else {
            if touchedPoint.y < center.y {
                tappedRegion = .topRight
            } else {
                tappedRegion = .bottomRight
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view),
              let tappedRegion = tappedRegion else {
            return
        }

        var frame = regionView.frame
        switch tappedRegion {
        case .topLeft:
            frame.origin.x = point.x
            frame.origin.y = point.y
            frame.size.width += regionView.frame.origin.x - point.x
            frame.size.height += regionView.frame.origin.y - point.y
        case .topRight:
            frame.origin.y = point.y
            frame.size.width = point.x - regionView.frame.origin.x
            frame.size.height += regionView.frame.origin.y - point.y
        case .bottomLeft:
            frame.origin.x = point.x
            frame.size.width += regionView.frame.origin.x - point.x
            frame.size.height = point.y - regionView.frame.origin.y
        case .bottomRight:
            frame.size.width = point.x - regionView.frame.origin.x
            frame.size.height = point.y - regionView.frame.origin.y
        case .center:
            regionView.center = point
            return
        }

        if frame.size.width < regionViewMinSize.width {
            frame.size.width = regionViewMinSize.width
        }
        if frame.size.height < regionViewMinSize.height {
            frame.size.height = regionViewMinSize.height
        }
        regionView.frame = frame
    }
}

extension ReceiptOCRViewController {

    private func readImage() {
        guard let rectByImage = receiptImageView?.transformByImage(rect : view.convert(regionView.frame, to: receiptImageView)),
              let image = receiptImageView.image else {
            return
        }

        let croppedImage = image.cgImage?.cropping(to: rectByImage)
        // Visionに渡すように向きを補正
        let fixedOrientationImage = UIImage(
            cgImage: croppedImage!,
            scale: image.scale,
            orientation: image.imageOrientation
        ).fixOrientation()
        let handler = VNImageRequestHandler(cgImage: fixedOrientationImage.cgImage!, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                print(error)
            }
            guard let results = request.results else {
                Task { @MainActor in
                    self?.delegate?.didReadTexts([])
                }
                return
            }
            let texts = self?.formatData(results.compactMap { $0 as? VNRecognizedTextObservation }) ?? []
            Task { @MainActor in
                self?.delegate?.didReadTexts(texts)
            }
        }
        request.preferBackgroundProcessing = true
        request.recognitionLanguages = ["ja-JP"]
        request.usesLanguageCorrection = true
        try? handler.perform([request])
    }

    private func formatData(_ observation: [VNRecognizedTextObservation]) -> [String] {
        struct Text {
            let string: String
            let box: CGRect
        }

        var targets: [Text] = observation.compactMap {
            let string = $0.topCandidates(1).first?.string
            return string != nil ? .init(string: string!, box: $0.boundingBox) : nil
        }.sorted { $0.box.origin.x < $1.box.origin.x }

        // Y座標でまとめる
        var yGroupingTexts = [[Text]]()
        var texts = [Text]()
        while !targets.isEmpty {
            let target = targets.removeFirst()
            let rect = CGRect(x: 0, y: target.box.origin.y, width: 1, height: target.box.size.height)
            texts.append(target)

            while let index = targets.firstIndex(where: {
                let box = $0.box
                let center = CGPoint(x: box.origin.x + box.size.width/2, y: box.origin.y + box.size.height/2)
                return rect.contains(center)
            }) {
                texts.append(targets.remove(at: index))
            }

            yGroupingTexts.append(texts)
            texts.removeAll()
        }

        // 行ごとに半角スペースで結合した文字列のリスト
        return yGroupingTexts.compactMap {
            let y = $0.first!.box.origin.y
            let text = $0.sorted { $0.box.origin.x < $1.box.origin.x }.map { $0.string }.joined(separator: " ")
            return (y, text)
        }
        // y座標で昇順（原点は左下）
        .sorted { $0.0 > $1.0 }.map { $0.1 }
    }
}

fileprivate extension UIImageView {

    /// UIImageView上で指定された範囲をUIImage上の範囲に変換する
    /// - Parameter rect: UIImageView上で指定された範囲
    /// - Returns: UIImage上の範囲
    func transformByImage(rect : CGRect) -> CGRect? {
        guard let image = image else {
            return nil
        }

        let transform: CGAffineTransform
        switch image.imageOrientation {
        case .left:
            transform = CGAffineTransform(rotationAngle: .pi / 2).translatedBy(x: 0, y: -image.size.height)
        case .right:
            transform = CGAffineTransform(rotationAngle: -.pi / 2).translatedBy(x: -image.size.width, y: 0)
        case .down:
            transform = CGAffineTransform(rotationAngle: -.pi).translatedBy(x: -image.size.width, y: -image.size.height)
        default:
            transform = .identity
        }

        return rect.applying(transform.scaledBy(
            x: image.size.width / frame.size.width,
            y: image.size.height / frame.size.height
        ))
    }
}

fileprivate extension UIImage {

    /// 画像の向きを補正する
    /// - Returns: 向きを補正した画像
    func fixOrientation() -> UIImage {
        let context = CIContext()
        let orientation: CGImagePropertyOrientation
        switch imageOrientation {
        case .up:
            orientation = .up
        case .down:
            orientation = .down
        case .left:
            orientation = .left
        case .right:
            orientation = .right
        case .upMirrored:
            orientation = .upMirrored
        case .downMirrored:
            orientation = .downMirrored
        case .leftMirrored:
            orientation = .leftMirrored
        case .rightMirrored:
            orientation = .rightMirrored
        @unknown default:
            orientation = .up
        }
        guard let orientedCIImage = CIImage(image: self)?.oriented(orientation),
              let cgImage = context.createCGImage(orientedCIImage, from: orientedCIImage.extent) else {
            print("Image rotation failed.")
            return self
        }
        return UIImage(cgImage: cgImage)
    }
}
