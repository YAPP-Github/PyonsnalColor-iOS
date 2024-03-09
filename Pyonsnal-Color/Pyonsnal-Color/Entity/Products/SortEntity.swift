//
//  SortEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/08.
//

struct SortEntity: Decodable {
    let isEmpty: Bool
    let unsorted: Bool
    let isSorted: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isEmpty = "empty"
        case unsorted
        case isSorted = "sorted"
    }
}
