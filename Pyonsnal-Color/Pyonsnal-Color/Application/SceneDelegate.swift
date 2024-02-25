//
//  SceneDelegate.swift
//  Pyonsnal-Color
//
//  Created by 김진우 on 2023/05/27.
//

import KakaoSDKAuth
import KakaoSDKCommon
import ModernRIBs
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var launchRouter: LaunchRouting?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window: UIWindow = .init(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()

        let rootBuilder: RootBuilder = .init(dependency: AppComponent())
        let launchRouter: LaunchRouting = rootBuilder.build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        KakaoSDK.initSDK(appKey: "ab08022b3cceb8820b6d466a9ba01847")
        
        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        } else {
            self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // Naver tracker
        // Universal Link URL. App is running or suspended in memory
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            dump(userActivity.webpageURL)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            dump(url)
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}
