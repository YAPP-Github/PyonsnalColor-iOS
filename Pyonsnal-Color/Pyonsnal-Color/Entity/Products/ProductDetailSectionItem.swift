//
//  ProductDetailSectionItem.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/17.
//

import Foundation

enum ProductDetailSectionItem {
    case image(imageURL: URL)
    case information(product: ProductConvertable)
    case reviewWrite(score: Double, reviewsCount: Int)
    case review(productReview: ReviewEntity)
}
