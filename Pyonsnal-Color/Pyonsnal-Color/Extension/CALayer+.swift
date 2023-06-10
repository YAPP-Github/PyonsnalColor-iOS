//
//  CALayer+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/11.
//

import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.15,
        width: CGFloat = 0,
        height: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: width, height: height)
        shadowRadius = blur
    }
}
