//
//  StarRatingReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs
import UIKit

protocol StarRatingReviewPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class StarRatingReviewViewController: UIViewController, StarRatingReviewPresentable, StarRatingReviewViewControllable {

    weak var listener: StarRatingReviewPresentableListener?
    private let viewHolder = ViewHolder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        view.backgroundColor = .white
    }
}
