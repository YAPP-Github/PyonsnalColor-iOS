//
//  UIColor+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/18.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
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
    static let black = UIColor(rgbHexString: "1A1A1E")!
    static let gray700 = UIColor(rgbHexString: "343437")!
    static let gray600 = UIColor(rgbHexString: "4D4D51")!
    static let gray500 = UIColor(rgbHexString: "808084")!
    static let gray400 = UIColor(rgbHexString: "B3B3B6")!
    static let gray300 = UIColor(rgbHexString: "CDCDCF")!
    static let gray200 = UIColor(rgbHexString: "EAEAEC")!
    static let gray100 = UIColor(rgbHexString: "F7F7F9")!
    static let white = UIColor(rgbHexString: "FFFFFF")!
    
    //Primary - Red
    static let red500 = UIColor(rgbHexString: "FF625F")!
    static let red400 = UIColor(rgbHexString: "FF8888")!
    static let red300 = UIColor(rgbHexString: "FFAAAA")!
    static let red200 = UIColor(rgbHexString: "FFCCCB")!
    static let red100 = UIColor(rgbHexString: "FFF1F0")!
    
    //Primary - Green
    static let green500 = UIColor(rgbHexString: "3DDE8F")!
    static let green300 = UIColor(rgbHexString: "83EEBA")!
    static let green100 = UIColor(rgbHexString: "EEFFF7")!
    
    //Primary - Orange
    static let orange500 = UIColor(rgbHexString: "FFA724")!
    static let orange300 = UIColor(rgbHexString: "FFCA75")!
    static let orange100 = UIColor(rgbHexString: "FFF8EC")!
    
    //Primary - Blue
    static let blue500 = UIColor(rgbHexString: "29BFFF")!
    static let blue300 = UIColor(rgbHexString: "6DD7FF")!
    static let blue100 = UIColor(rgbHexString: "EDFAFF")!
    
    //Store Color
    static let sevenEleven = UIColor(rgbHexString: "ED4925")!
    static let gs25 = UIColor(rgbHexString: "00D4EA")!
    static let emart24 = UIColor(rgbHexString: "FCB426")!
    static let cu = UIColor(rgbHexString: "A5CF4F")!
    
    //Error
    static let error1 = UIColor(rgbHexString: "FF442A")!
}

