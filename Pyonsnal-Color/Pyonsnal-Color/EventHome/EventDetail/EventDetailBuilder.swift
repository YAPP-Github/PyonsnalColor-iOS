//
//  EventDetailBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs

protocol EventDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EventDetailComponent: Component<EventDetailDependency> {
    var imageUrl: String
    init(imageUrl: String, dependency: EventDetailDependency) {
        self.imageUrl = imageUrl
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(withListener listener: EventDetailListener, imageUrl: String) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {

    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventDetailListener,
               imageUrl: String) -> EventDetailRouting {
        let component = EventDetailComponent(imageUrl: imageUrl, dependency: dependency)
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(presenter: viewController, imageUrl: imageUrl)
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
}
