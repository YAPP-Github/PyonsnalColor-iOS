//
//  UIFont+.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/07.
//

import UIKit

extension UIFont {
    
    enum FontFamily: String {
        case pretendard = "Pretendard"
    }
    
    enum FontWeight: String {
        case semiBold = "-SemiBold"
        case medium = "-Medium"
        case regular = "-Regular"
    }
    
    static func customFont(
        family: FontFamily = .pretendard,
        weight: FontWeight,
        size: CGFloat
    ) -> UIFont {
        let fontName = family.rawValue + weight.rawValue
        let font = UIFont(name: fontName, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIFont {

    static let headLine = customFont(weight: .semiBold, size: 28)
    
    static let title1 = customFont(weight: .semiBold, size: 20)
    static let title2 = customFont(weight: .semiBold, size: 18)
    static let title3 = customFont(weight: .semiBold, size: 16)
    
    static let body1m = customFont(weight: .medium, size: 18)
    static let body2m = customFont(weight: .medium, size: 16)
    static let body3m = customFont(weight: .medium, size: 14)
    static let body4m = customFont(weight: .medium, size: 12)
    
    static let body1r = customFont(weight: .regular, size: 18)
    static let body2r = customFont(weight: .regular, size: 16)
    static let body3r = customFont(weight: .regular, size: 14)
    static let body4r = customFont(weight: .regular, size: 12)
    
    static let label1 = customFont(weight: .semiBold, size: 14)
    static let label2 = customFont(weight: .semiBold, size: 12)
    static let label3 = customFont(weight: .medium, size: 10)
    
    var customLineHeight: CGFloat {
        switch self {
        case .headLine:
            return 38
        case .title1:
            return 28
        case .title2:
            return 26
        case .title3:
            return 24
        case .body1m:
            return 26
        case .body2m:
            return 24
        case .body3m:
            return 20
        case .body4m:
            return 16
        case .body1r:
            return 26
        case .body2r:
            return 24
        case .body3r:
            return 20
        case .body4r:
            return 16
        case .label1:
            return 14
        case .label2:
            return 14
        case .label3:
            return 10
        default:
            return self.lineHeight
        }
    }
}
