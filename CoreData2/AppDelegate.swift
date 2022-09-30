//
//  AppDelegate.swift
//  CoreData2
//
//  Created by Александр on 29.09.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate { // Если SceneDelegate

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds) // frame - окно, UIWindow - окно которое видит пользователь. Определяем границы окна(frame) по границе экрана UIScreen.main.bounds
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) { //прежде чем выгрузить приложение из памяти, мы сохраним изменение в базу данных
        saveContext()
    }

    // MARK: - Всё что ниже, надо перенести в class StorageManager
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = { // точка входа в базу данных; ленивое свойтсво, потому что не факт что первый экран приложения должен иметь доступ к базе; именно за это и отвечает это свойство. Именно поэтому свойство ленивое. В StorageManager lazy не нужно
        
        let container = NSPersistentContainer(name: "CoreData2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () { // при любом изменении приложения данные будут сохранены либо выйдет fatalError
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

