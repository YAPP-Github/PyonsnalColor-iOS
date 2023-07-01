//
//  EventDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import ModernRIBs
import UIKit

protocol EventDetailPresentableListener: AnyObject {
    func didTapBackButton()
}

final class EventDetailViewController: UIViewController,
                                       EventDetailPresentable,
                                       EventDetailViewControllable {

    weak var listener: EventDetailPresentableListener?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureAction()
    }
    
    private func configureAction() {
        viewHolder.backButton.addTarget(self,
                                        action: #selector(didTapBackButton),
                                        for: .touchUpInside)
    }
    
    @objc
    private func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension EventDetailViewController {
    final class ViewHolder: ViewHolderable {
        private let headerView: UIView = {
            let view = UIView()
            view.backgroundColor = .cyan
            return view
        }()
        
        let backButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .blue
            return button
        }()
        
        private let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }()
        
        private let eventImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "testEventDetailImage")
            return imageView
        }()
        
        func place(in view: UIView) {
            view.addSubview(headerView)
            headerView.addSubview(backButton)
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(eventImageView)
        }
        
        func configureConstraints(for view: UIView) {
            headerView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(50)
            }
            
            backButton.snp.makeConstraints {
                $0.size.equalTo(24)
                $0.leading.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
            }
            
            containerScrollView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(view.snp.height)
            }
            
            eventImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
                if let image = eventImageView.image {
                    $0.height.equalTo(image.size.height)
                }
            }
        }
          
    }
}
