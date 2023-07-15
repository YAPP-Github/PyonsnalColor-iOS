//
//  CommonConstants.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/13.
//

import Foundation

struct EventHeaderSection {
    var type: EventHomeTabViewController.SectionType
    var text: String
}

struct CommonConstants {
    static let convenienceStore: [String] = ["전체", "CU", "GS25", "Emart24", "7-eleven"]
    static let eventTabHeaderTitle: [EventHeaderSection] = [
        EventHeaderSection(type: .event, text: "이달의 이벤트 💌"),
        EventHeaderSection(type: .item, text: "행사 상품 모아보기 👀")
    ]
}
