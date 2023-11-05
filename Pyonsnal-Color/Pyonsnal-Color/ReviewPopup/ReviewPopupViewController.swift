//
//  ReviewPopupViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/21.
//

import UIKit
import Combine
import ModernRIBs

protocol ReviewPopupPresentableListener: AnyObject {
    func didTapDismissButton()
    func didTapApplyButton()
    func didTapBackButton()
}

final class ReviewPopupViewController: UIViewController, ReviewPopupPresentable, ReviewPopupViewControllable {
    enum Text {
        enum Cancel {
            static let title: String = "작성을 그만하시겠어요?"
            static let description: String = "작성 중인 내용은 저장되지 않습니다."
            static let dismiss: String = "그만하기"
            static let confirm: String = "계속하기"
        }

        enum Apply {
            static let title: String = "리뷰를 등록하시겠어요?"
            static let description: String = "등록 후 수정, 삭제가 되지 않습니다."
            static let dismiss: String = "돌아가기"
            static let confirm: String = "등록하기"
        }
    }
    
    weak var listener: ReviewPopupPresentableListener?
    
    private let viewHolder = ViewHolder()
    private var cancellable = Set<AnyCancellable>()
    
    convenience init(isApply: Bool) {
        self.init()
        
        configureText(isApply: isApply)
        configureButtonAction(isApply: isApply)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureView()
    }
    
    private func configureText(isApply: Bool) {
        if isApply {
            viewHolder.titleLabel.text = Text.Apply.title
            viewHolder.descriptionLabel.text = Text.Apply.description
            viewHolder.dismissButton.setCustomFont(
                text: Text.Apply.dismiss,
                color: .black,
                font: .body2m
            )
            viewHolder.confirmButton.setCustomFont(
                text: Text.Apply.confirm,
                color: .red500,
                font: .body2m
            )
        } else {
            viewHolder.titleLabel.text = Text.Cancel.title
            viewHolder.descriptionLabel.text = Text.Cancel.description
            viewHolder.dismissButton.setCustomFont(
                text: Text.Cancel.dismiss,
                color: .black,
                font: .body2m
            )
            viewHolder.confirmButton.setCustomFont(
                text: Text.Cancel.confirm,
                color: .red500,
                font: .body2m
            )
        }
    }
    
    private func configureButtonAction(isApply: Bool) {
        if isApply {
            viewHolder.dismissButton
                .tapPublisher
                .sink { [weak self] in
                    self?.didTapDismissButton()
                }.store(in: &cancellable)
            viewHolder.confirmButton
                .tapPublisher
                .sink { [weak self] in
                    self?.didTapApplyButton()
                }.store(in: &cancellable)
        } else {
            viewHolder.dismissButton
                .tapPublisher
                .sink { [weak self] in
                    self?.didTapBackButton()
                }.store(in: &cancellable)
            viewHolder.confirmButton
                .tapPublisher
                .sink { [weak self] in
                    self?.didTapDismissButton()
                }.store(in: &cancellable)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private func didTapDismissButton() {
        listener?.didTapDismissButton()
    }
    
    private func didTapApplyButton() {
        listener?.didTapApplyButton()
    }
    
    private func didTapBackButton() {
        listener?.didTapBackButton()
    }
}
