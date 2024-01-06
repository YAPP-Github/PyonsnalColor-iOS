//
//  AdMobManager.swift
//  Pyonsnal-Color
//
//  Created by 조소정 on 12/23/23.
//

import UIKit
import GoogleMobileAds

protocol AdMobManagerDelegate: AnyObject {
    func didReceive(nativeAd: GADNativeAd)
    func didFailToReceiveAd(with error: Error)
}

final class AdMobManager: NSObject {
    enum AdUnitIdType: String {
        case curationMiddleAd // 큐레이션 중간 광고
        
        var adUnitId: String {
            switch self {
            case .curationMiddleAd:
                #if DEBUG
                    return "ca-app-pub-5808818560574239/7697776597"
                #else
                    return "ca-app-pub-3940256099942544/3986624511"
                #endif
            }
        }
    }
    
    weak var fromViewController: UIViewController?
    weak var delegate: AdMobManagerDelegate?
    private var loadAdType: [GADAdLoaderAdType]
    private var adUnitIdType: AdUnitIdType
    
    lazy var adLoader: GADAdLoader = {
        let loader = GADAdLoader(
            adUnitID: adUnitIdType.adUnitId,
            rootViewController: fromViewController,
            adTypes: loadAdType,
            options: []
        )
        return loader
    }()
    
    init(
        fromViewController: UIViewController,
        loadAdType: [GADAdLoaderAdType],
        adUnitIdType: AdUnitIdType
    ) {
        self.fromViewController = fromViewController
        self.loadAdType = loadAdType
        self.adUnitIdType = adUnitIdType
    }
    
    func loadAd() {
        adLoader.delegate = self
        let reuqest = GADRequest()
        adLoader.load(reuqest)
    }

}

extension AdMobManager: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        delegate?.didReceive(nativeAd: nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        delegate?.didFailToReceiveAd(with: error)
    }
}
