//
//  DetailReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs
import UIKit

protocol DetailReviewPresentableListener: AnyObject {
    func didTapBackButton()
}

final class DetailReviewViewController: UIViewController, DetailReviewPresentable, DetailReviewViewControllable {
    
    weak var listener: DetailReviewPresentableListener?
    private let viewHolder = ViewHolder()
    private var reviews: [Review.Category: Review.Score] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        view.backgroundColor = .white
        configureView()
    }
    
    private func configureView() {
        viewHolder.backNavigationView.delegate = self
        viewHolder.tasteReview.delegate = self
        viewHolder.qualityReview.delegate = self
        viewHolder.priceReview.delegate = self
    }
    
    private func setApplyReviewButton(state isSatisfy: Bool) {
        let state: PrimaryButton.ButtonSelectable = isSatisfy ? .enabled : .disabled
        viewHolder.applyReviewButton.setState(with: state)
    }
    
    private func isReviewAllSatisfy() -> Bool {
        if viewHolder.priceReview.hasSelected() && viewHolder.qualityReview.hasSelected() &&
            viewHolder.tasteReview.hasSelected() {
            return true
        }
        return false
    }
}

extension DetailReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension DetailReviewViewController: SingleLineReviewDelegate {
    func didSelectReview(_ review: Review) {
        reviews[review.category] = review.score
        
        let state = isReviewAllSatisfy()
        setApplyReviewButton(state: state)
    }
}
