//
//  FilterType.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/25.
//

import Foundation

enum FilterType: Decodable {
    case sort // 정렬
    case recommend // 상품 추천
    case category // 카테고리
    case event // 행사
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try? container.decode(String.self)
        switch type {
        case "sort": self = .sort
        case "recommend": self = .recommend
        case "category": self = .category
        case "event": self = .event
        default: self = .unknown
        }
    }
    
    var iconImage: ImageAssetKind.Filter? {
        switch self {
        case .sort:
            return .sortFilter
        case .recommend, .category, .event:
            return .filter
        case .unknown:
            return nil
        }
    }
    
    var iconDirection: FilterItemIconDirection? {
        switch self {
        case .sort:
            return .left
        case .recommend, .category, .event:
            return .right
        case .unknown:
            return nil
        }
    }
    
    var bottomSheetType: FilterBottomSheetType {
        switch self {
        case .sort:
            return .check
        case .recommend:
            return .radio
        case .category, .event:
            return .checkWithImage
        case .unknown:
            return .check
        }
    }
    
    enum FilterItemIconDirection {
        case left, right
    }
    
    enum FilterBottomSheetType {
        case radio
        case check
        case checkWithImage
    }
}
