//
//  ReviewPopupBuilder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import ModernRIBs

protocol ReviewPopupDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ReviewPopupComponent: Component<ReviewPopupDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ReviewPopupBuildable: Buildable {
    func build(withListener listener: ReviewPopupListener) -> ReviewPopupRouting
}

final class ReviewPopupBuilder: Builder<ReviewPopupDependency>, ReviewPopupBuildable {

    override init(dependency: ReviewPopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ReviewPopupListener) -> ReviewPopupRouting {
        let component = ReviewPopupComponent(dependency: dependency)
        let viewController = ReviewPopupViewController()
        let interactor = ReviewPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return ReviewPopupRouter(interactor: interactor, viewController: viewController)
    }
}
