//
//  UIView+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/14.
//

import UIKit

extension UIView {
    /// 둥글게 만들어줍니다.
    ///  - Parameter cornerRadius: 곡선 값
    func makeRounded(with cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    /// 특정 모서리만 둥글게 만들어 줍니다.
    ///  - Parameter cornerRadius: 곡선 값
    ///  - Parameter maskedCorners: 적용할 corners
    func makeRoundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    func makeBorder(width: CGFloat, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
}
