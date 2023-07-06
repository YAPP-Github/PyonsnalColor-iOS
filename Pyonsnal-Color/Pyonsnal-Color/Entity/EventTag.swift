//
//  EventTag.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/04.
//

enum EventTag: String {
    case discount
    case freebie
    case onePlusOne
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
        }
    }
}
