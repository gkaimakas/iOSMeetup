//
//  SceneDelegate.swift
//  iOSMeetup
//
//  Created by George Kaimakas on 6/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import iOSMeetupCore
import iOSMeetupUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController(main: MainViewModel(postProvider: PostProvider())))
        window?.makeKeyAndVisible()
    }
}

