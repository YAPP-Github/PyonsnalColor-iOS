//
//  SingleLineReview.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/13.
//

import UIKit
import SnapKit

final class SingleLineReview: UIView {
    private let viewHolder = ViewHolder()
    
    convenience init() {
        self.init(frame: .zero)
        
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
        configureButtonAction()
        configureButtonTag()
    }
    
    private func configureButtonAction() {
        viewHolder.reviewButtonStackView.subviews.forEach { _ in
            // TODO: tap publisher 연결 예정
        }
    }
    
    private func configureButtonTag() {
        for (tag, button) in viewHolder.reviewButtonStackView.subviews.enumerated() {
            button.tag = tag
        }
    }
    
    private func setSelectedButtonState(at tag: Int) {
        guard let button = viewHolder.reviewButtonStackView.subviews[tag] as? UIButton else {
            return
        }
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.removeBorder()
    }
    
    private func setDeselectedButtonState(at tag: Int) {
        guard let button = viewHolder.reviewButtonStackView.subviews[tag] as? UIButton else {
            return
        }
        
        button.setTitleColor(.gray400, for: .normal)
        button.backgroundColor = .white
        button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
    }
    
    func configureReviewTitle(title: String, first: String, second: String, third: String) {
        viewHolder.titleLabel.text = title
        viewHolder.firstReviewButton.setTitle(first, for: .normal)
        viewHolder.secondReviewButton.setTitle(second, for: .normal)
        viewHolder.thirdReviewButton.setTitle(third, for: .normal)
    }
    
    func didSelectReviewButton(_ sender: UIButton) {
        let tag = sender.tag
        
        viewHolder.reviewButtonStackView.subviews.forEach {
            $0.tag == tag ? setSelectedButtonState(at: tag) : setDeselectedButtonState(at: tag)
        }
    }
}

extension SingleLineReview {
    final class ViewHolder: ViewHolderable {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .title1
            return label
        }()
        
        let reviewButtonStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            stackView.spacing = .spacing8
            return stackView
        }()
        
        let firstReviewButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            button.makeRounded(with: .spacing8)
            button.setTitleColor(.gray400, for: .normal)
            button.titleLabel?.font = .body3m
            return button
        }()
        
        let secondReviewButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            button.makeRounded(with: .spacing8)
            button.setTitleColor(.gray400, for: .normal)
            button.titleLabel?.font = .body3m
            return button
        }()
        
        let thirdReviewButton: UIButton = {
            let button = UIButton()
            button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
            button.makeRounded(with: .spacing8)
            button.setTitleColor(.gray400, for: .normal)
            button.titleLabel?.font = .body3m
            return button
        }()
        
        func place(in view: UIView) {
            view.addSubview(titleLabel)
            view.addSubview(reviewButtonStackView)
            
            reviewButtonStackView.addArrangedSubview(firstReviewButton)
            reviewButtonStackView.addArrangedSubview(secondReviewButton)
            reviewButtonStackView.addArrangedSubview(thirdReviewButton)
        }
        
        func configureConstraints(for view: UIView) {
            titleLabel.snp.makeConstraints {
                $0.leading.top.equalTo(view)
            }
            
            reviewButtonStackView.snp.makeConstraints {
                $0.leading.bottom.trailing.equalTo(view)
                $0.top.equalTo(titleLabel.snp.bottom).offset(.spacing20)
                $0.height.equalTo(36)
            }
        }
    }
}
