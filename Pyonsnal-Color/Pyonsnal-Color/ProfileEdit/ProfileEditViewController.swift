//
//  ProfileEditViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import UIKit
import Combine
import ModernRIBs

protocol ProfileEditPresentableListener: AnyObject {
    func didTapEditButton()
    func didTapBackButton()
}

final class ProfileEditViewController: UIViewController, ProfileEditPresentable, ProfileEditViewControllable {

    weak var listener: ProfileEditPresentableListener?
    private var viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureUI()
        bindActions()
    }
    
    func loadInfo(with memberInfo: MemberInfoEntity?) {
        // viewHolder.profileImageView.image =
        setNickNamePlaceHolder(nickName: memberInfo?.nickname)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func bindActions() {
        viewHolder.backNavigationView.delegate = self
        viewHolder.imageContainerView
            .gesturePublisher()
            .sink { [weak self] _ in
                // TODO: alert 띄우기
                let alertController = UIAlertController()
                
            }.store(in: &cancellable)
        
        viewHolder.nickNameTextField
            .textPublisher
            .sink { [weak self] text in
                print("text \(text)")
            }.store(in: &cancellable)
        
        viewHolder.editButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink {
                // TODO: 전송
            }.store(in: &cancellable)
            
    }
    
    private func setNickNamePlaceHolder(nickName: String?) {
        guard let nickName else { return }
        let placeHolderText = NSMutableAttributedString()
        placeHolderText.appendAttributes(string: nickName, font: .body2r, color: .gray400)
        viewHolder.nickNameTextField.attributedPlaceholder = placeHolderText
    }
}

extension ProfileEditViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

extension ProfileEditViewController {
    enum Constant {
        static let navigationTitle = "프로필 수정"
        static let editButtonTitle = "프로필 수정 완료"
    }
    
    final class ViewHolder: ViewHolderable {
        
        let backNavigationView: BackNavigationView = {
            let navigationView = BackNavigationView()
            navigationView.payload = .init(
                mode: .text,
                title: Constant.navigationTitle,
                iconImageKind: nil
            )
            navigationView.favoriteButton.isHidden = true
            navigationView.setText(with: Constant.navigationTitle)
            return navigationView
        }()
        
        let imageContainerView: UIView = {
            let view = UIView()
            return view
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.setImage(.tagStore)
            return imageView
        }()
        
        let profileAddImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(systemName: "plus.circle.fill")
            return imageView
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing8
            return stackView
        }()
        
        private let nickNameStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            return stackView
        }()
        
        private let nicknameLabel: UILabel = {
            let label = UILabel()
            label.text = "닉네임"
            label.textColor = .gray700
            label.font = .body2m
            return label
        }()
        
        private let nicknameCountLabel: UILabel = {
            let label = UILabel()
            label.text = "0/10"
            label.textColor = .gray600
            label.font = .body3r
            return label
        }()
        
        let nickNameTextField: UITextField = {
            let textField = UITextField()
            textField.backgroundColor = .gray100
            textField.addLeftPaddingView(point: 12)
            textField.makeRounded(with: 16)
            textField.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            return textField
        }()
        
        let editButton: PrimaryButton = {
            let button = PrimaryButton(state: .disabled)
            button.setText(with: Constant.editButtonTitle)
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(backNavigationView)
            view.addSubview(imageContainerView)
            imageContainerView.addSubview(profileImageView)
            imageContainerView.addSubview(profileAddImageView)
            
            view.addSubview(stackView)
            stackView.addArrangedSubview(nickNameStackView)
            nickNameStackView.addArrangedSubview(nicknameLabel)
            nickNameStackView.addArrangedSubview(nicknameCountLabel)
            nicknameCountLabel.snp.contentHuggingHorizontalPriority = 1000
            
            stackView.addArrangedSubview(nickNameTextField)
            view.addSubview(editButton)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            imageContainerView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom).offset(40)
                $0.centerX.equalToSuperview()
            }
            
            profileImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.size.equalTo(100)
            }
            
            profileAddImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(5)
                $0.bottom.equalToSuperview().offset(3)
                $0.size.equalTo(32)
            }
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(imageContainerView.snp.bottom).offset(52)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
            }
            
            nickNameTextField.snp.makeConstraints {
                $0.height.equalTo(44)
            }
            
            editButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(52)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.bottom.equalToSuperview().inset(.spacing16).priority(.low)
            }
        }
    }
}
