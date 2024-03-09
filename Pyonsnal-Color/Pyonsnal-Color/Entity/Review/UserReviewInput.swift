//
//  UserReviewInput.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 12/28/23.
//

import UIKit

struct UserReviewInput {
    let reviews: [ReviewEvaluationKind : ReviewEvaluationState]
    let reviewContents: String
    let reviewImage: UIImage?
}
