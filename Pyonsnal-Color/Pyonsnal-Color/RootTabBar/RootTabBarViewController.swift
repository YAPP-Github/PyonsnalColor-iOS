//
//  RootTabBarViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs
import UIKit

protocol RootTabBarPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootTabBarViewController: UIViewController, RootTabBarPresentable, RootTabBarViewControllable {

    weak var listener: RootTabBarPresentableListener?
}

