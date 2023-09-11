//
//  MyPickRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol MyPickInteractable: Interactable {
    var router: MyPickRouting? { get set }
    var listener: MyPickListener? { get set }
}

protocol MyPickViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MyPickRouter: ViewableRouter<MyPickInteractable, MyPickViewControllable>, MyPickRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MyPickInteractable, viewController: MyPickViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
