//
//  HomeBannerEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 12/26/23.
//

import Foundation

struct HomeBannerEntity: Decodable {
    let type: String
    let value: HomeBannerValue
}

struct HomeBannerValue: Decodable {
    let curation: CurationEntity?
    let eventImage: EventImageEntity?
    
    enum CodingKeys: CodingKey {
        case curation
        case eventImage
    }
    
    init(curation: CurationEntity? = nil, eventImage: EventImageEntity? = nil) {
        self.curation = curation
        self.eventImage = eventImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(CurationEntity.self, forKey: .curation) {
            self = .init(curation: value)
            return
        }
        
        if let value = try? container.decode(EventImageEntity.self, forKey: .eventImage) {
            self = .init(eventImage: value)
            return
        }
        
        throw DecodingError.typeMismatch(
            HomeBannerValue.self, 
                .init(codingPath: decoder.codingPath, debugDescription: "Type Mismatch")
        )
    }
}
