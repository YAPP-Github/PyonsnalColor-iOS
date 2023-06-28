//
//  NotificationListViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import ModernRIBs
import UIKit

protocol NotificationListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class NotificationListViewController:
    UIViewController,
        NotificationListPresentable,
        NotificationListViewControllable {

    weak var listener: NotificationListPresentableListener?
}
