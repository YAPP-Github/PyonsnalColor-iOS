//
//  ProfileEditViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import ModernRIBs
import UIKit

protocol ProfileEditPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileEditViewController: UIViewController, ProfileEditPresentable, ProfileEditViewControllable {

    weak var listener: ProfileEditPresentableListener?
}
