//
//  ReviewEvaluationKind.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/29.
//

enum ReviewEvaluationKind {
    case taste
    case quality
    case valueForMoney
    
    var name: String {
        switch self {
        case .taste:
            return "맛"
        case .quality:
            return "퀄리티"
        case .valueForMoney:
            return "가격"
        }
    }
    
    var goodStateText: String {
        switch self {
        case .taste:
            return "맛있어요"
        case .quality:
            return "좋아요"
        case .valueForMoney:
            return "합리적이에요"
        }
    }
    
    var normalStateText: String {
        switch self {
        case .taste:
            return "보통이에요"
        case .quality:
            return "보통이에요"
        case .valueForMoney:
            return "적당해요"
        }
    }
    
    var badStateText: String {
        switch self {
        case .taste:
            return "별로에요"
        case .quality:
            return "별로에요"
        case .valueForMoney:
            return "비싸요"
        }
    }
}
