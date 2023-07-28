//
//  CategoryFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit
import SnapKit

final class CategoryFilterCell: UICollectionViewCell {
    
    private let viewHolder: ViewHolder = .init()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: contentView)
        viewHolder.configureConstraints(for: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with filterText: String?, filterItem: [String]) {
        viewHolder.button.setText(with: filterText)
    }
    
    class ViewHolder: ViewHolderable {

        let button: FilterButton = {
            let button = FilterButton()
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(button)
            
        }
        
        func configureConstraints(for view: UIView) {
            button.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
