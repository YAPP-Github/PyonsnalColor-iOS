//
//  AppDelegate.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/27.
//

import UIKit
import FirebaseCore
import AdSupport
import AppTrackingTransparency
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        usleep(300000)
        UserInfoService.shared.configure()
        FirebaseApp.configure()
        requestAppTransparency()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
    
    private func requestAppTransparency() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .notDetermined, .restricted, .denied:
                    break
                case .authorized:
                    Log.i(message: "\(ASIdentifierManager.shared().advertisingIdentifier)")
                @unknown default:
                    break
                }
            }
        }
    }
}
