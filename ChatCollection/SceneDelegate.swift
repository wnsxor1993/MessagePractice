//
//  SceneDelegate.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = .init(windowScene: windowScene)
        
        let mainVC: UIViewController = MessageViewController()
        
        self.window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
    }
}

