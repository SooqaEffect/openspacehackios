//
//  AppDelegate.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "WaterMeterCamera", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WaterMeterCameraController")
        let vc = buildModule()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
    
    private func buildModule() -> UIViewController {
        let urlManager = URLManager(with: "http://176.99.11.66:8080/api/")
        let baseNetworkManager = BaseNetworkManager(with: 30, timeoutResoucre: 30)
        let networkManager = WaterMetersNetworkManagerImpl(baseManager: baseNetworkManager, urlManager: urlManager)
        let moduleAssembly = WaterMetersCameraAssembly()
        let storyboard = UIStoryboard(name: "WaterMeterCamera", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WaterMeterCameraController") as! WaterMetersCameraViewController
        moduleAssembly.assembly(with: vc, networkManager: networkManager)
        return vc
    }
}

