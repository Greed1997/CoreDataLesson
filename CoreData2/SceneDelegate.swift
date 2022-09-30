//
//  SceneDelegate.swift
//  CoreData2
//
//  Created by Александр on 29.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate { // служит для работы со сценами

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible() // делает экран ключевым и видимым ( изначально он не ключевой и невидимый ) Что значит ключевой?
        window?.rootViewController = UINavigationController(rootViewController: ViewController()) // почему здесь я инициализирую экземпляр класса через UINavigationController при этом беря для rootViewController ViewController() при том, что у нас нет пустого инициализатора класса ViewController, а не UIViewController()
    }
}

