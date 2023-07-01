//
//  EventBannerItemCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/11.
//

import UIKit
import SnapKit

protocol EventBannerItemCellDelegate: AnyObject {
    func didTapEventBannerCell()
}

final class EventBannerItemCell: UICollectionViewCell {
    
    weak var delegate: EventBannerItemCellDelegate?
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    let testImage = ["star", "heart", "star.fill", "heart.fill", "trash"]
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(index: Int) {
        viewHolder.eventImageView.image = UIImage(systemName: testImage[index])
    }
}

extension EventBannerItemCell {
    class ViewHolder: ViewHolderable {
        let eventImageView: UIImageView = {
            let imageView = UIImageView()
            // to do : fix color, image
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
