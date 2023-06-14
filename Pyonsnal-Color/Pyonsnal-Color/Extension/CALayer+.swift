//
//  CALayer+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/11.
//

import UIKit

extension CALayer {
    func applyShadow(color: UIColor, alpha: Float, width: CGFloat, height: CGFloat, blur: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: width, height: height)
        shadowRadius = blur
    }
}
