//
//  LogoutPopupBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs

protocol LogoutPopupDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class LogoutPopupComponent: Component<LogoutPopupDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol LogoutPopupBuildable: Buildable {
    func build(withListener listener: LogoutPopupListener) -> LogoutPopupRouting
    func build(withListener listener: LogoutPopupListener, isLogout: Bool) -> LogoutPopupRouting
}

final class LogoutPopupBuilder: Builder<LogoutPopupDependency>, LogoutPopupBuildable {

    override init(dependency: LogoutPopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LogoutPopupListener) -> LogoutPopupRouting {
        let component = LogoutPopupComponent(dependency: dependency)
        let viewController = LogoutPopupViewController()
        let interactor = LogoutPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return LogoutPopupRouter(interactor: interactor, viewController: viewController)
    }
    
    func build(withListener listener: LogoutPopupListener, isLogout: Bool) -> LogoutPopupRouting {
        let component = LogoutPopupComponent(dependency: dependency)
        let viewController = LogoutPopupViewController(isLogout: isLogout)
        let interactor = LogoutPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return LogoutPopupRouter(interactor: interactor, viewController: viewController)
    }
}
