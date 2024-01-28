//
//  HomeBannerEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 12/26/23.
//

import Foundation

struct HomeBanner: Decodable {
    let homeBanner: [HomeBannerEntity]
}

struct HomeBannerEntity: Decodable {
    let type: String
    let value: [HomeBannerValue]
}

struct HomeBannerValue: Decodable {
    let curationProducts: CurationEntity?
    let eventBanners: EventImageEntity?
    
    enum CodingKeys: CodingKey {
        case curationProducts
        case eventBanners
    }
    
    init(curationProducts: CurationEntity? = nil, eventBanners: EventImageEntity? = nil) {
        self.curationProducts = curationProducts
        self.eventBanners = eventBanners
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(CurationEntity.self) {
            self = .init(curationProducts: value)
            return
        }
        
        if let value = try? container.decode(EventImageEntity.self) {
            self = .init(eventBanners: value)
            return
        }
        
        throw DecodingError.typeMismatch(
            HomeBannerValue.self, 
            .init(codingPath: decoder.codingPath, debugDescription: "Type Mismatch")
        )
    }
}
