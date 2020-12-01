//
//  SceneDelegate.swift
//  Beer Connect
//
//  Created by Synsoft on 20/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // NetworkManager.shared.initializeLoader()
        self.window = UIWindow(windowScene: windowScene)
        setUpRootViewController()
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

@available(iOS 13.0, *)
extension SceneDelegate {
    func setUpRootViewController() {
        
        let storyBoard = UIStoryboard.init(name: STORYBOARDCONS.ONBOARD,
                                           bundle: Bundle.main)
        if let loginVC = storyBoard.instantiateViewController(
            withIdentifier: VCIDENTIFIER.LOGINVC)
            as? LoginViewController {
            self.navigationController = UINavigationController(rootViewController: loginVC)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.window?.rootViewController = self.navigationController
            self.window?.makeKeyAndVisible()
            
        }
        
        
        
        //let isLogin = UserDefaults.standard.bool(forKey: "login")
        //      if isLogin {
        
        //let storyBoard = UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
        // bundle: Bundle.main)
        // if let mainTabBarVC = storyBoard.instantiateViewController(
        //  withIdentifier: VCIDENTIFIER.CUSTOMTABBARVC)
        //  as? CustomTabBarController {
        //self.navigationController = UINavigationController(rootViewController: mainTabBarVC)
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
        // self.navigationController?.navigationBar.prefersLargeTitles = true
        // UIApplication.shared.windows.first?.rootViewController = mainTabBarVC
        // self.window?.rootViewController = mainTabBarVC//self.navigationController
        
        //}
        //} else {
        
    }
}
