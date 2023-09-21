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
    func didFinishStarRating()
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
    }
    
    private func configureStarRatingView() {
        viewHolder.starRatingView
            .tapPublisher
            .sink { [weak self] in
                //viewHolder
            }.store(in: &cancellable)
    }
    
    private func didFinishStarRating() {
        listener?.didFinishStarRating()
    }
}
