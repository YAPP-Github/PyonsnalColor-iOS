//
//  CategoryFilterCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/22.
//

import UIKit
import SnapKit

final class CategoryFilterCell: UICollectionViewCell {
    
    private lazy var filterButton: FilterButton = {
        let button = FilterButton()
        return button
    }()
    
    private lazy var sortButton: SortButton = {
        let button = SortButton()
        return button
    }()
    
    private var currentButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(filter: FilterEntity?) {
        guard let filter else { return }
        self.setButton(with: filter.filterType)
        currentButton.setText(with: filter.filterType.filterDefaultText)
    }
    
    func setButton(with type: FilterType) {
        self.currentButton = type == .sort ? sortButton : filterButton
        self.place(in: contentView, button: currentButton)
        self.configureConstraints(for: contentView, button: currentButton)
    }
    
    func place(in view: UIView, button: UIButton) {
        view.addSubview(button)
    }
    
    func configureConstraints(for view: UIView, button: UIButton) {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    } 
}
