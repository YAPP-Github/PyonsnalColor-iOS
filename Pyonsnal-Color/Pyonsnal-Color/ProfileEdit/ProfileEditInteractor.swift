//
//  ProfileEditInteractor.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import Combine
import ModernRIBs

protocol ProfileEditRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileEditPresentable: Presentable {
    var listener: ProfileEditPresentableListener? { get set }
    func loadInfo(with memberInfo: MemberInfoEntity?)
    func updateNicknameStatus(status: NetworkErrorType)
}

protocol ProfileEditListener: AnyObject {
    func detachProfileEditView()
}

final class ProfileEditInteractor: PresentableInteractor<ProfileEditPresentable>, ProfileEditInteractable, ProfileEditPresentableListener {

    weak var router: ProfileEditRouting?
    weak var listener: ProfileEditListener?
    private var cancellable = Set<AnyCancellable>()
    private var component: ProfileEditComponent?
    
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
//        component?.dependency.memberAPIService
    }
    
    func didTapBackButton() {
        listener?.detachProfileEditView()
    }
    
    func editNickname(nickname: String) {
        component?.dependency.memberAPIService
            .validate(nickname: nickname)
            .sink { [weak self] response in
                guard let self else { return }
                if let error = response.error {
                    if isInvalidNicknameStatus(errorType: error.type) {
                        self.presenter.updateNicknameStatus(status: error.type)
                    } else if error.type == .emptyResponse { // 빈 값일때 정상
                        self.presenter.updateNicknameStatus(status: .validNickname)
                    }
                } else {
                    self.presenter.updateNicknameStatus(status: .validNickname)
                }
            }.store(in: &cancellable)
    }
    
    private func isInvalidNicknameStatus(errorType: NetworkErrorType) -> Bool {
        return errorType == .invalidBlankNickname || errorType == .invalidParameter || errorType == .nicknameAlreadyExist
    }
}
