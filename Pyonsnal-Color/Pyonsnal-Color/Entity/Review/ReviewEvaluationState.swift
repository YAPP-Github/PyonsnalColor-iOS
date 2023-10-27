//
//  ReviewEvaluationState.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/18.
//

enum ReviewEvaluationState: String {
    case good = "GOOD"
    case normal = "NORMAL"
    case bad = "BAD"
}

extension ReviewEvaluationState: Codable {
}
