//
//  UIButton+.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/06.
//

import UIKit

extension UIButton {
    func setImage(_ kind: ImageAssetKind, for state: UIControl.State) {
        self.setImage(kind.image, for: state)
    }

    func setImage(_ kind: ImageAssetKind.HeaderView, for state: UIControl.State) {
        self.setImage(kind.image, for: state)
    }
    
    /// 버튼 텍스트에 언더바를 그어줍니다.
    ///  - Parameter text: 언더바 적용할 text
    ///  - Parameter color: 언더바 및 텍스트  color
    ///  - Parameter font: 텍스트  폰트
    func addUnderLine(with text: String?,
                      color: UIColor?,
                      font: UIFont?) {
        guard let text else { return }
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        attributedText.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: range
        )
        if let color {
            attributedText.addAttribute(
                .foregroundColor,
                value: color,
                range: range
            )
        }
        
        if let font {
            attributedText.addAttribute(
                .font,
                value: font,
                range: range
            )
        }
        self.setAttributedTitle(attributedText, for: .normal)
    }
    
    func setCustomFont(text: String, color: UIColor, font: UIFont) {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedString.addAttribute(.font, value: font, range: range)
        setAttributedTitle(attributedString, for: .normal)
    }
}
