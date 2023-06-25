//
//  ProfileHomeViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol ProfileHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileHomeViewController: UIViewController, ProfileHomePresentable, ProfileHomeViewControllable {

    weak var listener: ProfileHomePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let customFont: UIFont = .label2
        
        tabBarItem.setTitleTextAttributes([.font: customFont], for: .normal)
        tabBarItem = UITabBarItem(
            title: "MY",
            image: UIImage(named: "profile"),
            selectedImage: UIImage(named: "profile.selected")
        )
        
        view.backgroundColor = .systemGray6
    }
}
