//
//  StarRatingReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewRouting: ViewableRouting {
    func attachDetailReview(score: Int)
    func detachDetailReview()
}

protocol StarRatingReviewPresentable: Presentable {
    var listener: StarRatingReviewPresentableListener? { get set }
}

protocol StarRatingReviewListener: AnyObject {
    func detachStarRatingReview()
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
    
    func didTapRatingButton(score: Int) {
        router?.attachDetailReview(score: score)
    }
    
    func detachDetailReview() {
        router?.detachDetailReview()
    }
    
    func routeToProductDetail() {
        router?.detachDetailReview()
        listener?.detachStarRatingReview()
    }
    
    func didTapBackButton() {
        listener?.detachStarRatingReview()
    }
}
