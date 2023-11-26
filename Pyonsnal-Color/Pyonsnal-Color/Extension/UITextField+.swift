//
//  UITextField+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/20/23.
//

import UIKit

extension UITextField {
    func addLeftPaddingView(point: Int) {
        let height = Int(self.frame.size.height)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: point, height: height))
        self.leftViewMode = .always
    }
}
