//
//  ProductSearchViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/07/19.
//

import ModernRIBs
import UIKit

protocol ProductSearchPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func popViewController()
}

final class ProductSearchViewController: UIViewController, ProductSearchPresentable, ProductSearchViewControllable {

    weak var listener: ProductSearchPresentableListener?
    
    // MARK: - Private Method
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        
        configureUI()
        configureAction()
    }
    
    // MARK: - Private Method
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func configureAction() {
        viewHolder.backButton.addTarget(
            self,
            action: #selector(backButtonAction(_:)),
            for: .touchUpInside
        )
        viewHolder.searchBarView.delegate = self
    }
    
    @objc private func backButtonAction(_ sender: UIButton) {
        listener?.popViewController()
    }
}



extension ProductSearchViewController: SearchBarViewDelegate {
    func updateText(_ text: String?) {
        print(text)
    }
}
