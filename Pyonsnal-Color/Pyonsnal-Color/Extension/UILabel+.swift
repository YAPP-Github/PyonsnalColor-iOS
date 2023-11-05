//
//  UILabel+.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/27.
//

import UIKit

extension UILabel {
    func addAttributedString(newText: String,font: UIFont?, color: UIColor?) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.appendAttributes(string: newText, font: font, color: color)
        
        self.attributedText = attributedString
    }
}
