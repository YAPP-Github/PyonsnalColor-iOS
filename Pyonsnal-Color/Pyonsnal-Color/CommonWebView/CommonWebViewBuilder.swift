//
//  CommonWebViewBuilder.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/07.
//

import ModernRIBs

protocol CommonWebViewDependency: Dependency {
    
}

final class CommonWebViewComponent: Component<CommonWebViewDependency> {
    var subTerms: SubTerms
    
    init(dependency: CommonWebViewDependency,
         subTerms: SubTerms) {
        self.subTerms = subTerms
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CommonWebViewBuildable: Buildable {
    func build(withListener listener: CommonWebViewListener, subTerms: SubTerms) -> CommonWebViewRouting
}

final class CommonWebViewBuilder: Builder<CommonWebViewDependency>, CommonWebViewBuildable {

    override init(dependency: CommonWebViewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CommonWebViewListener,
               subTerms: SubTerms) -> CommonWebViewRouting {
        let component = CommonWebViewComponent(dependency: dependency,
                                               subTerms: subTerms)
        let viewController = CommonWebViewViewController()
        let interactor = CommonWebViewInteractor(presenter: viewController,
                                                 component: component)
        interactor.listener = listener
        return CommonWebViewRouter(interactor: interactor,
                                   viewController: viewController)
    }
}
