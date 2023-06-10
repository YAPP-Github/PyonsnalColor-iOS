//
//  RootRouter.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/29.
//

import ModernRIBs

protocol RootInteractable: Interactable, LoggedOutListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModel(viewController: ViewControllable)
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    // MARK: - Private Property
    private let loggedOutBuilder: LoggedOutBuildable
    private var loggedOut: ViewableRouting?
    
    private let loggedInBuilder: LoggedInBuildable
    private var loggedIn: ViewableRouting?

    // MARK: - Initializer
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        loggedOutBuilder: LoggedOutBuildable,
        loggedInBuilder: LoggedInBuildable
    ) {
        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder
        super.init(interactor: interactor, viewController: viewController)

        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()

        routeToLoggedOut()
    }

    func routeToLoggedOut() {
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        self.loggedOut = loggedOut
        attachChild(loggedOut)
        viewController.replaceModel(viewController: loggedOut.viewControllable)
    }
    
    func routeToLoggedIn() {
        if let loggedOut {
            detachChild(loggedOut)
            viewController.dismiss(viewController: loggedOut.viewControllable)
            self.loggedOut = nil
        }
        
        let loggedOut = loggedOutBuilder.build(withListener: interactor)
        
        self.loggedOut = loggedOut
        attachChild(loggedOut)
    }
}
