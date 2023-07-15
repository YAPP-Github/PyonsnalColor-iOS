//
//  EventHomeBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/10.
//

import ModernRIBs

protocol EventHomeDependency: Dependency {
    var productAPIService: ProductAPIService { get }
}

final class EventHomeComponent: Component<EventHomeDependency>,
                                EventDetailDependency,
                                ProductDetailDependency {
}

// MARK: - Builder

protocol EventHomeBuildable: Buildable {
    func build(withListener listener: EventHomeListener) -> EventHomeRouting
}

final class EventHomeBuilder: Builder<EventHomeDependency>, EventHomeBuildable {

    override init(dependency: EventHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventHomeListener) -> EventHomeRouting {
        let component = EventHomeComponent(dependency: dependency)
        let viewController = EventHomeViewController()
        let eventDetailBuilder = EventDetailBuilder(dependency: component)
        let productDetail: ProductDetailBuilder = .init(dependency: component)
        let interactor = EventHomeInteractor(
            presenter: viewController,
            dependency: dependency
        )
        interactor.listener = listener
        return EventHomeRouter(interactor: interactor,
                               viewController: viewController,
                               eventDetailBuilder: eventDetailBuilder,
                               productDetail: productDetail)
    }
}
