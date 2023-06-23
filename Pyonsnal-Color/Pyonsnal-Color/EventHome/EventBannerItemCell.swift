//
//  EventBannerItemCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/11.
//

import UIKit
import SnapKit

protocol EventBannerItemCellDelegate: AnyObject {
    func didTapBannerItemCell()
}

final class EventBannerItemCell: UICollectionViewCell {
    
    weak var delegate: EventBannerItemCellDelegate?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Method
    private func configureAction() {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBannerItemCell)
        )
        viewHolder.eventImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTapBannerItemCell() {
        // TO DO : 클릭시 리블렛 연결
        delegate?.didTapBannerItemCell()
    }
}

extension EventBannerItemCell {
    class ViewHolder: ViewHolderable {
        let eventImageView: UIImageView = {
            let imageView = UIImageView()
            // to do : fix color, image
            imageView.image = UIImage(systemName: "star.fill")
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        func place(in view: UIView) {
            view.addSubview(eventImageView)
        }
        
        func configureConstraints(for view: UIView) {
            eventImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
