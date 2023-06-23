//
//  ItemHeaderTitleView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/06/10.
//

import UIKit
import SnapKit

final class ItemHeaderTitleView: UICollectionReusableView {
    
    // MARK: - Private property
    private let viewHolder: ViewHolder = .init()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: .zero)
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(isEventLayout: Bool,
                title: String) {
        if isEventLayout {
            viewHolder.sortLabel.isHidden = true
        }
        viewHolder.titleLabel.text = title
    }
}

extension ItemHeaderTitleView {
    class ViewHolder: ViewHolderable {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            // to do color
            label.font = .body2m
            return label
        }()
        
        let sortLabel: UILabel = {
            let label = UILabel()
            // to do fix text, color
            label.font = .body3m
            label.text = "최신순"
            return label
        }()
        
        
        func place(in view: UIView) {
            view.addSubview(titleLabel)
            view.addSubview(sortLabel)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.top.bottom.equalToSuperview()
            }
            
            sortLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.top.bottom.equalToSuperview()
                $0.leading.greaterThanOrEqualTo(100)
            }
        }
    }
}
