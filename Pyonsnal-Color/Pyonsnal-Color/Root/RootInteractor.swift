//
//  RootInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/29.
//

import ModernRIBs

protocol RootRouting: ViewableRouting {
    func routeToLoggedIn()
    func routeToLoggedOut()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {
}

final class RootInteractor:
    PresentableInteractor<RootPresentable>,
    RootInteractable,
    RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?
    
    private let dependency: RootDependency

    init(presenter: RootPresentable, dependency: RootDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        checkLoginedIn()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func routeToLoggedIn() {
        router?.routeToLoggedIn()
    }
    
    func checkLoginedIn() {
        if let accessToken = dependency.userAuthService.getAccessToken() {
            print("Access Token: \(accessToken)")
            router?.routeToLoggedIn()
        } else {
            router?.routeToLoggedOut()
        }
    }
}
