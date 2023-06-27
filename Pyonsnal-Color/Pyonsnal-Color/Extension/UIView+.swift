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
    
    func makeBorder(width: CGFloat, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    
}
