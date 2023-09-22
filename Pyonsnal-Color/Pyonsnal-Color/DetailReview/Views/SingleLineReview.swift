//
//  SingleLineReview.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/13.
//

import UIKit
import Combine
import SnapKit

protocol SingleLineReviewDelegate: AnyObject {
    func didSelectReview(_ review: Review)
}

final class SingleLineReview: UIView {

    private let viewHolder = ViewHolder()
    private let category: Review.Category
    private var cancellable = Set<AnyCancellable>()
    var delegate: SingleLineReviewDelegate?
    
    init(category: Review.Category) {
        self.category = category
        super.init(frame: .zero)
        
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
        configureButtonAction()
        configureButtonTag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButtonAction() {
        viewHolder.reviewButtonStackView.subviews
            .compactMap { $0 as? UIButton }
            .forEach { button in
                button
                    .tapPublisher
                    .sink { [weak self] in
                        self?.didSelectReviewButton(button)
                    }.store(in: &cancellable)
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
        
        button.isSelected = true
        button.backgroundColor = .black
        button.removeBorder()
    }
    
    private func setDeselectedButtonState(at tag: Int) {
        guard let button = viewHolder.reviewButtonStackView.subviews[tag] as? UIButton else {
            return
        }
        
        button.isSelected = false
        button.backgroundColor = .white
        button.makeBorder(width: 1, color: UIColor.gray200.cgColor)
    }

    private func didSelectReviewButton(_ sender: UIButton) {
        let tag = sender.tag
        let score = Review.Score.allCases[tag]
        let review = Review(category: category, score: score)
        
        viewHolder.reviewButtonStackView.subviews.forEach {
            $0.tag == tag ? setSelectedButtonState(at: tag) : setDeselectedButtonState(at: $0.tag)
        }
        delegate?.didSelectReview(review)
    }
    
    func configureReviewTitle(title: String, first: String, second: String, third: String) {
        viewHolder.titleLabel.text = title
        viewHolder.firstReviewButton.configureButtonTitle(text: first)
        viewHolder.secondReviewButton.configureButtonTitle(text: second)
        viewHolder.thirdReviewButton.configureButtonTitle(text: third)
    }
    
    func hasSelected() -> Bool {
        let result = viewHolder.reviewButtonStackView.subviews
            .compactMap { $0 as? UIButton }
            .filter { $0.isSelected }
            .count
        
        return result == 1 ? true : false
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
        
        let firstReviewButton = ReviewButton()
        let secondReviewButton = ReviewButton()
        let thirdReviewButton = ReviewButton()
        
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
