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
    var store: ConvenienceStore
    init(imageUrl: String,
         store: ConvenienceStore,
         dependency: EventDetailDependency) {
        self.imageUrl = imageUrl
        self.store = store
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EventDetailBuildable: Buildable {
    func build(withListener listener: EventDetailListener,
               imageUrl: String,
               store: ConvenienceStore) -> EventDetailRouting
}

final class EventDetailBuilder: Builder<EventDetailDependency>, EventDetailBuildable {

    override init(dependency: EventDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: EventDetailListener,
               imageUrl: String, store: ConvenienceStore) -> EventDetailRouting {
        let component = EventDetailComponent(imageUrl: imageUrl, store: store, dependency: dependency)
        let viewController = EventDetailViewController()
        let interactor = EventDetailInteractor(presenter: viewController,
                                               imageUrl: imageUrl,
                                               store: store)
        interactor.listener = listener
        return EventDetailRouter(interactor: interactor, viewController: viewController)
    }
}
