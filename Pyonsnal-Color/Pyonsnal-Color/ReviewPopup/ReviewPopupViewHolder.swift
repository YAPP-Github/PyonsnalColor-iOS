//
//  ReviewPopupViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import SnapKit

extension ReviewPopupViewController {
    final class ViewHolder: ViewHolderable {
        enum Constant {
            enum Size {
                static let topBottomMargin: CGFloat = .spacing40
                static let leftRightMargin: CGFloat = .spacing20
                static let titleStackViewSpacing: CGFloat = .spacing8
                static let buttonStackViewSpacing: CGFloat = .spacing16
                static let popupWidth: CGFloat = 358
                static let popupHeight: CGFloat = 228
                static let buttonWidth: CGFloat = 151
                static let buttonHeight: CGFloat = 52
            }
        }
        
        private let containerView: UIView = .init(frame: .zero)
        
        private let mainPopupView: UIView = {
            let view = UIView()
            view.makeRounded(with: .spacing16)
            view.backgroundColor = .white
            return view
        }()
        
        private let textStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = Constant.Size.titleStackViewSpacing
            stackView.alignment = .center
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            label.textColor = .black
            return label
        }()
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = .body2r
            label.textColor = .gray500
            return label
        }()
        
        private let buttonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = Constant.Size.buttonStackViewSpacing
            stackView.alignment = .center
            return stackView
        }()
        
        let dismissButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.black.cgColor)
            button.makeRounded(with: .spacing16)
            return button
        }()
        
        let confirmButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.black.cgColor)
            button.makeRounded(with: .spacing16)
            button.backgroundColor = .black
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(containerView)
            
            containerView.addSubview(mainPopupView)
            
            mainPopupView.addSubview(textStackView)
            mainPopupView.addSubview(buttonStackView)
            
            textStackView.addArrangedSubview(titleLabel)
            textStackView.addArrangedSubview(descriptionLabel)
            
            buttonStackView.addArrangedSubview(dismissButton)
            buttonStackView.addArrangedSubview(confirmButton)
        }
        
        func configureConstraints(for view: UIView) {
            containerView.snp.makeConstraints {
                $0.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            mainPopupView.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(Constant.Size.popupHeight)
            }
            
            textStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(Constant.Size.topBottomMargin)
                $0.centerX.equalToSuperview()
            }
            
            buttonStackView.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(Constant.Size.topBottomMargin)
                $0.centerX.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints {
                $0.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            dismissButton.snp.makeConstraints {
                $0.width.equalTo(Constant.Size.buttonWidth)
                $0.height.equalTo(Constant.Size.buttonHeight)
            }
            
            confirmButton.snp.makeConstraints {
                $0.width.equalTo(Constant.Size.buttonWidth)
                $0.height.equalTo(Constant.Size.buttonHeight)
            }
        }
    }
}
