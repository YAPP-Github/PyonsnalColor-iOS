//
//  CommonWebViewRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebViewInteractable: Interactable {
    var router: CommonWebViewRouting? { get set }
    var listener: CommonWebViewListener? { get set }
}

protocol CommonWebViewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CommonWebViewRouter: ViewableRouter<CommonWebViewInteractable, CommonWebViewViewControllable>, CommonWebViewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CommonWebViewInteractable, viewController: CommonWebViewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
