//
//  RecommendFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/28.
//

import UIKit
import SnapKit

final class RecommendFilterCell: UICollectionViewCell {
    
    enum Image {
        static let checkMark = "checkmark"
    }
    
    enum Size {
        static let selectedBorderWidth: CGFloat = 2
        static let unselectedBorderWidth: CGFloat = 1
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
        viewHolder.iconImageView.makeBorder(
            width: Size.selectedBorderWidth,
            color: UIColor.red500.cgColor
        )
        viewHolder.titleLabel.textColor = .red500
    }
    
    private func setUnselectedState() {
        viewHolder.iconImageView.makeBorder(
            width: Size.unselectedBorderWidth,
            color: UIColor.gray200.cgColor
        )
        viewHolder.titleLabel.textColor = .black
    }
}

extension RecommendFilterCell {
    final class ViewHolder: ViewHolderable {
        
        enum Size {
            static let spacing: CGFloat = 8
            static let iconBorderWidth: CGFloat = 1
            static let iconSize: CGFloat = 80
        }
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = Size.spacing
            return stackView
        }()
        
        let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.makeBorder(width: Size.iconBorderWidth, color: UIColor.gray200.cgColor)
            imageView.makeRounded(with: Size.iconSize / 2)
            imageView.backgroundColor = .white
            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body3m
            label.textColor = .black
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(iconImageView)
            containerStackView.addArrangedSubview(titleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.leading.equalTo(view)
                $0.centerY.equalTo(view)
            }
            
            iconImageView.snp.makeConstraints {
                $0.width.height.equalTo(Size.iconSize)
            }
        }
    }
}
