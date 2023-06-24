//
//  TabCell.swift
//  CollectionView-Structure-Test
//
//  Created by 조소정 on 2023/06/13.
//

import UIKit

final class TabCell: UICollectionViewCell {
        
    enum Size {
        static let dividerHeight: CGFloat = 2
    }
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with tab: Tab) {
        viewHolder.titleLabel.text = tab.name
        viewHolder.titleLabel.textColor = .gray
        viewHolder.dividerView.backgroundColor = .systemGray6
        
        updateSelectedColor(isSelected: tab.isSelected)
    }
    
    func updateSelectedColor(isSelected: Bool) {
        viewHolder.titleLabel.textColor = isSelected ? .black : .gray
        viewHolder.dividerView.backgroundColor = isSelected ? .black : .systemGray6
    }
    
}

extension TabCell {
    class ViewHolder: ViewHolderable {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .body3m
            //to do : color
            return label
        }()
        
        let dividerView: UIView = {
            let view = UIView()
            //to do : color
            return view
        }()
        
        func place(in view: UIView) {
            view.addSubview(titleLabel)
            view.addSubview(dividerView)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
            
            dividerView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(Size.dividerHeight)
            }
        }
    }
}
