//
//  NSMutableAttributedString+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/14.
//

import UIKit

extension NSMutableAttributedString {
    
    /// 특정 문자열의 color와 font 속성을 부여합니다.
    ///  - Parameter font: 적용할 font 속성 값
    ///  - Parameter color: 적용할 color 속성 값
    func appendAttributes(string: String,
                          font: UIFont?,
                          color: UIColor?) {
        var attr: [NSAttributedString.Key: Any] = [:]
        attr[.font] = font
        attr[.foregroundColor] = color
        self.append(NSAttributedString(string: string, attributes: attr))
    }
}
