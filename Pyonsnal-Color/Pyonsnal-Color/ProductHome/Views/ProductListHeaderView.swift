//
//  ProductListHeaderView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListHeaderView: UICollectionReusableView {
    
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.text = "최신순"
        label.font = .body3m
        label.textColor = .gray500
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(sortLabel)
        
        sortLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
}
