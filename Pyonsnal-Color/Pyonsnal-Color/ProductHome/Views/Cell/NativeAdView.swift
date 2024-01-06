//
//  NativeAdView.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 12/24/23.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class NativeAdView : GADNativeAdView {
    private let viewHolder: ViewHolder = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewHolder.place(in: self)
        viewHolder.configureConstraints(for: self)
        bindViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViews() {
        Log.d(message: "id \(UserInfoService.shared.adId)")
        headlineView = viewHolder.headlineLabel
        callToActionView = viewHolder.installButton
        iconView = viewHolder.iconImageView
        bodyView = viewHolder.adDescriptionLabel
        storeView = viewHolder.storeLabel
        priceView = viewHolder.priceLabel
        starRatingView = viewHolder.adStarRatedView
        advertiserView = viewHolder.advertiserLabel
        mediaView = viewHolder.adMediaView
    }
    
    final class ViewHolder: ViewHolderable {
        let adTagLabel: UILabel = {
            let label = UILabel()
            label.text = "AD"
            label.backgroundColor = .yellow
            return label
        }()
        
        let iconImageView: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()
        
        let headlineLabel: UILabel = {
            let label = UILabel()
            return label
        }()
        
        let adStarRatedView: StarRatedView = {
            let starRatedView = StarRatedView(score: 0)
            return starRatedView
        }()
        
        let advertiserLabel: UILabel = {
            let label = UILabel()
            label.contentMode = .left
            return label
        }()
        
        let adDescriptionLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 2
            label.contentMode = .left
            return label
        }()
        
        let installButton: UIButton = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.setTitle("Install", for: .normal)
            return button
        }()
        
        let priceLabel: UILabel = {
            let label = UILabel()
            return label
        }()
        
        let storeLabel: UILabel = {
            let label = UILabel()
            return label
        }()
        
        let adMediaView: GADMediaView = {
            let mediaView = GADMediaView()
            return mediaView
        }()
        
        func place(in view: UIView) {
            view.addSubview(iconImageView)
            view.addSubview(adTagLabel)
            view.addSubview(headlineLabel)
            view.addSubview(advertiserLabel)
            view.addSubview(adStarRatedView)
            view.addSubview(adDescriptionLabel)
            view.addSubview(installButton)
            view.addSubview(priceLabel)
            view.addSubview(storeLabel)
            view.addSubview(adMediaView)
        }
        
        func configureConstraints(for view: UIView) {
            iconImageView.snp.makeConstraints { make in
                iconImageView.backgroundColor = .red
                make.leading.top.equalToSuperview().offset(12)
                make.size.equalTo(50)
            }
            
            adTagLabel.snp.makeConstraints { make in
                make.leading.equalTo(iconImageView.snp.leading)
                make.top.equalTo(iconImageView.snp.top)
            }
            
            headlineLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            }
            
            advertiserLabel.snp.makeConstraints { make in
                make.leading.equalTo(headlineLabel.snp.leading)
                make.top.equalTo(headlineLabel.snp.bottom).offset(12)
            }
            
            adStarRatedView.snp.makeConstraints { make in
                make.top.equalTo(headlineLabel.snp.bottom)
                make.leading.equalTo(headlineLabel.snp.leading).offset(12)
            }
            
            adDescriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(iconImageView.snp.bottom).offset(12)
                make.leading.equalToSuperview().offset(12)
                make.trailing.equalToSuperview().inset(12)
            }
            
            installButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.trailing.equalToSuperview().inset(12)
            }
            
            priceLabel.snp.makeConstraints { make in
                make.top.equalTo(installButton.snp.top)
                make.leading.equalTo(headlineLabel.snp.trailing).offset(12)
            }
            
            storeLabel.snp.makeConstraints { make in
                make.top.equalTo(installButton.snp.bottom)
                make.trailing.equalToSuperview().inset(12)
            }
            
            adMediaView.snp.makeConstraints { make in
                adMediaView.backgroundColor = .red
                make.top.equalTo(adDescriptionLabel.snp.bottom).offset(8)
                make.height.equalTo(100)
            }
        }
        
    }
    
}
