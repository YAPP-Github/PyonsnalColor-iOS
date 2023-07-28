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
    case curation // 큐레이션
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try? container.decode(String.self)
        switch type {
        case "sort": self = .sort
        case "recommend": self = .recommend
        case "category": self = .category
        case "event": self = .event
        case "curation" : self = .curation
        default: self = .unknown
        }
    }
    
    var filterDefaultText: String {
        switch self {
        case .sort:
            return "최신순"
        case .recommend:
            return "상품 추천"
        case .category:
            return "카테고리"
        case .event:
            return "행사"
        case .curation:
            return "큐레이션"
        case .unknown:
            return ""
        }
    }
    
    var iconImage: ImageAssetKind.Filter? {
        switch self {
        case .sort:
            return .sortFilter
        case .recommend, .category, .event, .curation:
            return .filter
        case .unknown:
            return nil
        }
    }
    
    var iconDirection: FilterItemIconDirection? {
        switch self {
        case .sort:
            return .left
        case .recommend, .category, .event, .curation:
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
        case .category, .event, .curation:
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
