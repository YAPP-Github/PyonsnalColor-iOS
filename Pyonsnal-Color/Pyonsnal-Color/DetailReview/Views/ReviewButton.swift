//
//  ReviewButton.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/16.
//

import UIKit
import SnapKit

final class ReviewButton: UIButton {
    
    enum Constant {
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
    }
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        makeRounded(with: Constant.cornerRadius)
        titleLabel?.font = .body3m
        setUnselectedState()
    }
    
    func configureButtonTitle(text: String) {
        setTitle(text, for: .normal)
    }
    
    func setSelectedState() {
        removeBorder()
        setTitleColor(.white, for: .normal)
    }
    
    func setUnselectedState() {
        makeBorder(width: Constant.borderWidth, color: UIColor.gray200.cgColor)
        setTitleColor(.gray400, for: .normal)
    }
}
