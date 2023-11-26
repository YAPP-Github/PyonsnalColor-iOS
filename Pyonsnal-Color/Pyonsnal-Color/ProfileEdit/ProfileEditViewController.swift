//
//  ProfileEditViewController.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 11/16/23.
//

import UIKit
import Combine
import ModernRIBs
import PhotosUI

protocol ProfileEditPresentableListener: AnyObject {
    var isEditButtonEnabled: AnyPublisher<Bool, Never> { get }
    func didTapEditButton(with nickname: String, profileImage: UIImage?)
    func didTapBackButton()
    func editNickname(nickname: String?)
    func editProfileImage(image: UIImage?)
}

enum EditActionSheetSection: String {
    case camera = "카메라로 촬영하기"
    case gallery = "갤러리에서 선택하기"
    case delete = "프로필 사진 삭제"
    case cancel = "취소"
}

final class ProfileEditViewController: UIViewController, ProfileEditPresentable, ProfileEditViewControllable {

    weak var listener: ProfileEditPresentableListener?
    private var viewHolder: ViewHolder = .init()
    private var cancellable = Set<AnyCancellable>()
    private var maximumNicknameCount: Int = 15
    let imageUploadSize: CGSize = .init(width: 1080, height: 1080)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureUI()
        bindActions()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadInfo(with memberInfo: MemberInfoEntity?) {
        if let profileImage = memberInfo?.profileImage,
            let url = URL(string: profileImage) {
            viewHolder.profileImageView.setImage(with: url)
        }
        setNicknamePlaceHolder(nickname: memberInfo?.nickname)
    }
    
    func updateNicknameStatus(status: NetworkErrorType) {
        viewHolder.nicknameValidateLabel.text = status.rawValue
        viewHolder.nicknameValidateLabel.textColor = status.textColor
    }
    
    private func clearNicknameValidateLabel() {
        viewHolder.nicknameValidateLabel.text = ""
    }
    
    private func configureUI() {
        view.backgroundColor = .white
    }
    
    private func bindActions() {
        viewHolder.backNavigationView.delegate = self
        viewHolder.nicknameTextField.delegate = self
        viewHolder.imageContainerView
            .gesturePublisher()
            .sink { [weak self] _ in
                self?.showActionSheet()
            }.store(in: &cancellable)
        
        viewHolder.nicknameTextField
            .textPublisher
            .throttle(for: 0.2, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] text in
                guard let self, let text else { return }
                let isTextEmpty = text.isEmpty
                if isTextEmpty { clearNicknameValidateLabel() }
                self.listener?.editNickname(nickname: text)
                self.updateTextFieldBorderColor(isFilled: !isTextEmpty)
                self.updateNicknameCountLabel()
            }.store(in: &cancellable)
        
        viewHolder.editButton
            .tapPublisher
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: false)
            .sink { [weak self] in
                guard let self else { return }
                let nickname = getCurrentNickname()
                let profileImage = self.viewHolder.profileImageView.image
                self.listener?.didTapEditButton(with: nickname, profileImage: profileImage)
            }.store(in: &cancellable)
        
        listener?.isEditButtonEnabled
            .sink { [weak self] isValid in
                let validState = PrimaryButton.ButtonSelectable(rawValue: isValid) ?? .disabled
                self?.viewHolder.editButton.setState(with: validState)
            }.store(in: &cancellable)
            
    }
    
    private func setNicknamePlaceHolder(nickname: String?) {
        guard let nickname else { return }
        let placeHolderText = NSMutableAttributedString()
        placeHolderText.appendAttributes(string: nickname, font: .body2r, color: .gray400)
        viewHolder.nicknameTextField.attributedPlaceholder = placeHolderText
    }
    
    private func updateTextFieldBorderColor(isFilled: Bool) {
        let highlightColor: UIColor = isFilled ? .gray700 : .gray200
        viewHolder.nicknameTextField.makeBorder(width: 1, color: highlightColor.cgColor)
    }
    
    private func updateNicknameCountLabel() {
        let count = viewHolder.nicknameTextField.text?.count ?? 0
        viewHolder.nicknameCountLabel.text = "\(count)/\(Constant.maximumNicknameCount)"
    }
    
    private func getCurrentNickname() -> String {
        guard let nickname = viewHolder.nicknameTextField.text,
                !nickname.isEmpty else {
            return viewHolder.nicknameTextField.attributedPlaceholder?.string ?? ""
        }
        return nickname
    }
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: EditActionSheetSection.camera.rawValue, style: .default) { [weak self] _ in
            self?.showImagePicker()
        }
        let galleryAction = UIAlertAction(title: EditActionSheetSection.gallery.rawValue, style: .default) { [weak self] _ in
            self?.showPHPicker()
        }
        let deleteAction = UIAlertAction(title: EditActionSheetSection.delete.rawValue, style: .destructive) { [weak self] _ in
            self?.deleteProfileImage()
        }
        let cancelAction = UIAlertAction(title: EditActionSheetSection.cancel.rawValue, style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func showImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func deleteProfileImage() {
        viewHolder.profileImageView.setImage(.tagStore)
    }
}

// MARK: - BackNavigationViewDelegate
extension ProfileEditViewController: BackNavigationViewDelegate {
    func didTapBackButton() {
        listener?.didTapBackButton()
    }
}

// MARK: - UITextFieldDelegate
extension ProfileEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if string.isBackSpace() { return true }
        if text.count >= Constant.maximumNicknameCount {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let resizedImage = editedImage.resize(targetSize: imageUploadSize)
            viewHolder.profileImageView.image = resizedImage
            listener?.editProfileImage(image: resizedImage)
        }
        
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ProfileEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.map(\.itemProvider).first else {
            return
        }
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self,
                      let image = image as? UIImage,
                      error == nil else { return }
                let resizedImage = image.resize(targetSize: imageUploadSize)
                DispatchQueue.main.async {
                    self.viewHolder.profileImageView.image = resizedImage
                    self.listener?.editProfileImage(image: resizedImage)
                }
            }
        }
    }
}

extension ProfileEditViewController {
    enum Constant {
        static let maximumNicknameCount: Int = 15
        static let navigationTitle = "프로필 수정"
        static let editButtonTitle = "프로필 수정 완료"
        
        enum Size {
            static let leftPaddingMargin: Int = 12
            static let nicknameTextFieldCornerRadius: CGFloat = 16
            static let profileImageViewSize: CGFloat = 100
            static let imageContainerViewTop: CGFloat = 40
            static let imageContainerViewBottom: CGFloat = 52
            static let profileAddImageViewSize: CGFloat = 32
            static let nicknameTextFieldHeight: CGFloat = 44
            static let editButtonHeight: CGFloat = 52
        }
    }
    
    // MARK: - ViewHolder
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
            imageView.contentMode = .scaleAspectFill
            imageView.makeRounded(with: Constant.Size.profileImageViewSize / 2)
            imageView.makeBorder(width: 1, color: UIColor.gray300.cgColor)
            imageView.setImage(.tagStore)
            return imageView
        }()
        
        let profileAddImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray400
            imageView.setImage(.profilePlus)
            return imageView
        }()
        
        private let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = .spacing8
            return stackView
        }()
        
        private let nicknameStackView: UIStackView = {
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
        
        let nicknameCountLabel: UILabel = {
            let label = UILabel()
            label.text = "0/\(Constant.maximumNicknameCount)"
            label.textColor = .gray600
            label.font = .body3r
            return label
        }()
        
        let nicknameTextField: UITextField = {
            let textField = UITextField()
            textField.backgroundColor = .gray100
            textField.addLeftPaddingView(point: Constant.Size.leftPaddingMargin)
            textField.makeRounded(with: Constant.Size.nicknameTextFieldCornerRadius)
            textField.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            return textField
        }()
        
        let nicknameValidateLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .right
            label.font = .body3r
            return label
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
            stackView.addArrangedSubview(nicknameStackView)
            nicknameStackView.addArrangedSubview(nicknameLabel)
            nicknameStackView.addArrangedSubview(nicknameCountLabel)
            nicknameCountLabel.snp.contentHuggingHorizontalPriority = 1000
            
            stackView.addArrangedSubview(nicknameTextField)
            stackView.addArrangedSubview(nicknameValidateLabel)
            view.addSubview(editButton)
        }
        
        func configureConstraints(for view: UIView) {
            backNavigationView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.leading.trailing.equalTo(view)
            }
            
            imageContainerView.snp.makeConstraints {
                $0.top.equalTo(backNavigationView.snp.bottom).offset(Constant.Size.imageContainerViewTop)
                $0.centerX.equalToSuperview()
            }
            
            profileImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.size.equalTo(Constant.Size.profileImageViewSize)
            }
            
            profileAddImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(5)
                $0.bottom.equalToSuperview().offset(3)
                $0.size.equalTo(Constant.Size.profileAddImageViewSize)
            }
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(imageContainerView.snp.bottom).offset(Constant.Size.imageContainerViewBottom)
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
            }
            
            nicknameTextField.snp.makeConstraints {
                $0.height.equalTo(Constant.Size.nicknameTextFieldHeight)
            }
            
            editButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(.spacing16)
                $0.trailing.equalToSuperview().inset(.spacing16)
                $0.height.equalTo(Constant.Size.editButtonHeight)
                $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.bottom.equalToSuperview().inset(.spacing16).priority(.low)
            }
        }
    }
}
