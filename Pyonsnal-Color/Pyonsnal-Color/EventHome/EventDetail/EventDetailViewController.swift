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
    func update(with imageUrl: String, store storeType: ConvenienceStore) {
        if let imageUrl = URL(string: imageUrl) {
            viewHolder.eventImageView.setImage(with: imageUrl)
        }
        viewHolder.backNavigationView.payload = .init(mode: .image,
                                                      title: nil,
                                                      iconImageKind: storeType.storeIconImage)
    }
    
    // MARK: - Private Method
    private func configureAction() {
        viewHolder.backNavigationView.delegate = self
    }

}

// MARK: - ImageNavigationViewDelegate
extension EventDetailViewController: BackNavigationViewDelegate {
    @objc func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension EventDetailViewController {
    // MARK: - UI Component
    final class ViewHolder: ViewHolderable {
        let backNavigationView: BackNavigationView = {
            let backNavigationView = BackNavigationView()
            return backNavigationView
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
            view.addSubview(backNavigationView)
            view.addSubview(containerScrollView)
            containerScrollView.addSubview(eventImageView)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(48)
            }
            
            containerScrollView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom)
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
