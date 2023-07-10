//
//  PageableEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

struct PageableEntity: Decodable {
    let offset: Int
    let pageSize: Int
    let isPaged: Bool
    let pageNumber: Int
    let isUnpaged: Bool
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case pageSize
        case isPaged = "paged"
        case pageNumber
        case isUnpaged = "unpaged"
    }
}
