//
//  EventTag.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/04.
//

enum EventTag: String, Decodable {
    case discount = "DISCOUNT"
    case freebie = "GIFT"
    case onePlusOne = "ONE_TO_ONE"
    case twoPlusOne = "TWO_TO_ONE"
    case threePlusOne = "THREE_TO_ONE"
}

extension EventTag {
    var name: String {
        switch self {
        case .discount:
            return "할인"
        case .freebie:
            return "증정품"
        case .onePlusOne:
            return "1 + 1"
        case .twoPlusOne:
            return "2 + 1"
        case .threePlusOne:
            return "3 + 1"
        }
    }
}
