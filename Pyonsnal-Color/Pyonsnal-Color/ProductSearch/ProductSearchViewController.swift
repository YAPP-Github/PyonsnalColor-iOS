//
//  ProductSearchViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs
import UIKit

protocol ProductSearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProductSearchViewController: UIViewController, ProductSearchPresentable, ProductSearchViewControllable {

    weak var listener: ProductSearchPresentableListener?
}
