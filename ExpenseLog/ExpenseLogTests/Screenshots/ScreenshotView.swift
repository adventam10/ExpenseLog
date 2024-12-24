//
//  ScreenshotView.swift
//  ExpenseLogTests
//
//  Created by am10 on 2024/12/19.
//

import SwiftUI

enum Device {
    case iPhone16ProMaxPortrait
    case iPadPro13Portrait

    var image: Image {
        switch self {
        case .iPhone16ProMaxPortrait:
            return Image(.iPhone16ProMaxPortrait)
        case .iPadPro13Portrait:
            return Image(.iPadPro13Portrait)
        }
    }

    var radius: CGFloat {
        return self == .iPhone16ProMaxPortrait ? 80 : 0
    }

    var scale: CGFloat {
        switch self {
        case .iPhone16ProMaxPortrait:
            return 0.25
        case .iPadPro13Portrait:
            return 0.4
        }
    }

    var padding: CGFloat {
        switch self {
        case .iPhone16ProMaxPortrait:
            return 16
        case .iPadPro13Portrait:
            return 32
        }
    }
}


struct ScreenshotView: View {
    let device: Device
    let title: String
    let imageData: Data
    let color: Color

    var body: some View {
        ZStack {
            color.ignoresSafeArea()

            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                GeometryReader { proxy in
                    ZStack {
                        Image(uiImage: .init(data: imageData)!)
                            .clipShape(RoundedRectangle(cornerRadius: device.radius))
                        device.image
                    }
                    .scaleEffect(device.scale)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                }
            }
            .padding(device.padding)
            .ignoresSafeArea(.all, edges: [.bottom, .horizontal])
        }
    }
}
