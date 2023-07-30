//
//  ProductFilterInteractor.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import ModernRIBs

protocol ProductFilterRouting: ViewableRouting {
}

protocol ProductFilterPresentable: Presentable {
    var listener: ProductFilterPresentableListener? { get set }
}

protocol ProductFilterListener: AnyObject {
    func applyFilterItems(_ items: [FilterItemEntity])
    func applySortFilter(type: FilterItemEntity)
    func productFilterDidTapCloseButton()
}

final class ProductFilterInteractor: PresentableInteractor<ProductFilterPresentable>, ProductFilterInteractable, ProductFilterPresentableListener {

    weak var router: ProductFilterRouting?
    weak var listener: ProductFilterListener?

    override init(presenter: ProductFilterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didTapApplyButton(with selectedItems: [FilterItemEntity]) {
        listener?.applyFilterItems(selectedItems)
    }
    
    func didSelectSortFilter(type: FilterItemEntity) {
        listener?.applySortFilter(type: type)
    }
    
    func didTapCloseButton() {
        listener?.productFilterDidTapCloseButton()
    }
}
