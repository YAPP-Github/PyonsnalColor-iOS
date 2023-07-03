//
//  NotificationListBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/27.
//

import ModernRIBs

protocol NotificationListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class NotificationListComponent: Component<NotificationListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol NotificationListBuildable: Buildable {
    func build(withListener listener: NotificationListListener) -> NotificationListRouting
}

final class NotificationListBuilder: Builder<NotificationListDependency>, NotificationListBuildable {

    override init(dependency: NotificationListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: NotificationListListener) -> NotificationListRouting {
        let component = NotificationListComponent(dependency: dependency)
        let viewController = NotificationListViewController()
        let interactor = NotificationListInteractor(presenter: viewController)
        interactor.listener = listener
        return NotificationListRouter(interactor: interactor, viewController: viewController)
    }
}
