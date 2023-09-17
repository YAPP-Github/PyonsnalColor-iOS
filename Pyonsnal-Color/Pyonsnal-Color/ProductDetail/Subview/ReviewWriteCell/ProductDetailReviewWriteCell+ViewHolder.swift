//
//  ProductDetailReviewWriteCell+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/09/10.
//

import UIKit

import SnapKit

extension ProductDetailReviewWriteCell {
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
        
        let reviewCountLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .title2
            label.textColor = .gray700
            return label
        }()
        
        let sortButton: UIView = {
            let view = UIView(frame: .zero)
            return view
        }()
        
        let ratingBackgroundView: UIView = {
            let view = UIView(frame: .zero)
            view.makeRounded(with: 16)
            view.makeBorder(width: 1, color: UIColor.gray400)
            return view
        }()
        
        let ratingScoreStackView: UIStackView = {
            let stackView = UIStackView(frame: .zero)
            stackView.spacing = 8
            return stackView
        }()
        
        let ratingScoreLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .headLine
            label.textColor = .black
            return label
        }
        
        let ratingSeparatorLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .headLine
            label.textColor = .black
            label.text = "/"
            return label
        }
        
        let ratingMaxScoreLabel: UILabel = {
            let label = UILabel(frame: .zero)
            label.font = .headLine
            label.textColor = .black
            label.text = "5.0"
            return label
        }
        
        let ratingStarView: UIView = {
            let view = UIView(frame: .zero)
            view.backgroundColor = .gray100
            return view
        }()
        
        let reviewWriteButton: UIButton = {
            let button = UIButton(frame: .zero)
            button.makeRounded(with: Size.writeButtonRadius)
            button.backgroundColor = .black
            button.titleLabel?.textColor = .white
            return button
        }()
        
        // MARK: - Interface
        func place(in view: UIView) {
            view.addSubview(contentView)
            
            contentView.addSubview(reviewCountLabel)
            contentView.addSubview(sortButton)
            contentView.addSubview(ratingBackgroundView)
            contentView.addSubview(reviewWriteButton)
            
            ratingBackgroundView.addSubview(ratingScoreStackView)
            ratingBackgroundView.addSubview(ratingStarView)
            
            ratingScoreStackView.addArrangedSubview(ratingScoreLabel)
            ratingScoreStackView.addArrangedSubview(ratingSeparatorLabel)
            ratingScoreStackView.addArrangedSubview(ratingMaxScoreLabel)
        }
        
        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            reviewCountLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(.spacing40)
                make.leading.equalToSuperview().inset(.spacing16)
            }
            
            sortButton.snp.makeConstraints {
                make.top.equalToSuperview().offset(.spacing40)
                make.leading.greaterThanOrEqualTo(reviewCountLabel.snp.trailing).offset(.spacing16)
                make.trailing.equalToSuperview().inset(.spacing16)
            }
            
            ratingBackgroundView.snp.makeConstraints { make in
                make.top.equalTo(sortButton.snp.bottom).offset(.spacing24)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
            }
            
            ratingScoreStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(.spacing24)
                make.centerX.equalToSuperview()
            }
            
            ratingStarView.snp.makeConstraints { make in
                make.top.equalTo(ratingScoreStackView.snp.bottom).offset(.spacing8)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(.spacing24)
            }
            
            reviewWriteButton.snp.makeConstraints { make in
                make.top.equalTo(ratingBackgroundView.snp.bottom).offset(.spacing16)
                make.leading.trailing.equalToSuperview().inset(.spacing16)
                make.bottom.equalToSuperview().inset(.spacing40)
            }
        }
    }
}
