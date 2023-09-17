//
//  ProductDetailReviewCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

import SnapKit

extension ProductDetailReviewCell {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Size {
            static let writeButtonRadius: CGFloat = 8
        }
        
        // MARK: - UI Component
        let contentView: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let contentStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.axis = .vertical
            stackView.spacing = 16
            return stackView
        }()
        
        let reviewMetaView: ReviewMetaView = {
            let reviewMetaView = ReviewMetaView()
            return reviewMetaView
        }()
        
        let reviewImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }()
        
        let reviewTagListView: UIView = {
            let view = UIView(frame: .zero)
            view.backgroundColor = .gray100
            return view
        }()
        
        let reviewLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .body2r
            label.textColor = .gray700
            return label
        }()
        
        let buttonBackgroundView: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let goodButton: UIButton = {
            let button = UIButton(frame: .zero)
            button.backgroundColor = .gray100
            return button
        }()
        
        let badButton: UIButton = {
            let button = UIButton(frame: .zero)
            button.backgroundColor = .gray100
            return button
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(contentStackView)
            
            contentStackView.addSubview(reviewImageView)
            contentStackView.addSubview(reviewTagListView)
            contentStackView.addSubview(reviewLabel)
            contentStackView.addSubview(buttonBackgroundView)
            
            buttonBackgroundView.addSubview(goodButton)
            buttonBackgroundView.addSubview(badButton)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            contentStackView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(.spacing20)
                make.leading.trailing.equalToSuperview().inset(.spacing20)
            }
            
            goodButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.top.bottom.equalToSuperview()
            }
            
            badButton.snp.makeConstraints { make in
                make.height.equalTo(30)
                make.top.bottom.equalToSuperview()
                make.leading.equalTo(goodButton.snp.trailing).offset(.spacing8)
                make.trailing.equalToSuperview()
            }
        }
    }
}
