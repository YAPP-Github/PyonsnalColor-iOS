//
//  EventHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol EventHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class EventHomeViewController: UIViewController, EventHomePresentable, EventHomeViewControllable {

    weak var listener: EventHomePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "basket"),
            selectedImage: UIImage(systemName: "basket.fill")
        )
        
        view.backgroundColor = .systemGray6
    }
}
