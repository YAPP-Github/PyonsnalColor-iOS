//
//  Review.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/22.
//

import Foundation

struct Review {
    enum Category {
        case taste, quality, price
    }
    
    enum Score: String, CaseIterable {
        case good = "GOOD"
        case normal = "NORMAL"
        case bad = "BAD"
    }
    
    let category: Category
    let score: Score
}
