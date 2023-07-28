//
//  EventFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/28.
//

import UIKit
import SnapKit

final class EventFilterCell: UICollectionViewCell {
    
    enum Image {
        static let checkMark = "checkmark"
    }
    
    enum Size {
        static let checkButtonBorderWidth: CGFloat = 1.6
    }
    
    private let viewHolder = ViewHolder()
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelectedState() : setUnselectedState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, isSelected: Bool) {
        viewHolder.titleLabel.text = title
        isSelected ? setSelectedState() : setUnselectedState()
    }
    
    private func setSelectedState() {
        let configuration: UIImage.SymbolConfiguration = .init(weight: .bold)
        let checkImage = UIImage(systemName: Image.checkMark, withConfiguration: configuration)
        checkImage?.withTintColor(.white)
        
        viewHolder.titleLabel.textColor = .red500
        viewHolder.checkImageView.backgroundColor = .red500
        viewHolder.checkImageView.image = checkImage
        viewHolder.checkImageView.removeBorder()
    }
    
    private func setUnselectedState() {
        viewHolder.titleLabel.textColor = .black
        viewHolder.checkImageView.backgroundColor = .white
        viewHolder.checkImageView.image = nil
        viewHolder.checkImageView.makeBorder(
            width: Size.checkButtonBorderWidth,
            color: UIColor.gray300.cgColor
        )
    }
}

extension EventFilterCell {
    final class ViewHolder: ViewHolderable {
        
        enum Size {
            static let spacing: CGFloat = 10
            static let checkImageBorderWidth: CGFloat = 1.6
            static let checkImageRadius: CGFloat = 10
            static let checkImageSize: CGFloat = 20
            static let checkImageInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        }
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.spacing = Size.spacing
            return stackView
        }()
        
        let checkImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.makeBorder(width: Size.checkImageBorderWidth, color: UIColor.gray300.cgColor)
            imageView.makeRounded(with: Size.checkImageRadius)
            imageView.layoutMargins = Size.checkImageInset
            imageView.backgroundColor = .white
            imageView.tintColor = .white
            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            label.textColor = .black
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(checkImageView)
            containerStackView.addArrangedSubview(titleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.leading.equalTo(view)
                $0.centerY.equalTo(view)
            }
            
            checkImageView.snp.makeConstraints {
                $0.width.height.equalTo(Size.checkImageSize)
            }
        }
    }
}
