//
//  EventBannerDetailEntity.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/19/24.
//

import UIKit

struct EventBannerDetailEntity: Decodable, Hashable {
    let userEvent: UserEvent
    let thumbnailImage: String
    let detailImage: String
    let links: [String]
    
    enum CodingKeys: CodingKey {
        case userEvent
        case thumbnailImage
        case detailImage
        case links
    }
}

extension EventBannerDetailEntity {
    /*
    var view: UIView? {
        switch userEvent {
        case .foodChemistryEvent:
            return FoodChemistryEventView(links: links)
        case .launchingEvent:
            return nil
        }
    }
     */
}
