//
//  Spacing.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/24.
//

import UIKit

struct Spacing {
    let value: CGFloat
    
    private init(value: CGFloat) {
        self.value = value
    }
    
    var negative: Spacing {
        Spacing(value: -value)
    }
}

extension Spacing {
    static let spacing2: Spacing = .init(value: 2)
    static let spacing4: Spacing = .init(value: 4)
    static let spacing6: Spacing = .init(value: 6)
    static let spacing8: Spacing = .init(value: 8)
    static let spacing10: Spacing = .init(value: 10)
    static let spacing12: Spacing = .init(value: 12)
    static let spacing16: Spacing = .init(value: 16)
    static let spacing20: Spacing = .init(value: 20)
    static let spacing24: Spacing = .init(value: 24)
    static let spacing32: Spacing = .init(value: 32)
    static let spacing40: Spacing = .init(value: 40)
}
