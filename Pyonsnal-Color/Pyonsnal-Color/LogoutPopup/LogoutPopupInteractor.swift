//
//  LogoutPopupInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs
import Combine

protocol LogoutPopupRouting: ViewableRouting {
    
}

protocol LogoutPopupPresentable: Presentable {
    var listener: LogoutPopupPresentableListener? { get set }
}

protocol LogoutPopupListener: AnyObject {
    func popupDidTabDismissButton()
    func routeToLoggedOut()
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
    
    private let component: LogoutPopupComponent
    private var cancellable = Set<AnyCancellable>()
    
    init(presenter: LogoutPopupPresentable, component: LogoutPopupComponent) {
        self.component = component
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
        } else { // 회원 탈퇴
            deleteAccount()
        }
    }
    
    private func logout() {
        component.memberAPIService.logout()
            .sink { [weak self] response in
                if response.value != nil {
                    // 처음 화면으로 이동
                    self?.listener?.routeToLoggedOut()
                    // at, rt 삭제
                }else if response.error != nil {
                    // Error handling
                }
            }.store(in: &cancellable)
    }
    
    private func deleteAccount() {
        component.memberAPIService.widthraw()
            .sink { [weak self] response in
                if response.value != nil {
                    // 처음 화면으로 이동
                    self?.listener?.routeToLoggedOut()
                    // at, rt 삭제
                }else if response.error != nil {
                    // Error handling
                }
            }.store(in: &cancellable)
    }
    
    func didTabConfirmButton(_ text: String?) {
        if let text, text == Text.dismiss {
            listener?.popupDidTabDismissButton()
        } else { // 로그아웃
            logout()
        }
    }
    
}
