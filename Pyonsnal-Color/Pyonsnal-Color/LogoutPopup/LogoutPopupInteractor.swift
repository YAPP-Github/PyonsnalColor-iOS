//
//  LogoutPopupInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs

protocol LogoutPopupRouting: ViewableRouting {
}

protocol LogoutPopupPresentable: Presentable {
    var listener: LogoutPopupPresentableListener? { get set }
}

protocol LogoutPopupListener: AnyObject {
    func popupDidTabDismissButton()
}

final class LogoutPopupInteractor:
    PresentableInteractor<LogoutPopupPresentable>,
    LogoutPopupInteractable,
    LogoutPopupPresentableListener {

    enum Text {
        static let dismiss: String = "취소하기"
    }

    weak var router: LogoutPopupRouting?
    weak var listener: LogoutPopupListener?

    override init(presenter: LogoutPopupPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTabDismissButton(_ text: String?) {
        if let text, text == Text.dismiss {
            listener?.popupDidTabDismissButton()
        } else {
            // TODO: 로그아웃 로직 구현
        }
    }
    
    func didTabConfirmButton(_ text: String?) {
        if let text, text == Text.dismiss { // 로그아웃
            listener?.popupDidTabDismissButton()
        } else { // 회원 탈퇴
            // TODO: 회원탈퇴 로직 구현
        }
    }
    
}
