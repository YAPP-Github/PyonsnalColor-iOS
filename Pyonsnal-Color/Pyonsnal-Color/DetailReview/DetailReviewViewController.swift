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
    
    enum Constant {
        static let textViewPlaceholder: String = "상품에 대한 솔직한 의견을 알려주세요."
    }
    
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
        viewHolder.detailReviewTextView.delegate = self
        viewHolder.detailReviewTextView.text = Constant.textViewPlaceholder
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

extension DetailReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constant.textViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Constant.textViewPlaceholder
            textView.textColor = .gray400
        }
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
