//
//  RootViewController.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/29.
//

import ModernRIBs
import UIKit

protocol RootPresentableListener: AnyObject {
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    // MARK: - Interface
    weak var listener: RootPresentableListener?

    func replaceModel(viewController: ViewControllable) {
        targetViewController = viewController

        guard !animationInProgress else {
            return
        }

        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: true) { [weak self] in
                if self?.targetViewController != nil {
                    self?.presentTargetViewController()
                } else {
                    self?.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController()
        }
    }

    // MARK: - UI Component
    private let label: UILabel = {
        let label: UILabel = .init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Main"
        return label
    }()

    // MARK: - Private Property
    private var targetViewController: ViewControllable?
    private var animationInProgress: Bool = false

    // MARK: - Initializer
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureUI()
    }

    // MARK: - Private Method
    private func presentTargetViewController() {
        if let targetViewController {
            animationInProgress = true
            OperationQueue.main.addOperation {
                self.present(targetViewController.uiviewController, animated: true) { [weak self] in
                    self?.animationInProgress = false
                }
            }
        }
    }

    private func configureUI() {
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - Internal Method
    func present(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismiss(viewController: ModernRIBs.ViewControllable) {
        if presentedViewController == viewController.uiviewController {
            dismiss(animated: true)
        }
    }
}

//MARK: - LoggedInViewControllable
extension RootViewController: LoggedInViewControllable {
    
}
