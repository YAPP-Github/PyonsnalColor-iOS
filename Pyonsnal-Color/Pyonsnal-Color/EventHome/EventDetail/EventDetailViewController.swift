//
//  EventDetailViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/01.
//

import UIKit
import ModernRIBs
import Kingfisher

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
    
    // MARK: - EventDetailPresentable
    func update(with imageUrl: String) {
        if let imageUrl = URL(string: imageUrl) {
            viewHolder.eventImageView.setImage(with: imageUrl)
        }
    }
    
    // MARK: - Private Method
    private func configureAction() {
        viewHolder.imageNavigationView.delegate = self
    }

}

// MARK: - ImageNavigationViewDelegate
extension EventDetailViewController: ImageNavigationViewDelegate {
    @objc func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension EventDetailViewController {
    // MARK: - UI Component
    final class ViewHolder: ViewHolderable {
        let imageNavigationView: ImageNavigationView = {
            let view = ImageNavigationView(payload: .init(iconImageKind: .iconGS))
            return view
        }()
        
        private let containerScrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }()
        
        let eventImageView: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()
        
        func place(in view: UIView) {
            view.addSubview(imageNavigationView)
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(eventImageView)
        }
        
        func configureConstraints(for view: UIView) {
            imageNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            containerScrollView.snp.makeConstraints {
                $0.top.equalTo(imageNavigationView.snp.bottom)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(view.snp.height)
            }
            
            eventImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalToSuperview()
                updateImageViewHeight()
            }
        }
        
        func updateImageViewHeight() {
            eventImageView.snp.makeConstraints {
                if let image = eventImageView.image {
                    $0.height.equalTo(image.size.height)
                }
            }
        }
          
    }
}
