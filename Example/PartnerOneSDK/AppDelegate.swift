//
//  AppDelegate.swift
//  PartnerOneSDK
//
//  Created by ci-mobile-unicred on 12/06/2022.
//  Copyright (c) 2022 ci-mobile-unicred. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      let worker = PartnerOneWorker(apiURL: "")
      let viewModel = ScanViewModel(worker: worker, transactionID: "")
      let rootViewController = ScanViewController(viewModel: viewModel, viewTitle: "Frente")
      let navigationController = UINavigationController(rootViewController: rootViewController)
      navigationController.setNavigationBarHidden(true, animated: false)
      
      let window = UIWindow(frame: window!.bounds)
      window.rootViewController = navigationController
      window.makeKeyAndVisible()
      
      self.window = window
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}

