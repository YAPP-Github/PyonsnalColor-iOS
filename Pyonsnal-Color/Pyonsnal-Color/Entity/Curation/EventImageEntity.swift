//
//  EventImageEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 12/26/23.
//

import Foundation

struct EventImageEntity: Decodable, Hashable {
    let title: String
    let bannerDetails: [EventBannerDetailEntity]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case bannerDetails
    }
}
