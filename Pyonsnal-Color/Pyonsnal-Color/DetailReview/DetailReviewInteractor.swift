//
//  DetailReviewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import UIKit
import Combine
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

final class DetailReviewInteractor: PresentableInteractor<DetailReviewPresentable>,
                                    DetailReviewInteractable,
                                    DetailReviewPresentableListener {
    
    weak var router: DetailReviewRouting?
    weak var listener: DetailReviewListener?
    private var cancellable = Set<AnyCancellable>()
    private let component: DetailReviewComponent
    
    init(presenter: DetailReviewPresentable, component: DetailReviewComponent) {
        self.component = component
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
    
    private func uploadReview() {
        let image = presenter.getReviewImage()
        
        component.memberAPIService.info()
            .sink { [weak self] response in
                if let memberInfo = response.value {
                    if let reviewUploadEntity = self?.configureReviewUploadEntity(
                        memberInfo: memberInfo
                    ) {
                        self?.component.productAPIService.uploadReview(
                            reviewUploadEntity,
                            image: image,
                            productId: "000936ab83ac4dc3b98dc84cc57100d1"
                        )
                    }
                }
            }.store(in: &cancellable)
    }
    
    private func configureReviewUploadEntity(memberInfo: MemberInfoEntity) -> ReviewUploadEntity? {
        guard let taste = presenter.reviews[.taste],
              let quality = presenter.reviews[.quality],
              let price = presenter.reviews[.price]
        else {
            return nil
        }
        
        let reviewEntity = ReviewUploadEntity(
            taste: taste.rawValue,
            quality: quality.rawValue,
            valueForMoney: price.rawValue,
            score: Double(presenter.score),
            contents: presenter.getReviewContents(),
            writerId: memberInfo.memberId,
            writerName: memberInfo.nickname
        )
        
        return reviewEntity
    }
}
