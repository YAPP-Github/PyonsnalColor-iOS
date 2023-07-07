//
//  TermsOfUseRouter.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/06.
//

import ModernRIBs

protocol TermsOfUseInteractable: Interactable,
                                 CommonWebViewListener {
    var router: TermsOfUseRouting? { get set }
    var listener: TermsOfUseListener? { get set }
}

protocol TermsOfUseViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TermsOfUseRouter: ViewableRouter<TermsOfUseInteractable,
                              TermsOfUseViewControllable>,
                              TermsOfUseRouting {
    
    private let commonWebViewBuilder: CommonWebViewBuildable
    private var commonWebViewRouting: ViewableRouting?
    
    init(
        interactor: TermsOfUseInteractable,
        viewController: TermsOfUseViewControllable,
        commonWebViewBuilder: CommonWebViewBuildable
    ) {
        self.commonWebViewBuilder = commonWebViewBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachCommonWebView(with terms: SubTerms) {
        if commonWebViewRouting != nil { return }
        let commonWebViewBuilder = commonWebViewBuilder.build(withListener: interactor, subTerms: terms)
        self.commonWebViewRouting = commonWebViewBuilder
        attachChild(commonWebViewBuilder)
        viewController.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(commonWebViewBuilder.viewControllable.uiviewController, animated: true)
    }

    func detachCommonWebView() {
        guard let commonWebViewRouting else { return }
        self.commonWebViewRouting = nil
        detachChild(commonWebViewRouting)
        viewController.uiviewController.dismiss(animated: true)
    }
}
