//
//  TermsOfUseRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/06.
//

import ModernRIBs

protocol TermsOfUseInteractable: Interactable {
    var router: TermsOfUseRouting? { get set }
    var listener: TermsOfUseListener? { get set }
}

protocol TermsOfUseViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TermsOfUseRouter: ViewableRouter<TermsOfUseInteractable, TermsOfUseViewControllable>, TermsOfUseRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TermsOfUseInteractable, viewController: TermsOfUseViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
