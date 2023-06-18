//
//  UIColor+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/18.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    convenience init?(rgbHexString: String, alpha: CGFloat = 1.0) {
        var hexSanitized = rgbHexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        self.init(rgbHex: rgbValue, alpha: alpha)
    }
    
    private convenience init?(rgbHex: UInt64, alpha: CGFloat = 1.0) {
            self.init(red: CGFloat((rgbHex & 0xFF0000) >> 16) / 255.0,
                     green: CGFloat((rgbHex & 0x00FF00) >> 8) / 255.0,
                     blue: CGFloat(rgbHex & 0x0000FF) / 255.0,
                     alpha: CGFloat(alpha))
    }
}

extension UIColor {
    
    //Gray Scale
    static let black = UIColor(rgbHexString: "#000000")
    static let gray1 = UIColor(rgbHexString: "#333333")
    static let gray2 = UIColor(rgbHexString: "#585858")
    static let gray3 = UIColor(rgbHexString: "#7D7D7D")
    static let gray4 = UIColor(rgbHexString: "#A3A3A3")
    static let gray5 = UIColor(rgbHexString: "#CACACA")
    static let gray6 = UIColor(rgbHexString: "#EDEDED")
    static let gray7 = UIColor(rgbHexString: "#F5F5F5")
    static let white = UIColor(rgbHexString: "#FFFFFF")
    
    //Point Color
    static let point1 = UIColor(rgbHexString: "#EC6653")
    static let point2 = UIColor(rgbHexString: "#F1887A")
    static let point3 = UIColor(rgbHexString: "#F6A9A2")
    static let point4 = UIColor(rgbHexString: "#FACBC9")
    static let point5 = UIColor(rgbHexString: "#FFECF0")
    
    //Error
    static let error1 = UIColor(rgbHexString: "#FF442A")
}

