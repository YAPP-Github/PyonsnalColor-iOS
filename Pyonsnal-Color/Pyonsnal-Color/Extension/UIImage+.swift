//
//  UIImage+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/22.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            draw(in: .init(origin: .zero, size: targetSize))
        }
    }
}
