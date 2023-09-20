//
//  RatingView.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/20.
//

import Combine
import UIKit
import SnapKit

final class RatingView: UIView {
    
    enum ViewMode: String {
        case large, medium
    }
    
    enum Image {
        static let star: String = "star"
        static let starFilled: String = "star.filled"
    }
    
    private let mode: ViewMode
    private let totalScore: Int = 5
    private var currentScore: Double = 0
    private var buttons: [UIButton] = []
    private var cancellable = Set<AnyCancellable>()
    var starImage: UIImage? {
        return UIImage(named: "\(Image.star).\(mode.rawValue)")
    }
    var starFilledImage: UIImage? {
        return UIImage(named: "\(Image.starFilled).\(mode.rawValue)")
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    init(mode: ViewMode, isEnabled: Bool) {
        self.mode = mode
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
        configureStarButton()
        configureButtonAction()
        configureButtonsState(isEnabled: isEnabled)
    }
    
    /// 별점을 선택할 수 있는 뷰를 생성합니다.
    convenience init() {
        self.init(mode: .large, isEnabled: true)
    }
    
    /// 해당 점수의 별점을 보여주기 위한 뷰를 생성합니다.
    convenience init(score: Double) {
        self.init(mode: .medium, isEnabled: false)
    
        fillStarRate(score: score)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(stackView)
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureStarButton() {
        for i in 0..<totalScore {
            let button = UIButton()
            button.setImage(starImage, for: .normal)
            button.tag = i
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func configureButtonAction() {
        buttons.forEach { button in
            button
                .tapPublisher
                .sink { [weak self] in
                    self?.didTapRatingButton(button)
                }.store(in: &cancellable)
        }
    }
    
    private func configureButtonsState(isEnabled: Bool) {
        buttons.forEach { $0.isEnabled = isEnabled }
    }
    
    private func fillStarRate(score: Double) {
        fillIntegerRate(score: Int(score) - 1)
        fillDecimalRate(score: score)
        currentScore = score
    }
    
    private func fillDecimalRate(score: Double) {
        guard let imageSize = starFilledImage?.size,
              score < 5
        else {
            return
        }
        
        let decimalPoint = score - Double(Int(score))
        let cropSize = CGRect(
            x: 0,
            y: 0,
            width: imageSize.width * decimalPoint,
            height: imageSize.height
        )
        let imageView = UIImageView(frame: cropSize)
        imageView.image = starFilledImage
        imageView.clipsToBounds = true
        imageView.contentMode = .left
        
        buttons[Int(score)].addSubview(imageView)
    }
    
    private func fillIntegerRate(score: Int) {
        for i in 0..<totalScore {
            if i <= score {
                buttons[i].setImage(starFilledImage, for: .normal)
            } else {
                buttons[i].setImage(starImage, for: .normal)
            }
        }
    }
    
    private func didTapRatingButton(_ sender: UIButton) {
        let index = sender.tag
        
        fillIntegerRate(score: index)
        currentScore = Double(index + 1)
    }
}

