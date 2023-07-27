//
//  SortFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/25.
//

import UIKit
import SnapKit

final class SortFilterCell: UICollectionViewCell {
    
    enum Sort: String, CaseIterable {
        case recent = "최신순"
        case lowestPrice = "낮은 가격 순"
        case highestPrice = "높은 가격 순"
    }
    
    private let viewHolder = ViewHolder()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideCheckMakr() {
        viewHolder.checkButton.isHidden = isSelected ? false : true
    }
    
    func configureCell(at index: Int) {
        let title = Sort.allCases[index].rawValue
        
        viewHolder.titleLabel.text = title
    }
}

extension SortFilterCell {
    final class ViewHolder: ViewHolderable {
        
        enum Image {
            static let checkMark = "checkmark"
        }
        
        private let containerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body2m
            label.textColor = .black
            return label
        }()
        
        let checkButton: UIButton = {
            let button = UIButton()
            button.setImage(.init(systemName: Image.checkMark), for: .normal)
            button.tintColor = .red500
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerStackView)
            
            containerStackView.addArrangedSubview(titleLabel)
            containerStackView.addArrangedSubview(checkButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerStackView.snp.makeConstraints {
                $0.edges.equalTo(view)
            }
        }
    }
}
