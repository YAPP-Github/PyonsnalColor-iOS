//
//  FilterButton.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit

class FilterButton: UIButton {
    struct ButtonAttributes {
        var textColor: UIColor?
        var iconImage: UIImage?
    }
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        
    }
}
