//
//  TermsOfUseViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 2023/07/02.
//

import ModernRIBs
import UIKit
import SnapKit

protocol TermsOfUsePresentableListener: AnyObject {
    func dismissViewController()
    func routeToLoggedIn()
}

final class TermsOfUseViewController: UIViewController,
                                      TermsOfUsePresentable,
                                      TermsOfUseViewControllable {
    struct SubTerms {
        let title: String
        var hasNextPage: Bool = false
    }
    
    enum Constants {
        enum Text {
            static let title = "서비스 이용에 동의해주세요."
        }
        enum Size {
            static let popupViewHeight: CGFloat = 450
        }
    }
    
    
    weak var listener: TermsOfUsePresentableListener?
    
    private let viewHolder: ViewHolder = .init()
    
    static let subTerms: [SubTerms] = [
        SubTerms(title: "(필수) 만 14세 이상입니다."),
        SubTerms(title: "(필수) 서비스 이용약관 동의", hasNextPage: true),
        SubTerms(title: "(필수) 개인정보 처리방침 동의", hasNextPage: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureAction()
    }
    
    func configureAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        viewHolder.backGroundView.addGestureRecognizer(tapGestureRecognizer)
        viewHolder.closeButton.addTarget(self,
                                            action: #selector(didTapCloseButton),
                                            for: .touchUpInside)
        viewHolder.allAgreeButton.addTarget(self,
                                            action: #selector(didTapAllAgreeButton),
                                            for: .touchUpInside)
        viewHolder.joinButton.addTarget(self,
                                        action: #selector(didTapJoinButton),
                                        for: .touchUpInside)
    }
    
    @objc
    private func didTapBackgroundView() {
        listener?.dismissViewController()
    }
    
    @objc
    private func didTapCloseButton() {
        listener?.dismissViewController()
    }
    
    @objc
    private func didTapAllAgreeButton() {
        let toggledSelected = !viewHolder.allAgreeButton.isCurrentSelected()
        viewHolder.allAgreeButton.setButtonState(isSelected: toggledSelected)
        viewHolder.subButtonVerticalStackView.arrangedSubviews.forEach { stackView in
            stackView.subviews.forEach { termsButton in
                if let termsButton = termsButton as? TermsButton {
                    termsButton.isSelected = toggledSelected
                }
            }
        }
        // 가입 완료 버튼 활성화
        let buttonEnabled: PrimaryButton.ButtonSelectable = toggledSelected == true ? .enabled : .disabled
        viewHolder.joinButton.setState(with: buttonEnabled)
    }
    
    @objc func didTapJoinButton() {
        listener?.routeToLoggedIn()
    }
    
}

extension TermsOfUseViewController {
    final class ViewHolder: ViewHolderable {
        let backGroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.layer.opacity = 0.5
            return view
        }()
        
        private let popUpView: UIView = {
            let view = UIView()
            view.makeRoundCorners(cornerRadius: 16,
                                  maskedCorners: [.layerMinXMinYCorner,
                                                  .layerMaxXMinYCorner])
            view.backgroundColor = .white
            return view
        }()
        
        // MARK: popUpHeaderView
        private let popUpHeaderView: UIView = {
            let view = UIView()
            return view
        }()
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = Constants.Text.title
            label.textColor = .black
            label.font = .title1
            return label
        }()
        
        let closeButton: UIButton = {
            let button = UIButton()
            button.setImage(.iconClose, for: .normal)
            button.tintColor = .gray700
            return button
        }()

        let allAgreeButton: TermsButton = {
            let button = TermsButton(text: "모두 동의",
                                     textColor: .black,
                                     font: .title2,
                                     isSelected: false)
            return button
        }()
        
        let subButtonVerticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing12
            stackView.backgroundColor = .green300
            return stackView
        }()
        
        private let dividerView: UIView = {
            let view = UIView()
            view.backgroundColor = .gray200
            return view
        }()
        
        let joinButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: "가입완료")
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backGroundView)
            view.addSubview(popUpView)
            
            popUpView.addSubview(popUpHeaderView)
            popUpView.addSubview(titleLabel)
            popUpView.addSubview(closeButton)
            
            popUpView.addSubview(allAgreeButton)
            popUpView.addSubview(dividerView)
            
            popUpView.addSubview(subButtonVerticalStackView)
            popUpView.addSubview(joinButton)
            for subTerm in subTerms {
                let buttonHorizontalStackView: UIStackView = {
                    let stackView = UIStackView()
                    stackView.axis = .horizontal
                    stackView.distribution = .fillProportionally
                    stackView.spacing = .spacing16
                    stackView.backgroundColor = .brown
                    return stackView
                }()
                
                let subTermsButton: TermsButton = {
                    let button = TermsButton(text: nil,
                                             textColor: .gray700,
                                             font: .title3,
                                             isSelected: false)
                    return button
                }()
                subButtonVerticalStackView.addArrangedSubview(buttonHorizontalStackView)
                subTermsButton.setText(with: subTerm.title)
                buttonHorizontalStackView.addArrangedSubview(subTermsButton)
                
                if subTerm.hasNextPage {
                    
                    let subTermsRouteButton: UIButton = {
                        let button = UIButton()
                        button.setImage(.iconArrow, for: .normal)
                        return button
                    }()
                    buttonHorizontalStackView.addArrangedSubview(subTermsRouteButton)
                }
            }
            
        }
        
        func configureConstraints(for view: UIView) {
            backGroundView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            popUpView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(Constants.Size.popupViewHeight)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
            popUpHeaderView.snp.makeConstraints {
                popUpHeaderView.backgroundColor = .gray100
                $0.leading.trailing.top.equalToSuperview()
                $0.height.equalTo(68)
            }
            
            titleLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.top.equalToSuperview().offset(.spacing40)
                $0.trailing.greaterThanOrEqualTo(20)
            }
            
            closeButton.snp.makeConstraints {
                $0.top.equalToSuperview().offset(.spacing12)
                $0.trailing.equalToSuperview().inset(.spacing12)
                $0.size.equalTo(24)
            }
            
            allAgreeButton.snp.makeConstraints {
                $0.top.equalTo(popUpHeaderView.snp.bottom).offset(46)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(40)
            }
            
            dividerView.snp.makeConstraints {
                $0.top.equalTo(allAgreeButton.snp.bottom).offset(.spacing12)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(1)
            }
            
            subButtonVerticalStackView.snp.makeConstraints {
                $0.top.equalTo(dividerView.snp.bottom).offset(.spacing12)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
            }
            
            subButtonVerticalStackView.arrangedSubviews.forEach { buttonHorizontalStackView in
                buttonHorizontalStackView.snp.makeConstraints {
                    $0.height.equalTo(40)
                }
            }
            
            joinButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(52)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
        }
        
    }
}
