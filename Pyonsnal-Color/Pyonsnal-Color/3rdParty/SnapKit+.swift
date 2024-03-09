//
//  SnapKit+.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import SnapKit

extension ConstraintMakerEditable {
    @discardableResult
    func offset(_ spacing: Spacing) -> ConstraintMakerEditable {
        return offset(spacing.value)
    }
    
    @discardableResult
    func inset(_ spacing: Spacing) -> ConstraintMakerEditable {
        return inset(spacing.value)
    }
}
