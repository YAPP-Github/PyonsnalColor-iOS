//
//  ReviewEntity.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/18.
//

import Foundation

struct ReviewEntity {
    let reviewId: String
    let taste: ReviewEvaluationState
    let quality: ReviewEvaluationState
    let valueForMoney: ReviewEvaluationState
    let score: Double
    let contents: String
    let image: URL?
    let writerId: Int?
    let writerName: String
    let createdTime: String
    let updatedTime: String
    let likeCount: ReviewLikeCountEntity
    let hateCount: ReviewHateCountEntity
}

extension ReviewEntity {
    func update(likeCount: ReviewLikeCountEntity) -> ReviewEntity {
        let review = ReviewEntity(
            reviewId: self.reviewId,
            taste: self.taste,
            quality: self.quality,
            valueForMoney: self.valueForMoney,
            score: self.score,
            contents: self.contents,
            image: self.image,
            writerId: self.writerId,
            writerName: self.writerName,
            createdTime: self.createdTime,
            updatedTime: self.updatedTime,
            likeCount: likeCount,
            hateCount: self.hateCount
        )
        return review
    }
    
    func update(hateCount: ReviewHateCountEntity) -> ReviewEntity {
        let review = ReviewEntity(
            reviewId: self.reviewId,
            taste: self.taste,
            quality: self.quality,
            valueForMoney: self.valueForMoney,
            score: self.score,
            contents: self.contents,
            image: self.image,
            writerId: self.writerId,
            writerName: self.writerName,
            createdTime: self.createdTime,
            updatedTime: self.updatedTime,
            likeCount: self.likeCount,
            hateCount: hateCount
        )
        return review
    }
}

extension ReviewEntity: Hashable {}

extension ReviewEntity: Codable {
}
