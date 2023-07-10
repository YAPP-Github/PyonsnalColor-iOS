//
//  ProductPageEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

struct ProductPageEntity<T: ProductConvertable>: Decodable {
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let content: [T]
    let number: Int
    let sort: SortEntity
    let isFirst: Bool
    let isLast: Bool
    let numberOfElements: Int
    let pageable: PageableEntity
    let isEmpty: Bool
    
    private enum CodingKeys: String, CodingKey {
        case totalPages
        case totalElements
        case size
        case content
        case number
        case sort
        case isFirst = "first"
        case isLast = "last"
        case numberOfElements
        case pageable
        case isEmpty = "empty"
    }
}
