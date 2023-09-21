//
//  DetailReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs

protocol DetailReviewRouting: ViewableRouting {
    func attachPopup(isApply: Bool)
    func detachPopup()
}

protocol DetailReviewPresentable: Presentable {
    var listener: DetailReviewPresentableListener? { get set }
}

protocol DetailReviewListener: AnyObject {
    func detachDetailReview()
    func routeToProductDetail()
}

final class DetailReviewInteractor: PresentableInteractor<DetailReviewPresentable>, DetailReviewInteractable, DetailReviewPresentableListener {

    weak var router: DetailReviewRouting?
    weak var listener: DetailReviewListener?

    override init(presenter: DetailReviewPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func popupDidTapDismissButton() {
        router?.detachPopup()
    }
    
    func popupDidTapBackButton() {
        listener?.detachDetailReview()
    }
    
    func routeToProductDetail() {
        listener?.routeToProductDetail()
    }
}
