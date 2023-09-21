//
//  StarRatingReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol StarRatingReviewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol StarRatingReviewPresentable: Presentable {
    var listener: StarRatingReviewPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol StarRatingReviewListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class StarRatingReviewInteractor: PresentableInteractor<StarRatingReviewPresentable>, StarRatingReviewInteractable, StarRatingReviewPresentableListener {

    weak var router: StarRatingReviewRouting?
    weak var listener: StarRatingReviewListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: StarRatingReviewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
