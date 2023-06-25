//
//  ConvenienceStoreCell.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/21.
//

import UIKit

final class ConvenienceStoreCell: UICollectionViewCell {
    enum Constant {
        enum Size {
            static let margin: CGFloat = 11
            static let selectedViewHeight: CGFloat = 2
        }
        
        enum Color {
            static let selectedColor: UIColor = .black
            static let deselectedColor: UIColor = .init(
                red: 0.702,
                green: 0.702,
                blue: 0.714,
                alpha: 1
            )
        }
    }
    
    override var isSelected: Bool {
        didSet {
            toggleSelectedColor(isSelected: isSelected)
        }
    }
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.layoutMargins = UIEdgeInsets(
            top: Constant.Size.margin,
            left: Constant.Size.margin,
            bottom: Constant.Size.margin,
            right: Constant.Size.margin
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body3m
        label.textAlignment = .center
        label.textColor = Constant.Color.deselectedColor
        return label
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(containerStackView)
        contentView.addSubview(indicatorView)
        
        containerStackView.addArrangedSubview(storeTitleLabel)
        
        containerStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(containerStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constant.Size.selectedViewHeight)
        }
    }
    
    private func toggleSelectedColor(isSelected: Bool) {
        if isSelected {
            storeTitleLabel.textColor = Constant.Color.selectedColor
            indicatorView.backgroundColor = Constant.Color.selectedColor
        } else {
            storeTitleLabel.textColor = Constant.Color.deselectedColor
            indicatorView.backgroundColor = .clear
        }
    }
    
    func configureCell(title: String) {
        storeTitleLabel.text = title
    }
}
