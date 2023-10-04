//
//  StarRatingReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import Combine
import ModernRIBs

protocol StarRatingReviewPresentableListener: AnyObject {
    func didTapBackButton()
    func didTapRatingButton(score: Int)
}

final class StarRatingReviewViewController: UIViewController, StarRatingReviewPresentable, StarRatingReviewViewControllable {

    weak var listener: StarRatingReviewPresentableListener?
    private let viewHolder = ViewHolder()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        view.backgroundColor = .white
        configureNavigationView()
        configureStarRatingView()
    }
    
    private func configureNavigationView() {
        viewHolder.backNavigationView.delegate = self
    }
    
    private func configureStarRatingView() {
        viewHolder.starRatingView.delegate = self
    }
}

extension StarRatingReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension StarRatingReviewViewController: StarRatingViewDelegate {
    func didTapRatingButton(score: Int) {
        listener?.didTapRatingButton(score: score)
    }
}
