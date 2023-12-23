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

class AdMobManager: NSObject {
    enum Key: String {
        case GADApplicationIdentifier
    }
    
    weak var fromViewController: UIViewController?
    weak var delegate: AdMobManagerDelegate?
    private var loadAdType: [GADAdLoaderAdType]
    private var adUnitID: String? {
        return "ca-app-pub-3940256099942544/3986624511"
//        return "ca-app-pub-5808818560574239/7697776597"
//        Bundle.main.object(forInfoDictionaryKey: Key.GADApplicationIdentifier.rawValue) as? String
    }
    
    lazy var adLoader: GADAdLoader? = {
        guard let adUnitID else { return nil }
        let loader = GADAdLoader(
            adUnitID: adUnitID,
            rootViewController: fromViewController,
            adTypes: loadAdType,
            options: []
        )
        return loader
    }()
    
    init(fromViewController: UIViewController, loadAdType: [GADAdLoaderAdType]) {
        self.fromViewController = fromViewController
        self.loadAdType = loadAdType
    }
    
    func loadAd() {
        adLoader?.delegate = self
        let reuqest = GADRequest()
        adLoader?.load(reuqest)
    }

}

extension AdMobManager: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        // A native ad has loaded, and can be displayed.
        delegate?.didReceive(nativeAd: nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        // The adLoader has finished loading ads, and a new request can be sent.
        delegate?.didFailToReceiveAd(with: error)
    }
}
