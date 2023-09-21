//
//  StarRatingReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewRouting: ViewableRouting {
    func attachDetailReview()
}

protocol StarRatingReviewPresentable: Presentable {
    var listener: StarRatingReviewPresentableListener? { get set }
}

protocol StarRatingReviewListener: AnyObject {
}

final class StarRatingReviewInteractor: PresentableInteractor<StarRatingReviewPresentable>, StarRatingReviewInteractable, StarRatingReviewPresentableListener {

    weak var router: StarRatingReviewRouting?
    weak var listener: StarRatingReviewListener?

    override init(presenter: StarRatingReviewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didFinishStarRating() {
        router?.attachDetailReview()
    }
}
