//
//  String+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/14.
//

import UIKit

extension String {
    /// 취소선을 그어줍니다.
    ///  - Parameter color: 취소선 색
    func strikeThrough(with color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, attributedString.length)
        
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: range
        )
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughColor,
            value: color,
            range: range
        )
        return attributedString
    }
    
    /// + "원"
    func addWon() -> String {
        return self + "원"
    }
    
    var encodedURLString: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
}
