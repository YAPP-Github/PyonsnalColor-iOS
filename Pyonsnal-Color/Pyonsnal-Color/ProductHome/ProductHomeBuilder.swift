//
//  ProductHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol ProductHomeDependency: Dependency {
}

final class ProductHomeComponent: Component<ProductHomeDependency>, NotificationListDependency {
}

// MARK: - Builder

protocol ProductHomeBuildable: Buildable {
    func build(withListener listener: ProductHomeListener) -> ProductHomeRouting
}

final class ProductHomeBuilder: Builder<ProductHomeDependency>, ProductHomeBuildable {

    override init(dependency: ProductHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ProductHomeListener) -> ProductHomeRouting {
        let component = ProductHomeComponent(dependency: dependency)
        let viewController = ProductHomeViewController()
        let interactor = ProductHomeInteractor(presenter: viewController)
        
        let notificationList: NotificationListBuilder = .init(dependency: component)
        
        interactor.listener = listener
        return ProductHomeRouter(
            interactor: interactor,
            viewController: viewController,
            notificationList: notificationList
        )
    }
}
