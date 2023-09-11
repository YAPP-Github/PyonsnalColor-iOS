//
//  MyPickViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs
import UIKit

protocol MyPickPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MyPickViewController: UIViewController,
                                  MyPickPresentable,
                                  MyPickViewControllable {
    enum Text {
        static let tabBarItem = "찜"
    }
    
    weak var listener: MyPickPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureTabBarItem() {
        tabBarItem.setTitleTextAttributes([.font: UIFont.label2], for: .normal)
        tabBarItem = UITabBarItem(
            title: Text.tabBarItem,
            image: ImageAssetKind.TabBar.myPickUnSelected.image,
            selectedImage: ImageAssetKind.TabBar.myPickSelected.image
        )
    }

}
