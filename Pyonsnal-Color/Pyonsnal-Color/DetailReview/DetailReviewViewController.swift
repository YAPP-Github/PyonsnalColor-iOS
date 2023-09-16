//
//  DetailReviewViewController.swift
//  Pyonsnal-Color
//
//  Created by 김인호 on 2023/09/11.
//

import ModernRIBs
import UIKit

protocol DetailReviewPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class DetailReviewViewController: UIViewController, DetailReviewPresentable, DetailReviewViewControllable {
    
    enum Constant {
        static let navigationTitle: String = "상품 리뷰 작성하기"
        
        static let tasteReviewTitle: String = "상품의 맛은 어떤가요?"
        static let tasteGood: String = "맛있어요"
        static let tasteOkay: String = "보통이예요"
        static let tasteBad: String = "별로예요"
        
        static let qualityReviewTitle: String = "상품의 퀄리티는 어떤가요?"
        static let qualityGood: String = "좋아요"
        static let qualityOkay: String = "보통이예요"
        static let qualityBad: String = "별로예요"
        
        static let priceReviewTitle: String = "상품의 가격은 어떤가요?"
        static let priceGood: String = "합리적이예요"
        static let priceOkay: String = "적당해요"
        static let priceBad: String = "비싸요"
        
        static let detailReviewTitle: String = "좀 더 자세하게 알려주세요!"
        static let detailReviewPlaceholder: String = "상품에 대한 솔직한 의견을 알려주세요."
        
        static let imageUploadTitle: String = "사진 업로드"
    }
    

    weak var listener: DetailReviewPresentableListener?
    private let viewHolder = ViewHolder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.place(in: view)
        viewHolder.configureConstraints(for: view)
        configureTexts()
        view.backgroundColor = .white
    }
    
    private func configureTexts() {
        viewHolder.tasteReview.configureReviewTitle(
            title: Constant.tasteReviewTitle,
            first: Constant.tasteGood,
            second: Constant.tasteOkay,
            third: Constant.tasteBad
        )
        viewHolder.qualityReview.configureReviewTitle(
            title: Constant.qualityReviewTitle,
            first: Constant.qualityGood,
            second: Constant.qualityOkay,
            third: Constant.qualityBad
        )
        viewHolder.priceReview.configureReviewTitle(
            title: Constant.priceReviewTitle,
            first: Constant.priceGood,
            second: Constant.priceOkay,
            third: Constant.priceBad
        )
        viewHolder.detailReviewLabel.text = Constant.detailReviewTitle
        viewHolder.imageUploadLabel.text = Constant.imageUploadTitle
    }
}
