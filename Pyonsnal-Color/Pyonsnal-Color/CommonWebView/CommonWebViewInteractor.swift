//
//  CommonWebViewInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebViewRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CommonWebViewPresentable: Presentable {
    var listener: CommonWebViewPresentableListener? { get set }
    func update(with subTermsInfo: SubTerms)
}

protocol CommonWebViewListener: AnyObject {
    func detachCommonWebView()
}

final class CommonWebViewInteractor: PresentableInteractor<CommonWebViewPresentable>, CommonWebViewInteractable, CommonWebViewPresentableListener {

    weak var router: CommonWebViewRouting?
    weak var listener: CommonWebViewListener?
    private let component: CommonWebViewComponent
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CommonWebViewPresentable,
        component: CommonWebViewComponent
    ) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.presenter.update(with: component.subTerms)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func detachCommonWebView() {
        listener?.detachCommonWebView()
    }
}
