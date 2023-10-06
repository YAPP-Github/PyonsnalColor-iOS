//
//  DetailReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import UIKit
import ModernRIBs

protocol DetailReviewRouting: ViewableRouting {
    func attachPopup(isApply: Bool)
    func detachPopup()
}

protocol DetailReviewPresentable: Presentable {
    var listener: DetailReviewPresentableListener? { get set }
    var reviews: [Review.Category: Review.Score] { get }
    var score: Int { get }
    func getReviewContents() -> String
    func getReviewImage() -> UIImage?
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
    
    func didTapBackButton() {
        router?.attachPopup(isApply: false)
    }
    
    func didTapApplyButton() {
        router?.attachPopup(isApply: true)
    }
    
    func popupDidTapDismissButton() {
        router?.detachPopup()
    }
    
    func popupDidTapBackButton() {
        router?.detachPopup()
        listener?.detachDetailReview()
    }
    
    func routeToProductDetail() {
        router?.detachPopup()
        listener?.routeToProductDetail()
    }
    
    private func convertToReview() {
        let reviews = presenter.reviews
        let contents = presenter.getReviewContents().trimmingCharacters(in: .whitespacesAndNewlines)
        let image = presenter.getReviewImage()
    }
}
