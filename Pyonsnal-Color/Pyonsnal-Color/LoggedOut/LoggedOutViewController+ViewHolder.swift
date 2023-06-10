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
        // MARK: - UI Component
        private let contentView: UIView = {
            let view: UIView = .init(frame: .zero)
            return view
        }()

        private let logoImageView: UIImageView = {
            let imageView: UIImageView = .init(frame: .zero)
            imageView.setImage(.logo)
            return imageView
        }()

        private let descriptionLabel: UILabel = {
            let label = UILabel()
//            label.font =
//            label.textColor =
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = "나에게 딱 맞는 편의점 상품 정보,\n편스널 컬러에서"
            return label
        }()

        private let infomationView: UIView = {
            let view: UIView = .init(frame: .zero)
            view.backgroundColor = .gray
            view.layer.cornerRadius = 20
            return view
        }()

        private let loginButtonStackView: UIStackView = {
            let stackView: UIStackView = .init(frame: .zero)
            stackView.axis = .horizontal
            stackView.spacing = 30
            return stackView
        }()

        let kakaoLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.loginKakao, for: .normal)
            button.layer.cornerRadius = 31
            return button
        }()

        let appleLoginButton: UIButton = {
            let button: UIButton = .init(frame: .zero)
            button.setImage(.loginApple, for: .normal)
            button.layer.cornerRadius = 31
            return button
        }()

        // MAKR: - Method
        func place(in view: UIView) {
            view.addSubview(contentView)

            contentView.addSubview(logoImageView)
            contentView.addSubview(descriptionLabel)
            contentView.addSubview(infomationView)
            contentView.addSubview(loginButtonStackView)

            loginButtonStackView.addArrangedSubview(kakaoLoginButton)
            loginButtonStackView.addArrangedSubview(appleLoginButton)
        }

        func configureConstraints(for view: UIView) {
            contentView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }

            logoImageView.snp.makeConstraints { make in
                make.width.equalTo(193)
                make.height.equalTo(94)
                make.top.equalToSuperview().offset(30)
                make.centerX.equalToSuperview()
            }

            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(logoImageView.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
            }

            infomationView.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
                make.width.equalTo(300)
                make.height.equalTo(340)
                make.centerX.equalToSuperview()
            }

            loginButtonStackView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(60)
                make.centerX.equalToSuperview()
            }

            kakaoLoginButton.snp.makeConstraints { make in
                make.width.height.equalTo(62)
            }

            appleLoginButton.snp.makeConstraints { make in
                make.width.height.equalTo(62)
            }
        }
        
        
    }
}
