//
//  MyPickInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/09/11.
//

import ModernRIBs

protocol MyPickRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MyPickPresentable: Presentable {
    var listener: MyPickPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MyPickListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MyPickInteractor: PresentableInteractor<MyPickPresentable>, MyPickInteractable, MyPickPresentableListener {

    weak var router: MyPickRouting?
    weak var listener: MyPickListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MyPickPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
