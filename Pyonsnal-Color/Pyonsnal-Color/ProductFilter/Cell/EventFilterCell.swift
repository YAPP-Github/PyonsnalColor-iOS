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
    
    func hideCheckMark() {
        viewHolder.checkButton.isHidden = isSelected ? false : true
    }
    
    func configureCell(title: String, isSelected: Bool) {
        viewHolder.titleLabel.text = title
        isSelected ? setSelectedState() : setUnselectedState()
    }
    
    private func setSelectedState() {
        let configuration: UIImage.SymbolConfiguration = .init(weight: .bold)
        let checkImage = UIImage(systemName: Image.checkMark, withConfiguration: configuration)
        
        viewHolder.titleLabel.textColor = .red500
        viewHolder.checkButton.backgroundColor = .red500
        viewHolder.checkButton.setImage(checkImage, for: .normal)
        viewHolder.checkButton.imageView?.sizeToFit()
        viewHolder.checkButton.removeBorder()
    }
    
    private func setUnselectedState() {
        viewHolder.titleLabel.textColor = .black
        viewHolder.checkButton.backgroundColor = .white
        viewHolder.checkButton.imageView?.image = nil
        viewHolder.checkButton.makeBorder(
            width: Size.checkButtonBorderWidth,
            color: UIColor.gray300.cgColor
        )
    }
}

extension EventFilterCell {
    final class ViewHolder: ViewHolderable {
        
        enum Size {
            static let spacing: CGFloat = 10
            static let checkButtonBorderWidth: CGFloat = 1.6
            static let checkButtonRadius: CGFloat = 10
            static let checkButtonSize: CGFloat = 20
            static let checkButtonInset: UIEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        }
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.spacing = Size.spacing
            return stackView
        }()
        
        let checkButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: Size.checkButtonBorderWidth, color: UIColor.gray300.cgColor)
            button.makeRounded(with: Size.checkButtonRadius)
            button.imageEdgeInsets = Size.checkButtonInset
            button.imageView?.contentMode = .center
            button.imageView?.clipsToBounds = false
            button.backgroundColor = .white
            button.tintColor = .white
            return button
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            label.textColor = .black
            return label
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(checkButton)
            containerStackView.addArrangedSubview(titleLabel)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.leading.equalTo(view)
                $0.centerY.equalTo(view)
            }
            
            checkButton.snp.makeConstraints {
                $0.width.height.equalTo(Size.checkButtonSize)
            }
        }
    }
}
