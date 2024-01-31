//
//  PopupView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 1/31/24.
//

import UIKit
import Combine
import SnapKit

final class PopupView: UIView {
    
    // MARK: Property
    private let viewHolder: ViewHolder = .init()
    private var cancellable: Set<AnyCancellable> = .init()
    
    // MARK: Interface
    weak var delegate: PopupViewDelegate?
    
    // MARK: Initializer
    init() {
        super.init(frame: .zero)
        
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Method
    func configurePopup(
        title: String,
        description: String,
        dismissText: String,
        confirmText: String
    ) {
        viewHolder.titleLabel.text = title
        viewHolder.descriptionLabel.text = description
        viewHolder.dismissButton.setCustomFont(text: dismissText, color: .black, font: .body2m)
        viewHolder.confirmButton.setCustomFont(text: confirmText, color: .red500, font: .body2m)
    }
    
    // MARK: Private Method
    private func configureButtons() {
        viewHolder.dismissButton
            .tapPublisher
            .sink { [weak self] in
                self?.delegate?.didTapDismissButton()
            }.store(in: &cancellable)
        
        viewHolder.confirmButton
            .tapPublisher
            .sink { [weak self] in
                self?.delegate?.didTapConfirmButton()
            }.store(in: &cancellable)
    }
}

extension PopupView {
    
    enum Constant {
            static let topBottomMargin: CGFloat = .spacing40
            static let leftRightMargin: CGFloat = .spacing20
            static let titleStackViewSpacing: CGFloat = .spacing8
            static let buttonStackViewSpacing: CGFloat = .spacing16
            static let buttonWidth: CGFloat = 151
            static let buttonHeight: CGFloat = 52
    }
    
    final class ViewHolder: ViewHolderable {
        private let mainPopupView: UIView = {
            let view = UIView()
            view.makeRounded(with: .spacing16)
            view.backgroundColor = .white
            return view
        }()
        
        private let textStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = Constant.titleStackViewSpacing
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
            stackView.spacing = Constant.buttonStackViewSpacing
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
            view.addSubview(mainPopupView)
            
            mainPopupView.addSubview(textStackView)
            mainPopupView.addSubview(buttonStackView)
            
            textStackView.addArrangedSubview(titleLabel)
            textStackView.addArrangedSubview(descriptionLabel)
            
            buttonStackView.addArrangedSubview(dismissButton)
            buttonStackView.addArrangedSubview(confirmButton)
        }
        
        func configureConstraints(for view: UIView) {
            mainPopupView.snp.makeConstraints {
                $0.edges.equalTo(view)
            }
            
            textStackView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(Constant.topBottomMargin)
                $0.centerX.equalToSuperview()
            }
            
            buttonStackView.snp.makeConstraints {
                $0.bottom.equalToSuperview().inset(Constant.topBottomMargin)
                $0.centerX.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints {
                $0.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            descriptionLabel.snp.makeConstraints {
                $0.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            dismissButton.snp.makeConstraints {
                $0.width.equalTo(Constant.buttonWidth)
                $0.height.equalTo(Constant.buttonHeight)
            }
            
            confirmButton.snp.makeConstraints {
                $0.width.equalTo(Constant.buttonWidth)
                $0.height.equalTo(Constant.buttonHeight)
            }
        }
    }
}
