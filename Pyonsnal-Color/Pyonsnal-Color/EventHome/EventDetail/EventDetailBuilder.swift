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
    var imageURL: String
    var store: ConvenienceStore?
    var links: [String]?
    
    init(
        imageURL: String,
        store: ConvenienceStore? = nil,
        links: [String]? = nil,
        dependency: EventDetailDependency
    ) {
        self.imageURL = imageURL
        self.store = store
        self.links = links
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(
        withListener listener: EventDetailListener,
        imageURL: String,
        store: ConvenienceStore?,
        links: [String]?
    ) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {

    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: EventDetailListener,
        imageURL: String,
        store: ConvenienceStore? = nil,
        links: [String]? = nil
    ) -> EventDetailRouting {
        let component = EventDetailComponent(
            imageURL: imageURL,
            store: store,
            dependency: dependency
        )
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(
            presenter: viewController,
            component: component
        )
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
}
