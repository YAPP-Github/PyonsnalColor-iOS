//
//  ProductListHeaderView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/06/22.
//

import UIKit
import SnapKit

final class ProductListHeaderView: UICollectionReusableView, Reusable {
    
    private let sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최신순"
        label.font = UIFont.body3m
        label.textColor = .systemGray
        return label
    }()
    
    func configureLayout() {
        addSubview(sortLabel)
        
        sortLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
    }
}
