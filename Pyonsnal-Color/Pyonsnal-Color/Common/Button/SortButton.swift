//
//  SortButton.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

class SortButton: UIButton {
    
    // MARK: - Initializer
    init(title: String) {
        super.init(frame: .zero)
        self.setText(with: title)
        self.titleLabel?.font = .body3m
        self.setImage(.sortFilter, for: .normal)
        self.setTitleColor(.gray500, for: .normal)
        self.setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setSelectedState(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func updateUISelected() {
        self.tintColor = .white
        self.backgroundColor = .gray700
    }
    
    func updateUIUnSelected() {
        self.tintColor = .gray500
        self.backgroundColor = .white
    }

}
