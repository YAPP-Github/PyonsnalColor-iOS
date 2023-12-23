//
//  NativeAdCell.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 12/23/23.
//

import UIKit
import SnapKit
import GoogleMobileAds

final class NativeAdCell: UICollectionViewCell {
    private var adMobManager: AdMobManager?
    let nativeAdView = NativeAdView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAdMobManagerIfNeeded(adMobManager: AdMobManager) {
        if self.adMobManager != nil { return }
        self.adMobManager = adMobManager
        self.adMobManager?.delegate = self
        self.adMobManager?.loadAd()
    }
    
    private func configureView() {
        contentView.addSubview(nativeAdView)
        nativeAdView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - NativeAdCell
extension NativeAdCell: AdMobManagerDelegate {
    func didReceive(nativeAd: GADNativeAd) {
        // nativeAd.delegate = self
        print("Received native ad: \(nativeAd)")
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

      // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
      // ratio of the media it displays.
      if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
        let heightConstraint = NSLayoutConstraint(
          item: mediaView,
          attribute: .height,
          relatedBy: .equal,
          toItem: mediaView,
          attribute: .width,
          multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
          constant: 0)
        heightConstraint.isActive = true
      }

      // These assets are not guaranteed to be present. Check that they are before
      // showing or hiding them.
      (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
      nativeAdView.bodyView?.isHidden = nativeAd.body == nil

      (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
      nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

      (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
      nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        if let starRating = nativeAd.starRating as? Double {
            (nativeAdView.starRatingView as? StarRatedView)?.updateScore(to: starRating)
            nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil
        }

      (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
      nativeAdView.storeView?.isHidden = nativeAd.store == nil

      (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
      nativeAdView.priceView?.isHidden = nativeAd.price == nil

      (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
      nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

      // In order for the SDK to process touch events properly, user interaction should be disabled.
      nativeAdView.callToActionView?.isUserInteractionEnabled = false

      // Associate the native ad view with the native ad object. This is
      // required to make the ad clickable.
      // Note: this should always be done after populating the ad views.
      nativeAdView.nativeAd = nativeAd
        
    }
    
    func didFailToReceiveAd(with error: Error) {
        Log.d(message: "error")
    }
}
