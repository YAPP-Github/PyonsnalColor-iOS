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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        view.backgroundColor = .white
        configureNavigationView()
    }
    
    private func configureNavigationView() {
        viewHolder.backNavigationView.delegate = self
    }
}

extension DetailReviewViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
