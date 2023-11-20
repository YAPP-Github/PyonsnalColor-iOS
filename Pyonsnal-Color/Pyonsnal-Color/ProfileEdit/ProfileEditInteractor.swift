//
//  ProfileEditInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import ModernRIBs

protocol ProfileEditRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileEditPresentable: Presentable {
    var listener: ProfileEditPresentableListener? { get set }
    func loadInfo(with memberInfo: MemberInfoEntity?)
}

protocol ProfileEditListener: AnyObject {
    func detachProfileEditView()
}

final class ProfileEditInteractor: PresentableInteractor<ProfileEditPresentable>, ProfileEditInteractable, ProfileEditPresentableListener {

    weak var router: ProfileEditRouting?
    weak var listener: ProfileEditListener?
    var component: ProfileEditComponent?
    
    init(presenter: ProfileEditPresentable, component: ProfileEditComponent) {
        self.component = component
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.loadInfo(with: component?.memberInfo)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapEditButton() {
        
    }
    
    func didTapBackButton() {
        listener?.detachProfileEditView()
    }
}
