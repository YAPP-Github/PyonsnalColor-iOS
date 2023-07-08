//
//  LoggedOutViewController+ViewHolder.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/06/10.
//

import UIKit
import SnapKit

extension LoggedOutViewController {
    final class ViewHolder: ViewHolderable {
        // MARK: - Declaration
        enum Constant {
            enum Size {
                static let logoImageViewHeight: CGFloat = 46
                static let logoImageViewTopOffset: CGFloat = 80
                static let loginButtonSize: CGFloat = 72
                static let loginStackViewBottomInset: CGFloat = 60
                static let loginStackViewSpacing: CGFloat = 30
            }
        }
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()

        private let logoImageView: UIImageView = {
            let imageView: UIImageView = .init(frame: .zero)
            imageView.setImage(.iconPyonsnalColor)
            return imageView
        }()

        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = .body1m
            label.textColor = .gray500
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = "나에게 딱 맞는 편의점 상품 정보"
            return label
        }()

        private let loginButtonStackView: UIStackView = {
            let stackView: UIStackView = .init(frame: .zero)
            stackView.axis = .horizontal
            stackView.spacing = Constant.Size.loginStackViewSpacing
            return stackView
        }()

        let kakaoLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.loginKakao, for: .normal)
            button.layer.cornerRadius = Constant.Size.loginButtonSize / 2
            return button
        }()

        let appleLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.loginApple, for: .normal)
            button.layer.cornerRadius = Constant.Size.loginButtonSize / 2
            return button
        }()

        // MAKR: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)

            contentView.addSubview(logoImageView)
            contentView.addSubview(descriptionLabel)
            contentView.addSubview(loginButtonStackView)

            loginButtonStackView.addArrangedSubview(kakaoLoginButton)
            loginButtonStackView.addArrangedSubview(appleLoginButton)
        }

        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }

            logoImageView.snp.makeConstraints { make in
                make.height.equalTo(Constant.Size.logoImageViewHeight)
                make.top.equalToSuperview().offset(Constant.Size.logoImageViewTopOffset)
                make.centerX.equalToSuperview()
            }

            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(logoImageView.snp.bottom).offset(.spacing24)
                make.centerX.equalToSuperview()
            }

            loginButtonStackView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(Constant.Size.loginStackViewBottomInset)
                make.centerX.equalToSuperview()
            }

            kakaoLoginButton.snp.makeConstraints { make in
                make.size.equalTo(Constant.Size.loginButtonSize)
            }

            appleLoginButton.snp.makeConstraints { make in
                make.size.equalTo(Constant.Size.loginButtonSize)
            }
        }
    }
}
