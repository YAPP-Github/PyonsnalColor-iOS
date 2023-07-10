//
//  LogoutPopupViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/07/07.
//

import ModernRIBs
import SnapKit
import UIKit

protocol LogoutPopupPresentableListener: AnyObject {
    func didTabDismissButton(_ text: String?)
    func didTabConfirmButton(_ text: String?)
}

final class LogoutPopupViewController:
    UIViewController,
    LogoutPopupPresentable,
    LogoutPopupViewControllable {
    
    enum Text {
        enum Logout {
            static let title: String = "로그아웃 하시겠어요?"
            static let description: String = "다음에 또 편스널컬러를 찾아주세요!"
            static let dismissButtonText: String = "취소하기"
            static let confirmButtonText: String = "로그아웃 하기"
        }
        
        enum DeleteAccount {
            static let title: String = "정말 탈퇴하시겠어요?"
            static let description: String = "탈퇴하시면 앱 내 모든 데이터가 사라지게 돼요."
            static let dismissButtonText: String = "회원탈퇴"
            static let confirmButtonText: String = "취소하기"
        }
    }

    weak var listener: LogoutPopupPresentableListener?
        
    private let viewHolder: ViewHolder = .init()
    
    convenience init(isLogout: Bool) {
        self.init()

        configureText(isLogout: isLogout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
        configureAction()
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func configureText(isLogout: Bool) {
        if isLogout {
            viewHolder.titleLabel.text = Text.Logout.title
            viewHolder.descriptionLabel.text = Text.Logout.description
            viewHolder.dismissButton.setCustomFont(
                text: Text.Logout.dismissButtonText,
                color: .black,
                font: .body2m
            )
            viewHolder.confirmButton.setCustomFont(
                text: Text.Logout.confirmButtonText,
                color: .red500,
                font: .body2m
            )
        } else {
            viewHolder.titleLabel.text = Text.DeleteAccount.title
            viewHolder.descriptionLabel.text = Text.DeleteAccount.description
            viewHolder.dismissButton.setCustomFont(
                text: Text.DeleteAccount.dismissButtonText,
                color: .black,
                font: .body2m
            )
            viewHolder.confirmButton.setCustomFont(
                text: Text.DeleteAccount.confirmButtonText,
                color: .red500,
                font: .body2m
            )
        }
    }
    
    private func configureAction() {
        viewHolder.dismissButton.addTarget(
            self,
            action: #selector(didTabDismissButton(_:)),
            for: .touchUpInside
        )
        viewHolder.confirmButton.addTarget(
            self,
            action: #selector(didTabConfirmButton(_:)),
            for: .touchUpInside
        )
    }
    
    @objc func didTabDismissButton(_ sender: UIButton) {
        listener?.didTabDismissButton(sender.titleLabel?.text)
    }
    
    @objc func didTabConfirmButton(_ sender: UIButton) {
        listener?.didTabConfirmButton(sender.titleLabel?.text)
    }
}

extension LogoutPopupViewController {
    final class ViewHolder: ViewHolderable {
        
        enum Constant {
            enum Size {
                static let topBottomMargin: CGFloat = 40
                static let leftRightMargin: CGFloat = 20
                static let titleStackViewSpacing: CGFloat = Spacing.spacing8.value
                static let buttonStackViewSpacing: CGFloat = Spacing.spacing16.value
                static let popupWidth: CGFloat = 358
                static let popupHeight: CGFloat = 228
                static let buttonWidth: CGFloat = 151
                static let buttonHeight: CGFloat = 52
            }
        }
        
        private let containerView: UIView = .init(frame: .zero)
        
        private let mainPopupView: UIView = {
            let view = UIView()
            view.makeRounded(with: Spacing.spacing16.value)
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
            label.textColor = .init(rgbHexString: "#808084")
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
            button.makeRounded(with: Spacing.spacing16.value)

            return button
        }()
        
        let confirmButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.black.cgColor)
            button.makeRounded(with: Spacing.spacing16.value)
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
            containerView.snp.makeConstraints { make in
                make.edges.equalTo(view.safeAreaLayoutGuide)
            }
            
            mainPopupView.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(.spacing16)
                make.trailing.equalToSuperview().inset(.spacing16)
                make.height.equalTo(Constant.Size.popupHeight)
            }
            
            textStackView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(Constant.Size.topBottomMargin)
                make.centerX.equalToSuperview()
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(Constant.Size.topBottomMargin)
                make.centerX.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { make in
                make.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            descriptionLabel.snp.makeConstraints { make in
                make.height.equalTo(titleLabel.font.customLineHeight)
            }
            
            dismissButton.snp.makeConstraints { make in
                make.width.equalTo(Constant.Size.buttonWidth)
                make.height.equalTo(Constant.Size.buttonHeight)
            }
            
            confirmButton.snp.makeConstraints { make in
                make.width.equalTo(Constant.Size.buttonWidth)
                make.height.equalTo(Constant.Size.buttonHeight)
            }
        }

    }
}
